package BananaDuck::API::Method::PlaceSearch;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    q         => { required => 0 },
    order_by  => { required => 0, validate => ['Set', { set => [qw(distance)] }] },
    latitude  => { required => 0, validate => 'Latitude' },
    longitude => { required => 0, validate => 'Longitude' },
    offset    => { required => 0, validate => 'Number' },
    limit     => { required => 0, validate => 'Number' }
} };

sub execute {
    my ($self, $params) = @_;

    my $rs = $self->schema->resultset('Place')->search(undef, { prefetch => 'type' });

    if (defined $params->{q} && $params->{q} ne "") {
        $rs = $rs->search([ 'me.title' => { ilike => "%$params->{q}%" }, 'me.address' => { ilike => "%$params->{q}%" } ]);
    }

    if ($params->{order_by} && $params->{order_by} eq 'distance') {
        if (! (defined $params->{latitude} && defined $params->{longitude}) ) {
            BananaDuck::Exception::API->throw(
                error             => 'invalid_usage',
                error_description => qq(Latitude/longitude are required when sorting by distance),
            );
        }

        $rs = $rs->search(undef, {
            order_by => \[
                "ST_Distance(('POINT(' || me.longitude || ' ' || me.latitude || ')')::geography, ('POINT(' || ? || ' ' || ? || ')')::geography)",
                map [ dummy => $_ ], @$params{qw(longitude latitude)}
            ],
        });
    }

    my ($places, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result::Place->new(place => $places, "+data" => { paging => $paging });
}

1;
