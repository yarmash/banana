package BananaDuck::API::Method::UserDishes;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    user_id  => { required => 0, validate => 'Number' },
    order_by => { required => 1, validate => ['Set', { set => [qw(likes_count favorites_count comments_count created)] }] },
    offset   => { required => 0, validate => 'Number' },
    limit    => { required => 0, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;

    if ($params->{user_id} && $params->{user_id} != $user->id) {
        $user = $self->find_object('User', $params->{user_id});
    }

    my $order_by = "me.$params->{order_by}";

    my $rs = $user->dishes(undef, {
        order_by => { -desc => $order_by },
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
