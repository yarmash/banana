package BananaDuck::API::Method::PlaceAddType;

use Mojo::Base 'BananaDuck::API::Method';
use BananaDuck::Utils 'get_file_url';

has params_info => sub { +{
    title   => { required => 1 },
    picture => { required => 1, validate => 'Upload' },
} };

sub execute {
    my ($self, $params) = @_;

    my $picture = $params->{picture}; # Mojo::Upload
    my $file_url = get_file_url($picture->filename);

    my $place_type = $self->schema->resultset('PlaceType')->create({
        title   => $params->{title},
        picture => $file_url,
    });

    $self->save_file($picture->asset, $file_url);

    return BananaDuck::API::Result->new(data => { place_type => { $place_type->get_columns } });
}

1;
