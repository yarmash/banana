package BananaDuck::Controller::Registration::Facebook;

use Mojo::Base 'BananaDuck::Controller::Registration';
use BananaDuck::Client::FB;

sub process {
    my ($self) = @_;

    my $access_token = $self->stash('access_token');
    my $client = BananaDuck::Client::FB->new(ua => $self->ua, access_token => $access_token);

    my $fb_user = $client->me;

    if (my $connection = $self->db->resultset('FbConnection')->find({ fb_id => $fb_user->{id} }, { prefetch => 'user' })) {
        my $user = $connection->user;
        $connection->update({ fb_access_token => $access_token });

        $self->flash(user_id => $user->id, exists => 1);
        $self->redirect_to('registration/welcome');
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
                fb_access_token => $access_token
            },
        );
        $self->create_user(\%data);
    }
}

1;
