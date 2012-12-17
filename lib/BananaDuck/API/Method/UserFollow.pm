package BananaDuck::API::Method::UserFollow;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    user_id   => { required => 1, validate => 'Number' },
    operation => { required => 1 }, # route capture
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;

    my $followee = $self->find_object('User', $params->{user_id});

    if ($params->{operation} eq 'follow') {
        my $follower = $self->schema->resultset('Follower')->find_or_new({ follower_id => $user->id, followee_id => $followee->id });

        if ($follower->in_storage) {
            warn sprintf 'Follower exists (follower_id=%d, followee_id=%d)', $user->id, $followee->id;
        }
        else {
            $follower->insert;
        }
        # store event
    }
    elsif ($params->{operation} eq 'unfollow') {
        my $rv = $user->user_followees({ followee_id => $followee->id })->delete;
        warn sprintf('Follower not found (follower_id=%d, followee_id=%d)', $user->id, $followee->id) if $rv == 0;
    }
    else {
        die "Unknown value for operation: $params->{operation}";
    }

    my $followees_count = $user->count_related('user_followees');

    return BananaDuck::API::Result->new(data => { followees_count => $followees_count });
}

1;
