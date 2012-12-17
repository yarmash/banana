package BananaDuck::Validation::Rule::Email;

use Mojo::Base 'BananaDuck::Validation::Rule';
use Email::Valid;

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat') if !Email::Valid->address($value);
    return BananaDuck::Message->new(id => 'validation.emailInUse') if $schema->resultset('User')->email_exists($value);
    return '';
}

1;
