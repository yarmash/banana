package BananaDuck::Queue::Task::PublishEvent;

use Mojo::Base -strict;
use BananaDuck::Schema;
use BananaDuck::Constants ':event_types';
use BananaDuck::Client::FB;

sub perform {
    my ($job) = @_;
    my ($event_id) = @{ $job->args };

    my $schema = BananaDuck::Schema->connect;

    my $event = $schema->resultset('Event')->find($event_id,
        { prefetch => [{ user => 'fb_connection' }, { dish => 'place' }] });

    my $user = $event->user;

    my $fb = $user->fb_connection
        or return;

    my $token = $fb->fb_access_token;
    my $dish = $event->dish;
    my $place = $dish->place;

    my $message;

    if ((my $event_type = $event->type_id) == EVENT_DISH_NEW) {
        $message = sprintf "I've just added the dish '%s' in the BananaDuck app! You can try it in %s.",
            $dish->title, $place->title;
    }
    elsif ($event_type == EVENT_DISH_FAVORITE) {
        $message = sprintf "I've just added the dish '%s' to favorites in the BananaDuck app!",
            $dish->title;
    }
    elsif ($event_type == EVENT_DISH_LIKE) {
        $message = sprintf "I've just added the dish '%s' to likes in the BananaDuck app!",
            $dish->title;
    }
    elsif ($event_type == EVENT_DISH_COMMENT) {
        $message = sprintf "I've just added a comment to the dish '%s' in the BananaDuck app: %s",
            $dish->title, $event->comment->comment;
    }

    BananaDuck::Client::FB->new
        ->create_post({
            access_token => $token,
            message => $message,
            picture => "http://foodadvisor.ru".$dish->picture,
            name => $dish->title,
            #caption => $dish->title,
            #link => "http://foodadvisor.ru",
        });
}

1;
