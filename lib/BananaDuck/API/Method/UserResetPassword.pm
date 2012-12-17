package BananaDuck::API::Method::UserResetPassword;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Constants qw(AUTH_CLIENT CONFIRMATION_PASSWORD_RESET);
use BananaDuck::Utils 'get_confirmation_code';

has auth_level => AUTH_CLIENT;

has params_info => sub { +{
    login_or_email => { required => 1 },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->find_object('User', [ map { $_ => $params->{login_or_email} } qw(login email) ]);

    my $confirmation = $self->schema->resultset('Confirmation')->find_or_create({
        user_id => $user->id,
        type_id => CONFIRMATION_PASSWORD_RESET,
        code    => get_confirmation_code,
    },
    {
        key => 'confirmations_user_id_type_id_key'
    });

    $self->ctx->resque->push(sendmail => {
        class => 'BananaDuck::Queue::Task::SendPasswordResetEmail',
        args => [ $confirmation->id ]
    });

    return BananaDuck::API::Result->new;
}

1;
