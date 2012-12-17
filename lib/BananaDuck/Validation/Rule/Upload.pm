package BananaDuck::Validation::Rule::Upload;

use Mojo::Base 'BananaDuck::Validation::Rule';
use Scalar::Util 'blessed';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat')
        unless blessed($value) && $value->isa('Mojo::Upload');
    return '';
}

1;
