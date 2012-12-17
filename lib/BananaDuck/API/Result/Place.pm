package BananaDuck::API::Result::Place;

use Mojo::Base 'BananaDuck::API::Result';

sub data {
    my ($self) = @_;
    my $place = $self->{place};

    return ref $place ne 'ARRAY' ?
        { place => $self->get_place_data($place) } :
        { places => [ map $self->get_place_data($_), @$place ] };
}

sub get_place_data {
    my ($self, $place) = @_;

    my %columns = $place->get_columns;
    my %data = map { $_ => $columns{$_} } qw(id title address latitude longitude user_id dishes_count);

    $data{place_type} = { $place->type->get_columns };

    return \%data;
}

1;
