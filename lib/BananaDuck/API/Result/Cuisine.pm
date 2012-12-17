package BananaDuck::API::Result::Cuisine;

use Mojo::Base 'BananaDuck::API::Result';

sub data {
    my ($self) = @_;
    my $cuisine = $self->{cuisine};

    return { cuisine => undef } if !defined $cuisine;

    return ref $cuisine ne 'ARRAY' ?
        { cuisine => $self->get_cuisine_data($cuisine) } :
        { cuisines => [ map $self->get_cuisine_data($_), @$cuisine ] };
}

sub get_cuisine_data {
    my ($self, $cuisine) = @_;

    return { $cuisine->get_columns }
}

1;
