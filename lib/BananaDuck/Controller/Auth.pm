package BananaDuck::Controller::Auth;

use Mojo::Base 'Mojolicious::Controller';

sub check {
    my ($self) = @_;

    unless ($self->is_user_authenticated) {
        $self->redirect_to('/login?url='.$self->url_for->to_abs);
        return 0;
    }
    return 1;
}

1;
