use utf8;
package BananaDuck::Schema::Result::Cuisine;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Cuisine

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<cuisines>

=cut

__PACKAGE__->table("cuisines");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'cuisines_id_seq'

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "cuisines_id_seq",
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<cuisines_title_key>

=over 4

=item * L</title>

=back

=cut

__PACKAGE__->add_unique_constraint("cuisines_title_key", ["title"]);

=head1 RELATIONS

=head2 dishes

Type: has_many

Related object: L<BananaDuck::Schema::Result::Dish>

=cut

__PACKAGE__->has_many(
  "dishes",
  "BananaDuck::Schema::Result::Dish",
  { "foreign.cuisine_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-11-19 00:50:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sgEfchIZ7NJkTpzhjMxmAg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
