package BananaDuck::Controller::Registration::Twitter;

use Mojo::Base 'BananaDuck::Controller::Registration';
use Net::Twitter::Lite;
use Data::Dumper;

sub process {
    my ($self) = @_;

    my $nt = $self->get_twitter_object();

    my $callback_url = $self->url_for->to_abs."/callback";

    my $url = $nt->get_authorization_url(callback => $callback_url);

    # Twitter doesn't provide a means to obtain the user's email address via the API,
    # therefore email is requested via a dialog on the client side
    my $user_email = $self->param('twitter-email');

    $self->session(token => $nt->request_token, token_secret => $nt->request_token_secret, user_email => $user_email);

    $self->redirect_to($url);
}

sub callback {
    my ($self) = @_;

    my $twitter = $self->get_twitter_object();

    $twitter->request_token( delete $self->session->{token} );
    $twitter->request_token_secret( delete $self->session->{token_secret} );

    my $verifier = $self->param("oauth_verifier");

    my ($access_token, $access_token_secret, $user_id, $screen_name) =
        $twitter->request_access_token(verifier => $verifier);

    $twitter->access_token($access_token);
    $twitter->access_token_secret($access_token_secret);

    my $info = $twitter->show_user($user_id);
    $self->app->log->debug("User info: ".Dumper $info);

    if (my $connection = $self->db->resultset('TwConnection')->find({ tw_id => $info->{id} }, { prefetch => 'user' })) {
        my $user = $connection->user;
        $connection->update({ tw_access_token => $access_token, tw_access_token_secret => $access_token_secret });

        $self->flash(user_id => $user->id, exists => 1);
        $self->redirect_to('registration/welcome');
    }
    else { # try to create a new user
        my %data = (
            login     => $screen_name,
            full_name => $info->{name},
            email     => delete $self->session->{user_email},
            is_email_confirmed => 0,
            tw_connection => {
                tw_id => $user_id,
                tw_access_token => $access_token,
                tw_access_token_secret => $access_token_secret,
            },
        );
        $self->create_user(\%data);
    }
}

sub get_twitter_object {
    my ($self) = @_;
    my $config = $self->app->config;

    my $twitter = Net::Twitter::Lite->new(
        consumer_key    => $config->{twitter}{consumer_key},
        consumer_secret => $config->{twitter}{consumer_secret},
    );
    return $twitter;
}

1;
