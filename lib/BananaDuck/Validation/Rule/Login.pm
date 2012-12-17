package BananaDuck::Validation::Rule::Login;

use Mojo::Base 'BananaDuck::Validation::Rule';

sub validate {
    my ($self, $schema, $value) = @_;

    return BananaDuck::Message->new(id => 'validation.invalidFormat') if $value !~ /^[.\w]+\z/;
    return BananaDuck::Message->new(id => 'validation.loginInUse')
        if $schema->resultset('User')->login_exists($value);
    return '';
}

1;
