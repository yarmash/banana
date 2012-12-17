package BananaDuck::Exception::OAuth::InvalidClient;

use Mojo::Base 'BananaDuck::Exception::OAuth';

has error => 'invalid_client';
has http_status_code => 401; # Unauthorized
has res_callback => sub {
    return sub {
        my ($res) = @_;
        $res->headers->www_authenticate('Basic realm="Token Endpoint"');
    };
};

1;
