use utf8;
package BananaDuck::Schema::Result::Follower;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Follower

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<followers>

=cut

__PACKAGE__->table("followers");

=head1 ACCESSORS

=head2 follower_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 followee_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "follower_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "followee_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</follower_id>

=item * L</followee_id>

=back

=cut

__PACKAGE__->set_primary_key("follower_id", "followee_id");

=head1 RELATIONS

=head2 followee

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "followee",
  "BananaDuck::Schema::Result::User",
  { id => "followee_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 follower

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "follower",
  "BananaDuck::Schema::Result::User",
  { id => "follower_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-06-15 02:33:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9uz6PBJaerviz61V+1XqLA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
