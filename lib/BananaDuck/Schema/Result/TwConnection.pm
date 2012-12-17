use utf8;
package BananaDuck::Schema::Result::TwConnection;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::TwConnection

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<tw_connections>

=cut

__PACKAGE__->table("tw_connections");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tw_id

  data_type: 'bigint'
  is_nullable: 0

=head2 tw_access_token

  data_type: 'text'
  is_nullable: 1

=head2 tw_access_token_secret

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tw_id",
  { data_type => "bigint", is_nullable => 0 },
  "tw_access_token",
  { data_type => "text", is_nullable => 1 },
  "tw_access_token_secret",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<tw_connections_tw_id_key>

=over 4

=item * L</tw_id>

=back

=cut

__PACKAGE__->add_unique_constraint("tw_connections_tw_id_key", ["tw_id"]);

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-11-01 21:33:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mWemH7EgpFOLsdj8GGvMxA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
