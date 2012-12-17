package BananaDuck::API::Method::UserChangePassword;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Utils qw(get_salt get_password_hash);

has params_info => sub { +{
    old_password => { required => 0 },
    new_password => { required => 1, validate => 'Password' },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;

    if (defined $user->password) {
        unless ($params->{old_password} && $user->password eq get_password_hash($user->salt, $params->{old_password})) {
            BananaDuck::Exception::API->throw(
                error             => 'authentication_failure',
                error_description => $self->format_message('exception.invalidUsage.authenticationFailure'),
            );
        }
    }

    my $salt = get_salt;
    my $password = get_password_hash($salt, $params->{new_password});

    $user->update({ salt => $salt, password => $password })->discard_changes;

    return BananaDuck::API::Result->new;
}

1;
