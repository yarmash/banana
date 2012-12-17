package BananaDuck::Schema::ResultSet::User;

use Mojo::Base 'DBIx::Class::ResultSet';

sub by_credentials {
    my ($self, $username, $password) = @_;

    return if !$username || !$password;

    # TODO compute the hash in the code for better security
    my ($user) = $self->search({
        login     => $username,
        password  => \["= MD5(salt || ?)", [ "password", $password ]],
    });
    return $user;
}

# returns a boolean
sub login_exists {
    my ($self, $login) = @_;

    return $self->search({ login => $login }, { select => [\1] })->single ? 1 : 0;
}

sub email_exists {
    my ($self, $email) = @_;

    return $self->search({ email => $email }, { select => [\1] })->single ? 1 : 0;
}

1;
