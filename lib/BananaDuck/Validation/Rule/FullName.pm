package BananaDuck::Validation::Rule::FullName;

use Mojo::Base 'BananaDuck::Validation::Rule';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat') if $value !~ /^[- '\w]+\z/;
    return '';
}

1;
