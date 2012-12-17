package BananaDuck::API::Method::UserDisconnectFB;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    my $user = $self->ctx->user;
    $self->schema->resultset('FbConnection')->search({ user_id => $user->id })->delete;

    return BananaDuck::API::Result->new;
}

1;
