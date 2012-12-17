package BananaDuck::Validation::Rule::Number;

use Mojo::Base 'BananaDuck::Validation::Rule';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat') if $value !~ /^\d+\z/;
    return '';
}

1;
