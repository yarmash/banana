package BananaDuck::Controller::Home;

use Mojo::Base 'Mojolicious::Controller';

sub index {
    my ($self) = @_;

    $self->render;
}

1;
