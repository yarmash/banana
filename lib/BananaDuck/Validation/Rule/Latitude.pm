package BananaDuck::Validation::Rule::Latitude;

use Mojo::Base 'BananaDuck::Validation::Rule';
use Scalar::Util 'looks_like_number';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat')
        unless looks_like_number($value) && $value >= -90 && $value <= 90;
    return '';
}

1;
