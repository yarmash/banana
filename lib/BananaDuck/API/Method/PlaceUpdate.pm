package BananaDuck::API::Method::PlaceUpdate;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    place_id  => { required => 1, validate => 'Number' },
    type_id   => { required => 0, validate => 'Number' },
    title     => { required => 0 },
    address   => { required => 0, blank => 1 },
    latitude  => { required => 0, validate => 'Latitude', blank => 1 },
    longitude => { required => 0, validate => 'Longitude', blank => 1 }
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    my $place = $self->find_object('Place', $params->{place_id});

    if ($place->user_id != $user->id) {
        BananaDuck::Exception::API->throw(
            error             => 'invalid_usage',
            error_description => $self->format_message('exception.invalidUsage.notOwner'),
        );
    }

    delete $params->{place_id};
    $place->update($params);

    return BananaDuck::API::Result::Place->new(place => $place);
}

1;
