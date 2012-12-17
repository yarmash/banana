package BananaDuck::FB::User;

use Mojo::Base -base;
use Mojo::Upload;
use Mojo::URL;

has [qw(id username name email birthday gender)];

sub new {
    my $class = shift;
    my $self = bless {%{$_[0]}}, $class;

    $self->{gender} = substr $self->{gender}, 0, 1;
    $self->{birthday} &&= join '-', (split '/', $self->{birthday})[2,0,1];

    return $self;
}

sub picture {
    my ($self) = @_;

    my $picture;

    if (!$self->{picture}{data}{is_silhouette}) { # user has uploaded a profile picture
        my $url = $self->{picture}{data}{url};

        my $asset = $self->{_client}->get($url)->content->asset;
        my $filename = Mojo::URL->new($url)->path->parts->[-1];

        $picture = Mojo::Upload->new( # use the container to keep both content and filename
            asset => $asset,
            filename => $filename,
        );
    }
    return $picture;
}

sub data {
    my ($self) = @_;
    return { map { $_ => $self->{$_} } grep !/^_/, keys %$self };
}

1;
