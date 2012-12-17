package BananaDuck::API::Method::UserUpdatePostedEvents;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    type_id => { required => 1, blank => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    my $rs = $user->published_events;
    my @event_types = defined $params->{type_id}
        ? ref $params->{type_id} ? @{ $params->{type_id} } : $params->{type_id}
        : ();

    $self->schema->txn_do(sub {
        $rs->delete;
        $rs->populate([ map +{ type_id => $_ }, @event_types ]);
    });

    return BananaDuck::API::Result->new(data => { event_types => [ map $_->type_id, $rs->all ] });
}

1;
