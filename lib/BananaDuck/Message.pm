package BananaDuck::Message;

use Mojo::Base -base;
use BananaDuck::Config;

has 'id';
has args => sub { [] };

sub format {
    my ($self, $lang) = @_;

    $lang ||= 'ru';
    my $messages = BananaDuck::Config->instance->config->{messages};
    my $message_id = $self->id;
    my @args = @{ $self->args };

    if (my $message = $messages->{$message_id}{$lang}) {
        return @args ? sprintf($message, @args) : $message;
    }
    return $message_id;
}

1;
