package BananaDuck::Queue::Task::SendWelcomeEmail;

use strict;
use warnings;

use base 'BananaDuck::Queue::Task::SendEmail';

use BananaDuck::Schema;
use BananaDuck::Constants 'CONFIRMATION_EMAIL';

sub perform {
    my ($job) = @_;

    my ($user_id) = @{ $job->args };

    my $schema = BananaDuck::Schema->connect;

    my $user = $schema->resultset('User')->find($user_id);
    my $confirmation;

    if (!$user->is_email_confirmed) {
        $confirmation = $schema->resultset('Confirmation')->find({ user_id => $user_id, type_id => CONFIRMATION_EMAIL })
            or die "No confirmation for the new user $user_id";
    }

    my $tt = __PACKAGE__->renderer;

    my $message;

    my %vars = (
        user => $user,
        code => $confirmation ? $confirmation->code : undef,
    );

    $tt->process('email/welcome_email.tt', \%vars, \$message) || die $tt->error;
    warn "$message\n";

    __PACKAGE__->send_email($user->email, $message);
}

1;
