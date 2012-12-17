package BananaDuck::API::Context;

use Mojo::Base -base;

has [qw(
    config
    home
    lang
    log
    resque
    schema
    token
    ua
)];

has user => sub {
    my ($self) = @_;
    $self->token->user;
};

has client => sub { # default value
    my ($self) = @_;
    $self->token->client;
};

1;
