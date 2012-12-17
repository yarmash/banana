package BananaDuck::Validation::Rule::FileUrl;

use Mojo::Base 'BananaDuck::Validation::Rule';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat')
        if $value !~ m{^/files/[0-9a-f]{2}/[0-9a-f]{2}/[0-9a-f]{32}(?:\.[a-z]+)?\z};
    return '';
}

1;
