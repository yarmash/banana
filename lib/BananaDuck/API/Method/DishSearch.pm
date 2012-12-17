package BananaDuck::API::Method::DishSearch;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    q            => { required => 0 },
    order_by     => { required => 1, validate => ['Set', { set => [qw(likes_count favorites_count comments_count distance created)] }] },
    max_distance => { required => 0, validate => 'Number' },
    place_id     => { required => 0, validate => 'Number' },
    latitude     => { required => 0, validate => 'Latitude' },
    longitude    => { required => 0, validate => 'Longitude' },
    offset       => { required => 0, validate => 'Number' },
    limit        => { required => 0, validate => 'Number' }
} };

sub execute {
    my ($self, $params) = @_;

    my $rs = $self->schema->resultset('Dish')->search(undef, { prefetch => [{ place => 'type' }, 'cuisine', 'user' ] });

    if ($params->{place_id}) {
        $rs = $rs->search({ 'place.id' => $params->{place_id} });
    }

    if ($params->{max_distance}) {
        $rs = $rs->search(\[
           "ST_Distance(('POINT(' || place.longitude || ' ' || place.latitude || ')')::geography, ('POINT(' || ? || ' ' || ? || ')')::geography) <= ?",
           map [ dummy => $_ ], @$params{qw(longitude latitude max_distance)}
       ]);
    }

    if (defined $params->{q} && $params->{q} ne "") {
        $rs = $rs->search([ 'me.title' => { ilike => "%$params->{q}%" }, 'place.title' => { ilike => "%$params->{q}%" } ]);
    }

    if ($params->{order_by} eq 'distance') {
        if (! (defined $params->{latitude} && defined $params->{longitude}) ) {
            BananaDuck::Exception::API->throw(
                error             => 'invalid_usage',
                error_description => qq(Latitude/longitude are required when sorting by distance),
            );
        }

        $rs = $rs->search(undef, {
            order_by => \[
                "ST_Distance(('POINT(' || place.longitude || ' ' || place.latitude || ')')::geography, ('POINT(' || ? || ' ' || ? || ')')::geography)",
                map [ dummy => $_ ], @$params{qw(longitude latitude)}
            ],
        });
    }
    else {
        $rs = $rs->search(undef, { order_by => { -desc => "me.$params->{order_by}" } });
    }

    my ($dishes, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result::DishInfo->new(
        dish    => $dishes,
        user    => $self->ctx->user,
        "+data" => { paging => $paging },
    );
}

1;
