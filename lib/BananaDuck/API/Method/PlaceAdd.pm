package BananaDuck::API::Method::PlaceAdd;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    type_id   => { required => 1, validate => 'Number' },
    title     => { required => 1 },
    address   => { required => 0, blank => 1 },
    latitude  => { required => 0, validate => 'Latitude', blank => 1 },
    longitude => { required => 0, validate => 'Longitude', blank => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->user;
    my $place = $user->add_to_places($params)->discard_changes({ prefetch => 'type' });

    return BananaDuck::API::Result::Place->new(place => $place);
}

1;
