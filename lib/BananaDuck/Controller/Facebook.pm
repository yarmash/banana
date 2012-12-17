package BananaDuck::Controller::Facebook;

use Mojo::Base 'Mojolicious::Controller';
use BananaDuck::Utils 'get_oauth_state_param';
use BananaDuck::Client::FB;

sub authorize {
    my ($self) = @_;

    my $config = $self->app->config;

    my $client = BananaDuck::Client::FB->new(
        ua => $self->ua,
        app_id => $config->{facebook}{app_id},
        app_secret => $config->{facebook}{app_secret},
        redirect_uri => $self->url_for->to_abs."",
    );

    my $state = $self->param('state');

    if (!$state) {
        $state = get_oauth_state_param;
        $self->session(state => $state);

        my $dialog_url = $client->get_dialog_url($state);
        $self->app->log->debug("Using dialog url: $dialog_url");
        $self->redirect_to($dialog_url);
        return 0;
    }

    if ($self->session->{state} && delete $self->session->{state} eq $state) {
        if (my $code = $self->param('code')) {
            my ($access_token, $expires) = $client->get_access_token($code);
            $self->stash(access_token => $access_token)->stash(expires => $expires);
            return 1;
        }
    }
    else {
        $self->app->log->warn('The state does not match. Possible CSRF attempt.');
    }
    $self->render(template => 'facebook_error');
    return 0;
}

1;
