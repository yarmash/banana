package BananaDuck::API::Result::DishInfo;

use Mojo::Base 'BananaDuck::API::Result';

has [qw(user dish)];

has user_likes => sub {
    my ($self) = @_;
    return { map { $_->dish_id, 1 } $self->user->user_likes(@{ $self->search_args }) };
};

has user_favorites => sub {
    my ($self) = @_;
    return { map { $_->dish_id, 1 } $self->user->user_favorites(@{ $self->search_args }) };
};

has search_args => sub {
    my ($self) = @_;
    my $dish = $self->dish;

    return [
        { dish_id => ref $dish ne 'ARRAY' ? $dish->id : { -in => [ map $_->id, @$dish ] } },
        { select => ['dish_id'] },
    ];
};

sub data {
    my ($self) = @_;

    my $dish = $self->dish;

    return ref $dish ne 'ARRAY' ?
        { dish => $self->get_dish_info($dish) } :
        { dishes => [ map $self->get_dish_info($_), @$dish ] };
}

sub get_dish_info {
    my ($self, $dish) = @_;

    my $info = BananaDuck::API::Result::Dish->new(dish => $dish)->data->{dish};

    $info->{is_liked} = $self->user_likes->{$dish->id} ? 1 : 0;
    $info->{is_favorited} = $self->user_favorites->{$dish->id} ? 1 : 0;
    return $info;
}

1;
