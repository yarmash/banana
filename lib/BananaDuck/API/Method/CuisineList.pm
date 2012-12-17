package BananaDuck::API::Method::CuisineList;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    offset => { required => 0, validate => 'Number' },
    limit  => { required => 0, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $rs = $self->schema->resultset('Cuisine')->search(undef, { order_by => 'title' });

    my ($cuisines, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result::Cuisine->new(cuisine => $cuisines, "+data" => { paging => $paging });
}

1;
