package BananaDuck::Exception::OAuth::UnsupportedGrantType;

use Mojo::Base 'BananaDuck::Exception::OAuth';

has error => 'unsupported_grant_type';

1;
