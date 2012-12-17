package BananaDuck::Controller::API;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util 'b64_decode';
use Encode;
use BananaDuck::API::MethodFactory;
use BananaDuck::API::Context;
use BananaDuck::Constants ':auth_levels';
use BananaDuck::Message;

sub call_api {
    my ($self) = @_;

    eval {
        my $params = $self->get_params; # route captures are also there
        my $method_name = join '', map ucfirst, split /\//, delete $params->{api_method};
        my $result = $self->execute_method($method_name, $params);

        $self->render(json => $result);
    };

    if (my $e = $@) {
        $self->app->log->debug("Caught an exception: $e");

        if ($e->isa('BananaDuck::Exception::API')) { # OAuth and other API exceptions
            $e->res_callback->($self->res) if $e->res_callback;

            $self->render(
                status => $e->http_status_code,
                json   => { error => $e->error, error_description => $e->error_description, $e->data ? %{ $e->data } : () },
            );
        }
        else { # likely Mojo::Exception
            $self->render(
                status => 500,
                json   => { error => 'internal_server_error', error_description => "$e" },
            );
        }
    }
}

sub execute_method {
    my ($self, $method_name, $params) = @_;

    $self->app->log->debug("Calling the API method: $method_name, params: "
        .decode('utf-8', $self->render_partial(json => $params)));

    my ($token, $client);

    my $method = BananaDuck::API::MethodFactory->createMethod($method_name);

    if ((my $auth_level = $method->auth_level) == AUTH_TOKEN) {
        $token = $self->validate_token;
    }
    elsif ($auth_level == AUTH_CLIENT) {
        my ($client_id, $client_secret) = delete @$params{qw(client_id client_secret)};
        $client = $self->authenticate_client($client_id, $client_secret);
    }
    else {
        $auth_level == AUTH_NONE or die "Unknown auth_level for $method_name";
    }

    my $ctx = BananaDuck::API::Context->new(
        schema => $self->db,
        home   => $self->app->home,
        ua     => $self->ua,
        config => $self->app->config,
        token  => $token,
        client => $client,
        lang   => $self->stash('lang'),
        resque => $self->resque,
        log    => $self->app->log,
    );

    $method->ctx($ctx);
    $method->validate_params($params);

    my $result = $method->execute($params) # BananaDuck::API::Result
        ->result;
    $self->app->log->debug("$method_name: ".decode("utf-8", Mojo::JSON->new->encode($result)));

    return $result;
}

# Authenticates the client using Basic Access Authentication OR parameters in the request body
# Returns the client object on success.
# On error throws a BananaDuck::Exception::OAuth exception
sub authenticate_client {
    my ($self, $client_id, $client_secret) = @_;

    my $authorization = $self->req->headers->authorization;
    $self->app->log->debug(sprintf 'Authorization: %s', defined $authorization ? qq("$authorization") : 'none');

    if ($authorization) {
        if ($client_id || $client_secret) { # either Basic auth or params. but not both
            BananaDuck::Exception::OAuth::InvalidRequest->throw(
                error_description => 'More than one authentication method used',
            );
        }

        if ($authorization =~ /Basic (.+)$/) {
            ($client_id, $client_secret) = split /:/, b64_decode($1), 2;
        }
        else {
            BananaDuck::Exception::OAuth::InvalidClient->throw(
                error_description => 'Unsupported authentication method',
            );
        }
    }
    else {
        if (!($client_id && $client_secret)) {
            BananaDuck::Exception::OAuth::InvalidClient->throw(
                error_description => 'No client authentication included',
            );
        }
    }

    my $client;

    if ($client_id !~ /^[0-9]+\z/ || !( ($client) = $self->db->resultset('Client')->search({
        client_id => $client_id, client_secret => $client_secret }))) {

        BananaDuck::Exception::OAuth::InvalidClient->throw(
            error_description => 'Client authentication failed',
        );
    }
    $self->app->log->info(sprintf 'Client authenticated OK: client_id: %d', $client->client_id);

    return $client;
}

# Validates the access token
# Returns the token object
# On error throws a BananaDuck::Exception::OAuth exception
sub validate_token {
    my ($self) = @_;

    my $authorization = $self->req->headers->authorization;
    $self->app->log->debug(sprintf 'Authorization: %s', defined $authorization ? qq("$authorization") : 'none');

    if ($authorization && (my ($token) = $authorization =~ /Bearer (.+)$/)) {
        if (my $token_obj = $self->db->resultset('Token')->find({ token => $token }, { prefetch => 'user' })) {
            $self->app->log->info(sprintf 'Token validated OK: client_id: %d, user_id: %d', $token_obj->client_id, $token_obj->user_id);
            return $token_obj;
        }
        BananaDuck::Exception::OAuth::InvalidToken->throw(
            error_description => 'The access token provided is invalid',
        );
    }
    else {
        BananaDuck::Exception::OAuth::InvalidToken->throw(
            error_description => 'No authorization or invalid authentication scheme',
            res_callback => sub {
                my ($res) = @_;
                $res->headers->www_authenticate('Bearer realm="API"');
            },
        );
    }
}

# GET/POST parameters, file uploads and route placeholder values
sub get_params {
    my ($self) = @_;

    my %params = map { my @v = $self->param($_); $_ => @v > 1 ? \@v : $v[0] } $self->param;
    $self->app->log->debug('Request params: '.decode("utf-8", Mojo::JSON->new->encode(\%params)));

    return \%params;
}

# wrapper around the image/resize API method
sub resize_image {
    my ($self) = @_;

    eval {
        my $params = $self->get_params;
        my $method_name = 'ImageResize';
        my $result = $self->execute_method($method_name, $params);

        $self->render_static($result->{image_url});
    };

    if (my $e = $@) {
        $self->app->log->debug("Caught an exception: $e");

        $self->render(
            status => 500,
            text   => $e->isa('BananaDuck::Exception::API') ? 'Error: '.$e->error_description : $e,
        );
    }
}

sub format_message {
    my ($self, $id, @args) = @_;
    return BananaDuck::Message->new(id => $id, args => \@args)->format($self->stash('lang'));
}

1;
