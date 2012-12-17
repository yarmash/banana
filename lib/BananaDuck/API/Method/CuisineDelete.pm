package BananaDuck::API::Method::CuisineDelete;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Exception::API;

has params_info => sub { +{
    cuisine_id => { required => 1, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $cuisine = $self->find_object('Cuisine', $params->{cuisine_id});

    $cuisine->delete;

    return BananaDuck::API::Result->new();
}

1;
