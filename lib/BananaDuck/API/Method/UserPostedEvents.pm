package BananaDuck::API::Method::UserPostedEvents;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    my @events = $user->published_events;

    return BananaDuck::API::Result->new(data => { event_types => [ map $_->type_id, @events ] });
}

1;
