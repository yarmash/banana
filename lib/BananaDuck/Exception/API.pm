package BananaDuck::Exception::API;

use Mojo::Base 'BananaDuck::Exception';

has [qw(
    error
    error_description
    data
    res_callback
)];

has http_status_code => 500; # Internal Server Error

1;
