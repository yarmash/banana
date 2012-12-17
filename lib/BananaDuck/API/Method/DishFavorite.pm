package BananaDuck::API::Method::DishFavorite;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Constants 'EVENT_DISH_FAVORITE';

has params_info => sub { +{
    dish_id   => { required => 1, validate => 'Number' },
    operation => { required => 1 } # route capture
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->user;
    my $dish = $self->find_object('Dish', $params->{dish_id});

    if ($params->{operation} eq 'favorite') {
        my $favorite = $self->schema->resultset('Favorite')->find_or_new({ user_id => $user->id, dish_id => $dish->id });

        if ($favorite->in_storage) {
            warn sprintf 'Favorite exists (id=%d, user_id=%d, dish_id=%d)', $favorite->id, $user->id, $dish->id;
        }
        else {
            $favorite->insert;
            $dish->discard_changes; # fetch current values for counters (updated by a trigger)

            my $event = $user->add_to_events({ dish_id => $dish->id, type_id => EVENT_DISH_FAVORITE });

            if ($user->is_event_published($event)) { # user wants to publish the event to FB
                $self->enqueue_event_publication($event);
            }
        }
    }
    elsif ($params->{operation} eq 'unfavorite') {
        my $rv = $user->delete_related('user_favorites', { dish_id => $dish->id });
        if ($rv == 0) {
            warn sprintf 'Favorite not found (user_id=%d, dish_id=%d)', $user->id, $dish->id;
        }
        else {
            $dish->discard_changes; # fetch current values for counters (updated by a trigger)
        }
    }
    else {
        die "Unknown value for operation: $params->{operation}";
    }

    return BananaDuck::API::Result->new( data => { favorites_count => $dish->favorites_count } );
}

1;
