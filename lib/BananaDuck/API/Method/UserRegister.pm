package BananaDuck::API::Method::UserRegister;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Constants 'AUTH_CLIENT';

has auth_level => AUTH_CLIENT;

has params_info => sub { +{
    login     => { required => 1, validate => 'Login' },
    password  => { required => 1, validate => 'Password' },
    full_name => { required => 0, validate => 'FullName' },
    email     => { required => 1, validate => 'Email' },
    sex       => { required => 0, validate => ['Set', { set => [qw(m f)] }] },
    birthday  => { required => 0, validate => 'Birthday' },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->create_user($params);
    return BananaDuck::API::Result::User->new(user => $user);
}

1;
