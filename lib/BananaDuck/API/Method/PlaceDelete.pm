package BananaDuck::API::Method::PlaceDelete;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    place_id => { required => 1, validate => 'Number' }
} };

sub execute {
    my ($self, $params) = @_;

    my $place = $self->find_object('Place', $params->{place_id});

    if ($place->user_id != $self->ctx->user->id) {
        BananaDuck::Exception::API->throw(
            error             => 'invalid_usage',
            error_description => $self->format_message('exception.invalidUsage.notOwner'),
        );
    }

    if ($place->count_related('dishes')) {
        BananaDuck::Exception::API->throw(
            error             => 'invalid_usage',
            error_description => $self->format_message('exception.invalidUsage.hasRelatedObjects'),
        );
    }

    $place->delete;

    return BananaDuck::API::Result->new();
}

1;
