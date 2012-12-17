#!/usr/bin/env perl

# Script to move all files (avatars, dishes, place_types) to a new hierarchy

use FindBin;
use lib "$FindBin::Bin/../lib";

use Mojo::Base -strict;
use File::Path 'mkpath';
use File::Basename qw(basename dirname);
use File::Copy;
use BananaDuck::Schema;
use BananaDuck::Utils 'get_file_url';
use autodie;

my $FILES_DIR = "$FindBin::Bin/../public";

main();

sub main {
    my $schema = BananaDuck::Schema->connect;

    process_users($schema);
    process_dishes($schema);
    process_place_types($schema);
}

sub process_users {
    my ($schema) = @_;
    process($schema, 'User', 'avatar');
}

sub process_dishes {
    my ($schema) = @_;
    process($schema, 'Dish', 'picture');
}

sub process_place_types {
    my ($schema) = @_;
    process($schema, 'PlaceType', 'picture');
}

sub process {
    my ($schema, $source_name, $accessor) = @_;

    my @objects = $schema->resultset($source_name)->all;

    for my $object (@objects) {
        my $path = $object->$accessor or next;

        $schema->txn_do(sub {
            my $new_path = get_file_url( basename($path) );
            $object->$accessor($new_path);
            $object->update;
            mkpath(dirname("$FILES_DIR$new_path"), 1);
            move("$FILES_DIR$path", "$FILES_DIR$new_path");

            if (my @previews = $schema->resultset('Preview')->search({ image_url => $path })) {
                for my $preview (@previews) {
                    $preview->delete;
                    unlink $FILES_DIR.$preview->preview_url;
                }
            }
        });
    }
}
