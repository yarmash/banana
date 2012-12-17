package BananaDuck::API::Method::CheckEmail;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Constants 'AUTH_CLIENT';

has auth_level => AUTH_CLIENT;

has params_info => sub { +{
    email => { required => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $exists = $self->schema->resultset('User')->email_exists($params->{email});
    return BananaDuck::API::Result->new(data => { available => $exists ? 0 : 1 });
}

1;
