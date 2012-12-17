package BananaDuck::Validation::Rule::Birthday;

use Mojo::Base 'BananaDuck::Validation::Rule';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat') if $value !~ /^\d{4}-\d{2}-\d{2}\z/;
    return '';
}

1;
