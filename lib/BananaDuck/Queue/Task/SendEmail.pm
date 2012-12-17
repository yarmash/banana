package BananaDuck::Queue::Task::SendEmail;

use strict;
use warnings;

use Net::SMTP;
use Template;
use BananaDuck::Config;

my $config = BananaDuck::Config->instance->config;

sub send_email {
    my ($self, $to, $data) = @_;

    my $mailhost = $config->{mail}{relay};
    my $from = $config->{mail}{from};

    my $smtp = Net::SMTP->new($mailhost);
    $smtp->mail($from);
    $smtp->to($to);
    $smtp->data();
    $smtp->datasend($data);
    $smtp->dataend();
    $smtp->quit;
}

sub renderer {
    my ($self) = @_;

    return Template->new({
        ENCODING     => 'utf8',
        INCLUDE_PATH => "$ENV{MOJO_HOME}/templates",
        PRE_CHOMP    => 3,
        POST_CHOMP   => 3,
        TRIM         => 1,
        VARIABLES    => {
            from => $config->{mail}{from},
        }
    });
}

1;
