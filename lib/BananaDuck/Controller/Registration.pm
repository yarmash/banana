package BananaDuck::Controller::Registration;

# stuff common for all registration controllers

use Mojo::Base 'Mojolicious::Controller';

use BananaDuck::Utils qw(get_salt get_password_hash get_confirmation_code);
use BananaDuck::Constants 'CONFIRMATION_EMAIL';
use BananaDuck::Form;
use Data::Dumper;

sub process {
    my ($self) = @_;

    my $form = $self->get_form;

    if ($form->is_submitted) {
        my $values = $form->get_values;
        $self->app->log->debug("Form values: ". Dumper($values));

        if ($form->validate) {
            $values->{salt} = get_salt;
            $values->{password} = get_password_hash($values->{salt}, $values->{password});
            return $self->create_user($values);
        }
    }

    $self->render(form => $form);
}

sub create_user {
    my ($self, $data) = @_;

    my $user;

    eval {
        $self->db->txn_do(sub {
            $user = $self->db->resultset('User')->create($data);

            if (!$data->{is_email_confirmed}) {
                $user->add_to_confirmations({ code => get_confirmation_code, type_id => CONFIRMATION_EMAIL });
            }
        });
    };
    if (my $error = $@) {
        # Transaction failed
        $self->app->log->error($error);
        die $error; # TODO: deal_with_failed_transaction();
    }

    $self->resque->push(sendmail => {
        class => 'BananaDuck::Queue::Task::SendWelcomeEmail',
        args  => [ $user->id ],
    });

    $self->flash(user_id => $user->id);
    $self->redirect_to('registration/welcome');
}

sub confirm {
    my ($self) = @_;
    my $code = $self->stash('code');

    my $confirmation = $self->db->resultset('Confirmation')
        ->search({ code => $code, type_id => CONFIRMATION_EMAIL })->single;
    # TODO: check the confirmation creation time
    if (!defined $confirmation) {
        $self->redirect_to("registration");
        return;
    }
    my $user_id = $confirmation->user_id; # plain id, not object

    eval {
        $self->db->txn_do(sub {
            # search, not find (avoids extra query)
            $self->db->resultset('User')->search({ id => $user_id })->update({ is_email_confirmed => '1' });
            $confirmation->delete();
        });
    };
    if (my $error = $@) {
        # Transaction failed
        $self->app->log->error($error);
        die $error; # TODO: deal_with_failed_transaction();
    }

    $self->flash(user_id => $user_id);
    $self->redirect_to('registration/email-confirmed');
}

sub email_confirmed {
    my ($self) = @_;

    my $user_id = $self->flash("user_id");
    my $user;

    unless (defined $user_id && ($user = $self->db->resultset('User')->find($user_id))) {
        return $self->redirect_to("registration");
    }

    $self->render(template => 'registration/email_confirmed', user => $user);
}

sub check_login_availability {
    my ($self) = @_;

    my $login = $self->param('login');
    my $exists = $self->db->resultset('User')->login_exists($login);

    $self->app->log->debug("Login '$login' is ". ($exists ? "not available" : "available"));
    $self->render(json => $exists ? Mojo::JSON->false : Mojo::JSON->true);
}

sub check_email_availability {
    my ($self) = @_;

    my $email = $self->param('email');
    my $exists = $self->db->resultset('User')->email_exists($email);

    $self->app->log->debug("Email '$email' is ". ($exists ? "not available" : "available"));
    $self->render(json => $exists ? Mojo::JSON->false : Mojo::JSON->true);
}

sub welcome {
    my ($self) = @_;

    my $user_id = $self->flash("user_id");
    my $user;

    unless (defined $user_id && ($user = $self->db->resultset('User')->find($user_id))) {
        return $self->redirect_to("registration");
    }

    $self->render(template => 'registration/welcome', user => $user);
}

sub get_form {
    my ($self) = @_;

    # TODO: fields can probably be generated from the model

    my @fields = (
        {
            name  => "login",
            label => "Login",
            type  => "text",
            required => 1,
            validate => 'Login',
        },
        {
            name  => "password",
            label => "Password",
            type  => "password",
            required => 1,
            validate => 'Password',
        },
        {
            name  => "full_name",
            label => "Full Name",
            type  => "text",
            required => 0,
            validate => 'FullName'
        },
        {
            name  => "email",
            label => "E-mail",
            type  => "text",
            required => 1,
            validate => 'Email',
        },
        {
            name  => "birthday",
            label => "Birthday",
            type  => "text",
            required => 0,
            validate => 'Birthday',
        },
        {
            name    => "sex",
            label   => "Gender",
            type    => "select",
            options => [ ["", "Select Sex:"], ["m", "Male"], ["f", "Female"] ],
            required => 0,
            validate => ['Set', { set => [qw(m f)] }],
        },
    );

    return BananaDuck::Form->new({ c => $self, fields => \@fields });
}

1;
