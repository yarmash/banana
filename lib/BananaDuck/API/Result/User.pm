package BananaDuck::API::Result::User;

use Mojo::Base 'BananaDuck::API::Result';

sub data {
    my ($self) = @_;

    my %columns = $self->{user}->get_columns;

    my %data = map { $_ => $columns{$_} } qw(id login full_name email birthday sex is_subscribed created country city avatar);

    return { user => \%data };
}

1;
