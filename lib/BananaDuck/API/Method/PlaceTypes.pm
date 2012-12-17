package BananaDuck::API::Method::PlaceTypes;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    my @types = $self->schema->resultset('PlaceType')->all;
    return BananaDuck::API::Result->new( data => { types => [ map +{ $_->get_columns }, @types ] } );
}

1;
