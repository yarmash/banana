package BananaDuck::API::Result;

use Mojo::Base -base;

has data => sub { +{} }; # no additional fields by default

sub result {
    my ($self) = @_;

    my $result = $self->data;

    if ($self->{'+data'}) {
        while (my ($k, $v) = each $self->{'+data'}) {
            $result->{$k} = $v;
        }
    }
    $result->{success} = 1;

    return $result;
}

1;
