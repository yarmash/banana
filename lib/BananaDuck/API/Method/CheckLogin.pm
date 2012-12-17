package BananaDuck::API::Method::CheckLogin;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Constants 'AUTH_CLIENT';

has auth_level => AUTH_CLIENT;

has params_info => sub { +{
    login => { required => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $exists = $self->schema->resultset('User')->login_exists($params->{login});
    return BananaDuck::API::Result->new(data => { available => $exists ? 0 : 1 });
}

1;
