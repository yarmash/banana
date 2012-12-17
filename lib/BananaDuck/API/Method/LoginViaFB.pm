package BananaDuck::API::Method::LoginViaFB;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Utils qw(get_uuid_hex get_file_url);
use BananaDuck::Constants 'AUTH_CLIENT';
use BananaDuck::Client::FB;

has auth_level => AUTH_CLIENT;

has params_info => sub { +{
    fb_access_token => { required => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $client = BananaDuck::Client::FB->new(
        ua => $self->ctx->ua,
        access_token => $params->{fb_access_token},
    );

    my $fb_user = $client->me;
    my $user;

    if (my $connection = $self->schema->resultset('FbConnection')->find({ fb_id => $fb_user->{id} }, { prefetch => 'user' })) {
        $user = $connection->user;
        $connection->update({ fb_access_token => $params->{fb_access_token} });
    }
    else { # try to create a new user
        my %data = (
            login     => $fb_user->{username},
            full_name => $fb_user->{name},
            email     => $fb_user->{email},
            sex       => $fb_user->{gender},
            birthday  => $fb_user->{birthday},
            is_email_confirmed => 1,
            fb_connection => {
                fb_id => $fb_user->{id},
                fb_access_token => $params->{fb_access_token},
            },
        );

        my $picture;

        if ($picture = $fb_user->picture) { # user has uploaded a profile picture
            $data{avatar} = get_file_url($picture->filename); # generate a new file url
        }

        eval { $user = $self->create_user(\%data) };

        if ($@) {
            BananaDuck::Exception::API->throw(
                _error            => $@, # just to show up in log
                error             => 'internal_error',
                error_description => "Error creating user",
                data              => { facebook_profile => $fb_user->data },
            );
        }
        $self->save_file($picture, $data{avatar}) if $picture;
    }

    my $token = $self->schema->resultset('Token')->find_or_create(
        {
            client_id => $self->ctx->client->id,
            user_id   => $user->id,
            token     => get_uuid_hex,
        },
        {
            key => 'primary',
        }
    );
    return BananaDuck::API::Result->new(data => { token => { access_token => $token->token, token_type => 'bearer' } } );
}

1;
