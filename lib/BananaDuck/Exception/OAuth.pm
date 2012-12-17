package BananaDuck::Exception::OAuth;

use Mojo::Base 'BananaDuck::Exception::API';

has http_status_code => 400; # Bad Request

1;
