package BananaDuck::Controller::Users;

use Mojo::Base 'Mojolicious::Controller';
use BananaDuck::Utils qw(get_salt get_password_hash get_random_string);
use BananaDuck::API::MethodFactory;
use BananaDuck::API::Context;

sub list {
    my ($self) = @_;

    my @users = $self->db->resultset('User')->search(undef, { order_by => 'id', prefetch => 'fb_connection' });
    $self->render(users => \@users);
}

sub resetpw {
    my ($self) = @_;

    my $code = $self->stash('code');

    my $confirmation = $self->db->resultset('Confirmation')
        ->search({ code => $code, type_id => 2 }, { prefetch => 'user' })->single;
    # TODO: check the confirmation creation time

    if (!defined $confirmation) {
        $self->render(text => 'Invalid code');
        return;
    }
    my $user = $confirmation->user;

    my $salt = get_salt;
    my $password = get_random_string(10);

    # TODO: use a transaction
    $user->salt($salt);
    $user->password(get_password_hash($salt, $password));
    $user->update;
    $confirmation->delete();

    $self->render(text => "The password was reset to: $password\nPlease change it to something else.");
}

sub connect_facebook {
    my ($self) = @_;

    my $api_method = $self->param('operation') eq 'connect' ? 'UserConnectFB' : 'UserDisconnectFB'; # TODO: move the api calling code to a superclass
    my $method = BananaDuck::API::MethodFactory->createMethod($api_method);
    $self->app->log->debug("Calling the API method: $api_method");

    my $ctx = BananaDuck::API::Context->new(
        schema => $self->db,
        user => $self->current_user,
        ua => $self->ua,
    );

    my %params = $self->param('operation') eq 'connect' ? (fb_access_token => $self->stash('access_token')) : ();

    $method->ctx($ctx);
    $method->validate_params(\%params);
    $method->execute(\%params);
    $self->render(text => 'Success');
}

1;
