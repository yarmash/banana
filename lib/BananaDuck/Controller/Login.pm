package BananaDuck::Controller::Login;

use Mojo::Base 'Mojolicious::Controller';
use BananaDuck::Form;

sub process {
    my ($self) = @_;

    my $form = $self->get_form;

    if ($form->is_submitted && $form->validate) {
        my $values = $form->get_values;

        if ($self->authenticate($values->{login}, $values->{password})) {
            my $url = $self->param("url") || "/";
            return $self->redirect_to($url);
        }
    }

    $self->render(template => 'login', form => $form);
}

sub get_form {
    my ($self) = @_;

    my @fields = (
        {
            name     => "login",
            label    => "Login",
            required => 1,
            type     => "text",
        },
        {
            name     => "password",
            label    => "Password",
            required => 1,
            type     => "password",
        },
    );

    return BananaDuck::Form->new({ c => $self, fields => \@fields });
}

1;
