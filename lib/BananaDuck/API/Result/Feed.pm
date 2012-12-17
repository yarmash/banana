package BananaDuck::API::Result::Feed;

use Mojo::Base 'BananaDuck::API::Result';
use BananaDuck::Constants 'EVENT_DISH_COMMENT';

sub data {
    my ($self) = @_;

    my @dishes = map $_->dish, @{$self->{events}};

    my $dishes_info = BananaDuck::API::Result::DishInfo->new(
        dish => \@dishes,
        user => $self->{user},
    )->data->{dishes};

    my %dishes_info = map { $_->{id} => $_ } @$dishes_info;

    my @events;

    for my $event_obj (@{$self->{events}}) {
        my %event = (
            %{ BananaDuck::API::Result::User->new(user => $event_obj->user)->data }, # enclose user
            map { $_ => $event_obj->$_ } qw(id type_id created)
        );
        $event{dish} = $dishes_info{$event_obj->dish_id};

        if ($event_obj->type_id == EVENT_DISH_COMMENT) { # comment_id should be set
            $event{comment} = $event_obj->comment->comment;
        }

        push @events, \%event;
    }
    return { events => \@events };
}

1;
