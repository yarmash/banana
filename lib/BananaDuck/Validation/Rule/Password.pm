package BananaDuck::Validation::Rule::Password;

use Mojo::Base 'BananaDuck::Validation::Rule';

sub validate {
    my ($self, $schema, $value) = @_;

    my $min_length = 8;

    return BananaDuck::Message->new(id => 'validation.passwordTooShort', args => [$min_length])
        if length $value < $min_length;
    return '';
}

1;
