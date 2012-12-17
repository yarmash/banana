package BananaDuck::API::Method::UserDeleteAvatar;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    my $user = $self->ctx->user;

    if (my $avatar = $user->avatar) {
        $self->delete_file($avatar);
    }
    $user->avatar(undef);
    $user->update;

    return BananaDuck::API::Result->new;
}

1;
