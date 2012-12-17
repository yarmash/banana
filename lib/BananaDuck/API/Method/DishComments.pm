package BananaDuck::API::Method::DishComments;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    dish_id => { required => 1, validate => 'Number' },
    offset  => { required => 0, validate => 'Number' },
    limit   => { required => 0, validate => 'Number' }
} };

sub execute {
    my ($self, $params) = @_;

    my $dish = $self->find_object('Dish', $params->{dish_id});

    my $rs = $dish->comments(undef, { prefetch => 'user' });
    my ($comments, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result::Comment->new(comment => $comments, "+data" => { paging => $paging });
}

1;
