package BananaDuck::API::Method::UserUpdateAvatar;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Utils 'get_file_url';

has params_info => sub { +{
    avatar => { required => 1, validate => 'Upload' },
} };

sub execute {
    my ($self, $params) = @_;

    my $user = $self->ctx->user;
    my $old_avatar = $user->avatar;
    my $avatar = $params->{avatar}; # Mojo::Upload

    my $file_url = get_file_url($avatar->filename);
    $user->update({ avatar => $file_url });

    $self->save_file($avatar->asset, $file_url);

    if ($old_avatar) {
        $self->delete_file($old_avatar);
    }

    return BananaDuck::API::Result->new(data => { avatar => $file_url });
}

1;
