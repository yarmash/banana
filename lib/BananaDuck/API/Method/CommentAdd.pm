package BananaDuck::API::Method::CommentAdd;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Constants 'EVENT_DISH_COMMENT';

has params_info => sub { +{
    dish_id => { required => 1, validate => 'Number' },
    comment => { required => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    my $dish = $self->find_object('Dish', $params->{dish_id});

    my $comment = $user->add_to_comments({ dish_id => $dish->id, comment => $params->{comment} })
        ->discard_changes({ prefetch => 'user' });

    my $event = $user->add_to_events({
        type_id    => EVENT_DISH_COMMENT,
        dish_id    => $dish->id,
        comment_id => $comment->id,
    });

    if ($user->is_event_published($event)) { # user wants to publish the event to FB
        $self->enqueue_event_publication($event);
    }

    return BananaDuck::API::Result::Comment->new(comment => $comment);
}

1;
