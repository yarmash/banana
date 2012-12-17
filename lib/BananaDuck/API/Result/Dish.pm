package BananaDuck::API::Result::Dish;

use Mojo::Base 'BananaDuck::API::Result';

sub data {
    my ($self) = @_;

    my $dish = $self->{dish};
    my %columns = $dish->get_columns;

    my %data = (
        %{ BananaDuck::API::Result::User->new(user => $dish->user)->data }, # enclose user
        %{ BananaDuck::API::Result::Place->new(place => $dish->place)->data }, # enclose place
        %{ BananaDuck::API::Result::Cuisine->new(cuisine => $dish->cuisine)->data }, # enclose cuisine
        map { $_ => $columns{$_} } qw(id title picture likes_count favorites_count comments_count created),
    );

    return { dish => \%data };
}

1;
