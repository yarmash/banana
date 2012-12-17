package BananaDuck::Validation::Rule::Set;

use Mojo::Base 'BananaDuck::Validation::Rule';

sub validate {
    my ($self, $schema, $value) = @_;

    my %allowed = map { $_ => 1 } @{ $self->{set} };

    return BananaDuck::Message->new(id => 'validation.valueNotInSet', args => [join ', ', @{ $self->{set} }])
        if !$allowed{$value};
    return '';
}

1;
