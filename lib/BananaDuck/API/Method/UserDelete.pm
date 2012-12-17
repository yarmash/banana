package BananaDuck::API::Method::UserDelete;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    my $user = $self->ctx->user;

    $user->delete;

    if (my $avatar = $user->avatar) {
        $self->delete_file($avatar);
    }

    return BananaDuck::API::Result->new();
}

1;
