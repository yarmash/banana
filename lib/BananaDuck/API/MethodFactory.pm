package BananaDuck::API::MethodFactory;

use Mojo::Base -base;

sub createMethod {
    my $self = shift;
    my $name = shift;

    my $class = "BananaDuck::API::Method::" . $name;

    my $method_obj = $class->new(@_);

    return $method_obj;
}

1;
