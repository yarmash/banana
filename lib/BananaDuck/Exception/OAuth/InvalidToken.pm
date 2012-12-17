package BananaDuck::Exception::OAuth::InvalidToken;

use Mojo::Base 'BananaDuck::Exception::OAuth';

has error => 'invalid_token';
has http_status_code => 401; # Unauthorized

has res_callback => sub {
    my ($self) = @_;

    return sub {
        my ($res) = @_;

        $res->headers->www_authenticate(
            sprintf 'Bearer realm="API",error="%s",error_description="%s"', $self->error, $self->error_description
        );
    };
};

1;
