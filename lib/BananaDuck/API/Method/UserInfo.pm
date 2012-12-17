package BananaDuck::API::Method::UserInfo;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    user_id => { required => 0, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $me = $self->ctx->user;

    my $user = $params->{user_id} && $params->{user_id} != $me->id ?
        $self->find_object('User', $params->{user_id}) : $me;

    return BananaDuck::API::Result::UserInfo->new(user => $user, me => $me);
}

1;
