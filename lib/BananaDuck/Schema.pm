use utf8;
package BananaDuck::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07017 @ 2012-03-28 14:16:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4QtTr0FUXf0T3VY43apsqg


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use BananaDuck::Config;

sub connection {
    my $self = shift;

    my $storage = BananaDuck::Config->instance->config->{storage};

    $self->next::method(@$storage{qw(dsn user password options)});
}

1;
