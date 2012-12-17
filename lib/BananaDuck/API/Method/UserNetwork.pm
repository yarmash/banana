package BananaDuck::API::Method::UserNetwork;

use Mojo::Base 'BananaDuck::API::Method';

has params_info => sub { +{
    user_id     => { required => 0, validate => 'Number' },
    member_type => { required => 1 }, # route capture
    offset      => { required => 0, validate => 'Number' },
    limit       => { required => 0, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $me = $self->ctx->user;

    my $user = $params->{user_id} && $params->{user_id} != $me->id ?
        $self->find_object('User', $params->{user_id}) : $me;

    my $rs;

    if ($params->{member_type} eq 'followers') {
        $rs = $user->followers;
    }
    elsif ($params->{member_type} eq 'followees') {
        $rs = $user->followees;
    }
    else {
        die "Unknown value for member_type: $params->{member_type}";
    }
    my ($members, $paging) = $self->get_result_page($rs, $params->{offset}, $params->{limit});

    return BananaDuck::API::Result->new(data => {
        paging => $paging,
        $params->{member_type} => [
            map BananaDuck::API::Result::User->new(user => $_)->data->{user}, @$members
        ]
    });
}

1;
