package BananaDuck::API::Result::Comment;

use Mojo::Base 'BananaDuck::API::Result';

sub data {
    my ($self) = @_;

    my $comment = $self->{comment};

    return ref $comment ne 'ARRAY' ?
        { comment => $self->get_comment_data($comment) } :
        { comments => [ map $self->get_comment_data($_), @$comment ] };
}

sub get_comment_data {
    my ($self, $comment) = @_;

    my %data = (
        %{ BananaDuck::API::Result::User->new(user => $comment->user)->data }, # enclose user
        map { $_ => $comment->$_ } qw(id dish_id comment created),
    );
    return \%data;
}

1;
