package BananaDuck::API::Method::DishAdd;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Constants 'EVENT_DISH_NEW';
use BananaDuck::Utils 'get_file_url';

has params_info => sub { +{
    title      => { required => 1 },
    place_id   => { required => 1, validate => 'Number' },
    cuisine_id => { required => 0, validate => 'Number' },
    picture    => { required => 1, validate => 'Upload' },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;

    my ($dish, $event);

    $self->schema->txn_do(sub {
        my $picture = $params->{picture}; # Mojo::Upload
        $params->{picture} = get_file_url($picture->filename); # generate a file url

        $dish = $user->add_to_dishes($params)
            ->discard_changes({ prefetch => [{ place => 'type' }, 'cuisine', 'user' ] });

        $event = $user->add_to_events({ dish_id => $dish->id, type_id => EVENT_DISH_NEW });

        $self->save_file($picture->asset, $params->{picture});
    });

    if ($user->is_event_published($event)) { # user wants to publish the event to FB
        $self->enqueue_event_publication($event);
    }

    return BananaDuck::API::Result::DishInfo->new(dish => $dish, user => $user);
}

1;
