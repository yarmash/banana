package BananaDuck::API::Method::DishDelete;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    dish_id => { required => 1, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $dish = $self->find_object('Dish', $params->{dish_id});

    if ($dish->user_id != $self->user->id) {
        BananaDuck::Exception::API->throw(
            error             => 'invalid_usage',
            error_description => $self->format_message('exception.invalidUsage.notOwner'),
        );
    }
    $dish->delete;

    if (my $picture = $dish->picture) {
        $self->delete_file($picture);
    }

    return BananaDuck::API::Result->new();
}

1;
