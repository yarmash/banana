package BananaDuck::Controller::Logout;

use Mojo::Base 'Mojolicious::Controller';

sub process {
    my ($self) = @_;

    if ($self->is_user_authenticated) {
        $self->logout;
    }
    return $self->redirect_to('/');
}

1;
