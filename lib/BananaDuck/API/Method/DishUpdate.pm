package BananaDuck::API::Method::DishUpdate;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Utils 'get_file_url';

has params_info => sub { +{
    dish_id    => { required => 1, validate => 'Number' },
    title      => { required => 0 },
    place_id   => { required => 0, validate => 'Number' },
    cuisine_id => { required => 0, validate => 'Number', blank => 1 },
    picture    => { required => 0, validate => 'Upload' },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    my $dish = $self->find_object('Dish', $params->{dish_id});

    if ($dish->user_id != $user->id) {
        BananaDuck::Exception::API->throw(
            error             => 'invalid_usage',
            error_description => $self->format_message('exception.invalidUsage.notOwner'),
        );
    }
    delete $params->{dish_id}; # TODO: use "id" instead of "dish_id"

    if (my $picture = $params->{picture}) { # Mojo::Upload
        my $old_picture = $dish->picture;
        $params->{picture} = get_file_url($picture->filename);

        $dish->update($params);

        $self->save_file($picture->asset, $params->{picture});
        $self->delete_file($old_picture) if $old_picture;
    }
    else {
        $dish->update($params);
    }

    return BananaDuck::API::Result::DishInfo->new(dish => $dish, user => $user);
}

1;
