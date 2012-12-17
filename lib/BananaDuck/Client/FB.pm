package BananaDuck::Client::FB;

use Mojo::Base -base;
use Mojo::UserAgent;
use Mojo::URL;
use BananaDuck::Exception::API;
use BananaDuck::FB::User;

has [qw(app_id app_secret access_token redirect_uri)];

has ua => sub {
    Mojo::UserAgent->new
};

has url => sub {
    Mojo::URL->new('https://graph.facebook.com');
};

has dialog_url => sub {
    Mojo::URL->new('http://www.facebook.com/dialog/oauth');
};


sub get_dialog_url {
    my ($self, $state) = @_;

    my $dialog_url = $self->dialog_url;
    $dialog_url->query(
        client_id    => $self->app_id,
        redirect_uri => $self->redirect_uri,
        state        => $state,
        scope        => 'user_birthday,email,publish_stream',
    );
    return $dialog_url;
}

sub get_access_token {
    my ($self, $code) = @_;

    my $url = $self->url->path('/oauth/access_token');
    $url->query(
        client_id     => $self->app_id,
        redirect_uri  => $self->redirect_uri,
        client_secret => $self->app_secret,
        code          => $code
    );

    my $response = $self->get($url)->body;
    my ($access_token, $expires) = $response =~ /access_token=(.*)&expires=(.*)/;

    return ($access_token, $expires);
}

sub me {
    my ($self) = @_;

    my $url = $self->url->path('/me');
    $url->query(
        access_token => $self->access_token,
        fields       => 'id,username,name,email,birthday,gender,picture',
    );

    my $user = $self->get($url)->json;
    $user->{_client} = $self;

    return BananaDuck::FB::User->new($user);
}

# http://developers.facebook.com/docs/reference/api/user/#posts
sub create_post {
    my ($self, $data) = @_;

    my $url = $self->url->path('/me/feed');
    my $res = $self->post($url, $data)->json;
    return $res;
}

sub get {
    my ($self, $url) = @_;

    my $tx = $self->ua->get($url);
    return $self->handle_errors($tx);
}

sub post {
    my ($self, $url, $data) = @_;

    my $tx = $self->ua->post_form($url, $data);
    return $self->handle_errors($tx);
}

sub handle_errors {
    my ($self, $tx) = @_;
    my $res = $tx->res;

    unless ($tx->success) { # errors are in JSON format
        my ($error, $code) = $tx->error;

        my $json = $res->json;

        BananaDuck::Exception::API->throw(
            error             => 'facebook_error',
            error_description => $code ? "$code $error $json->{error}{message}" : $error,
            data              => { facebook_error => $json->{error} },
        );
    }
    return $res;
}

1;
