package BananaDuck::API::Method::Ping;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    return BananaDuck::API::Result->new;
}

1;
