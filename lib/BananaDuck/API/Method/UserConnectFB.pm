package BananaDuck::API::Method::UserConnectFB;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Client::FB;

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
    my $connection = $self->schema->resultset('FbConnection')->update_or_create(
        {
            user_id         => $self->ctx->user->id,
            fb_id           => $fb_user->{id},
            fb_access_token => $params->{fb_access_token},
        },
        {
            key => 'primary'
        }
    );
    return BananaDuck::API::Result->new;
}

1;
