package BananaDuck::API::Method::Logout;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    $self->ctx->token->delete;
    return BananaDuck::API::Result->new;
}

1;
