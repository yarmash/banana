package BananaDuck::API::Method::Login;

# Token Endpoint

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Utils 'get_uuid_hex';
use BananaDuck::Constants 'AUTH_CLIENT';

has auth_level => AUTH_CLIENT;

sub execute {
    my ($self, $params) = @_;

    # Validate the resource owner password credentials
    my $user = $self->schema->resultset('User')->by_credentials(@$params{qw(username password)});

    if (!$user) {
        BananaDuck::Exception::OAuth::InvalidGrant->throw(
            error_description => 'Invalid user credentials',
        );
    }

    my $client = $self->ctx->client;

    # Note: 'find_or_create' is subject to a race condition.
    # It shouldn't be used if a client may send multiple requests at once.
    my $token = $self->schema->resultset('Token')->find_or_create(
        {
            client_id => $client->id,
            user_id   => $user->id,
            token     => get_uuid_hex,
        },
        {
            key => 'primary',
        }
    );
    return BananaDuck::API::Result->new(data => { access_token => $token->token, token_type => 'bearer' });
}

# Validates the parameters for the Token Endpoint
# On error throws a BananaDuck::Exception::OAuth exception
sub validate_params {
    my ($self, $params) = @_;

    state $recognized_params = { map { $_ => 1 } qw(client_id client_secret grant_type username password scope) };
    my @required_params = qw(grant_type username password);

    # check for required parameters
    for my $p (@required_params) {
        if (!defined $params->{$p} || $params->{$p} eq "") {
            BananaDuck::Exception::OAuth::InvalidRequest->throw(
                error_description => qq(The request is missing the required parameter: "$p"),
            );
        }
    }

    # check for repeated parameters
    while (my ($k, $v) = each $params) {
        if ($recognized_params->{$k} && ref($v) eq 'ARRAY') {
            BananaDuck::Exception::OAuth::InvalidRequest->throw(
                error_description => qq(The request includes the repeated parameter: "$k") ,
            );
        }
    }

    if ($params->{grant_type} ne 'password') {
        BananaDuck::Exception::OAuth::UnsupportedGrantType->throw(
            error_description => 'The "grant_type" parameter should be set to "password"',
        );
    }
    return 1;
}

1;
