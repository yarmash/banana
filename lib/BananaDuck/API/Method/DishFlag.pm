package BananaDuck::API::Method::DishFlag;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    dish_id => { required => 1, validate => 'Number' },
    type_id => { required => 1, validate => 'Number' },
    comment => { required => 0 },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    my $dish = $self->find_object('Dish', $params->{dish_id});

    my $flag = $self->schema->resultset('Flag')->create({ %$params, user_id => $user->id })
        ->discard_changes;

    return BananaDuck::API::Result->new(data => { flag => { $flag->get_columns } });
}

1;
