package BananaDuck::API::Method::PlaceDeleteType;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    type_id => { required => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $place_type = $self->find_object('PlaceType', $params->{type_id});

    $place_type->delete;

    if (my $picture = $place_type->picture) {
        $self->delete_file($picture);
    }

    return BananaDuck::API::Result->new();
}

1;
