use utf8;
package BananaDuck::Schema::Result::PlaceType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::PlaceType

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<place_types>

=cut

__PACKAGE__->table("place_types");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'place_types_id_seq'

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 picture

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "place_types_id_seq",
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "picture",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 places

Type: has_many

Related object: L<BananaDuck::Schema::Result::Place>

=cut

__PACKAGE__->has_many(
  "places",
  "BananaDuck::Schema::Result::Place",
  { "foreign.type_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-10-09 17:00:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7Xq8vnpRJACccHyQVDNX0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
