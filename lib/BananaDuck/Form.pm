package BananaDuck::Form;

# Similar to CGI::FormBuilder, but w/o unnecessary stuff
# TODO: Represent fields as objects of the BananaDuck::Form::Field class

use Mojo::Base -base;

has [qw(is_validated fields c)];

has is_submitted => sub {
    my ($self) = @_;
    $self->c->param('_submitted') || 0,
};

has schema => sub {
    my ($self) = @_;
    $self->c->db;
};

sub new {
    my $class = shift;
    my $self = bless @_ > 1 ? {@_} : {%{$_[0]}}, $class;

    if ($self->is_submitted) {
        $self->set_values;
    }
    return $self;
}

sub validate {
    my ($self) = @_;

    if (!defined $self->is_validated) {
        $self->is_validated(1);

        for my $field (@{ $self->fields }) {

            $field->{is_valid} = 1;

            # required fields should not be empty
            if ($field->{value} eq "") {
                if ($field->{required}) {
                    $field->{is_valid} = 0;
                    $field->{reason} = 'The field is required';
                }
            }
            else {
                if (my $validate = $field->{validate}) {
                    my $error;

                    if (!ref $validate) {
                        my $class = "BananaDuck::Validation::Rule::$validate";
                        $error = $class->new->validate($self->schema, $field->{value});
                    }
                    elsif (ref $validate eq 'ARRAY') {
                        my ($name, $args) = @$validate;
                        my $class = "BananaDuck::Validation::Rule::$name";
                        $error = $class->new($args)->validate($self->schema, $field->{value});
                    }
                    else {
                        die "Don't know how to validate $field->{name} with $validate";
                    }

                    if ($error) { # BananaDuck::Message
                        $field->{is_valid} = 0;
                        $field->{reason} = $error->format('en');
                    }
                }
            }
            $self->is_validated(0) unless $field->{is_valid};
        }
    }
    return $self->is_validated;
}


# returns values for non-empty fields
sub get_values {
    my ($self) = @_;
    return +{ map { $_->{value} ne "" ? ($_->{name} => $_->{value}) : () } @{ $self->fields } };
}

sub set_values {
    my ($self) = @_;

    # $c should be a CGI-like object
    my $c = $self->c;

    for my $field (@{ $self->fields }) {
        $field->{value} = $c->param($field->{name}) // ""; # "" allows warnings free comparisons
    }
    return $self;
}

1;
