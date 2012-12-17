package BananaDuck::API::Method::UserProfile;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    my $user = $self->ctx->user;

    return BananaDuck::API::Result::User->new(user => $user);
}

1;
