use utf8;
package BananaDuck::Schema::Result::Like;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Like

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<likes>

=cut

__PACKAGE__->table("likes");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 dish_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "dish_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</dish_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "dish_id");

=head1 RELATIONS

=head2 dish

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::Dish>

=cut

__PACKAGE__->belongs_to(
  "dish",
  "BananaDuck::Schema::Result::Dish",
  { id => "dish_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "BananaDuck::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-06-25 22:50:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rx6Coa8RqWtoc2SwdFY+bQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
