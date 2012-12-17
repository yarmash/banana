package BananaDuck::API::Method::UserPlaces;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    offset => { required => 0, validate => 'Number' },
    limit  => { required => 0, validate => 'Number' }
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;

    my $rs = $user->places(undef, { prefetch => 'type' });

    my ($places, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result::Place->new(place => $places, "+data" => { paging => $paging });
}

1;
