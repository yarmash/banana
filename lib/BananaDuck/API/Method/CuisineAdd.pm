package BananaDuck::API::Method::CuisineAdd;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    title => { required => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $cuisine = $self->schema->resultset('Cuisine')->create($params);

    return BananaDuck::API::Result::Cuisine->new(cuisine => $cuisine);
}

1;
