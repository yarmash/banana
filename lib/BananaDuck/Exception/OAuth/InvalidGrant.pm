package BananaDuck::Exception::OAuth::InvalidGrant;

use Mojo::Base 'BananaDuck::Exception::OAuth';

has error => 'invalid_grant';

1;
