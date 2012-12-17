package BananaDuck::API::Method::UserFavorites;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    user_id => { required => 0, validate => 'Number' },
    offset  => { required => 0, validate => 'Number' },
    limit   => { required => 0, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;

    if ($params->{user_id} && $params->{user_id} != $user->id) {
        $user = $self->find_object('User', $params->{user_id});
    }

    my $rs = $user->favorites(undef, {
        prefetch => [{ place => 'type' }, 'cuisine', 'user' ],
    });

    my ($dishes, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result::DishInfo->new(
        dish    => $dishes,
        user    => $user,
        "+data" => { paging => $paging },
    );
}

1;
