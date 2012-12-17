package BananaDuck::Queue::Task::SendPasswordResetEmail;

use strict;
use warnings;

use base 'BananaDuck::Queue::Task::SendEmail';

use BananaDuck::Schema;

sub perform {
    my ($job) = @_;

    my ($confirmation_id) = @{ $job->args };

    my $schema = BananaDuck::Schema->connect;

    my $confirmation = $schema->resultset('Confirmation')->find($confirmation_id, { prefetch => 'user' });
    my $user = $confirmation->user;
    my $tt = __PACKAGE__->renderer;

    my $message;

    my %vars = (
        user => $user,
        code => $confirmation->code,
    );

    $tt->process('email/password_reset_email.tt', \%vars, \$message) || die $tt->error;
    warn "$message\n";

    __PACKAGE__->send_email($user->email, $message);
}


1;
