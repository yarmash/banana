package BananaDuck::API::Method::UserFeed;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    user_id => { required => 0, validate => 'Number' },
    offset  => { required => 0, validate => 'Number' },
    limit   => { required => 0, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $me = $self->ctx->user;

    my $user = $params->{user_id} && $params->{user_id} != $me->id ?
        $self->find_object('User', $params->{user_id}) : $me;

    my @users = ($user, $user->followees); # users whose events are shown in the feed

    my $rs = $self->schema->resultset('Event')->search({ "me.user_id" => { -in => [ map $_->id, @users ] } }, {
        order_by => { -desc => 'me.created' },
        prefetch => ['user', { dish => [{ place => 'type' }, 'user', 'cuisine'] } ],
    });

    my ($events, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result::Feed->new(
        events  => $events,
        user    => $me,
        "+data" => { paging => $paging },
    );
}

1;
