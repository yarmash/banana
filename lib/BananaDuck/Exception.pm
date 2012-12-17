package BananaDuck::Exception;

# A base class for exception objects
use Mojo::Base -base;
use Data::Dumper ();

use overload
    bool => sub { 1 }, # an exception is always true
    '""' => 'as_string',
    fallback => 1;

sub throw {
    my $proto = shift;

    $proto->rethrow if ref $proto;

    die $proto->new(@_);
}

sub rethrow {
    my ($self) = @_;

    die $self;
}

sub as_string {
    my ($self) = @_;

    return Data::Dumper->new([$self])->Terse(1)->Dump;
}

1;
