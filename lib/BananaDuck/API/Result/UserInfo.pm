package BananaDuck::API::Result::UserInfo;

use Mojo::Base 'BananaDuck::API::Result';

sub data {
    my ($self) = @_;

    my $user = $self->{user};
    my $me = $self->{me};

    my %columns = $user->get_columns;

    my %info = map { $_ => $columns{$_} } qw(id login full_name email birthday sex is_subscribed created country city avatar
        dishes_count favorites_count likes_count followers_count followees_count);

    if ($user == $me) {
        $info{has_password} = defined $user->password ? 1 : 0;
    }
    else {
        $info{is_followee} = $me->user_followees({ followee_id => $user->id })->single ? 1 : 0; # TODO: can be fetched with JOIN
    }

    return { user_info => \%info };
}

1;
