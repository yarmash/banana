package BananaDuck::API::Method::ImageResize;

use Mojo::Base 'BananaDuck::API::Method';
use Mojo::Asset::File;
use Image::Magick;
use BananaDuck::Constants 'AUTH_NONE';
use BananaDuck::Utils 'get_file_url';

has auth_level => AUTH_NONE;

has params_info => sub { +{
    image_url => { required => 1, validate => 'FileUrl' },
    width     => { required => 1, validate => 'Number' },
    height    => { required => 1, validate => 'Number' },
} };

sub execute {
    my ($self, $params) = @_;

    my $path = $self->url2path($params->{image_url});

    if (! -e $path) {
        BananaDuck::Exception::API->throw(
            error             => 'file_error',
            error_description => qq(Image not found),
        );
    }

    my $schema = $self->schema;
    my $rs = $schema->resultset('Preview');

    my $resized = $rs->find( @$params{qw( image_url width height )} );

    if (!$resized) {
        eval {
            $schema->txn_do(sub {
                my $file_url = get_file_url($params->{image_url});
                $resized = $rs->create({ %$params, preview_url => $file_url });

                my $image = Image::Magick->new;
                $image->Read($path);
                $image->Resize(geometry => "$params->{width}x$params->{height}");

                my $asset = Mojo::Asset::File->new->add_chunk($image->ImageToBlob);
                $self->save_file($asset, $file_url);
            });
        };
        if ($@) {
            if (index($@, "duplicate key value") != -1) { # catch race conditions
                warn $@;
                $resized = $rs->find( @$params{qw( image_url width height )} );
            }
            else {
                die $@;
            }
        }
    }
    return BananaDuck::API::Result->new(data => { image_url => $resized->preview_url });
}

1;
