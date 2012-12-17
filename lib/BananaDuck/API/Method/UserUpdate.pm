package BananaDuck::API::Method::UserUpdate;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    full_name     => { required => 0, validate => 'FullName', blank => 1 },
    birthday      => { required => 0, validate => 'Birthday', blank => 1 },
    country       => { required => 0, validate => 'Number', blank => 1 },
    city          => { required => 0, blank => 1 },
    sex           => { required => 0, validate => ['Set', { set => [qw(m f)] }], blank => 1 },
    is_subscribed => { required => 0, validate => ['Set', { set => [qw(0 1)] }] },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    $user->update($params)->discard_changes;

    return BananaDuck::API::Result::User->new(user => $user);
}

1;
