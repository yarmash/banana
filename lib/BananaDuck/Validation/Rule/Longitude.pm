package BananaDuck::Validation::Rule::Longitude;

use Mojo::Base 'BananaDuck::Validation::Rule';
use Scalar::Util 'looks_like_number';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat')
        unless looks_like_number($value) && $value >= -180 && $value <= 180;
    return '';
}

1;
