use utf8;
package BananaDuck::Schema::Result::Token;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Token

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<tokens>

=cut

__PACKAGE__->table("tokens");

=head1 ACCESSORS

=head2 client_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 token

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "client_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "token",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "created",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</client_id>

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("client_id", "user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<tokens_token_key>

=over 4

=item * L</token>

=back

=cut

__PACKAGE__->add_unique_constraint("tokens_token_key", ["token"]);

=head1 RELATIONS

=head2 client

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::Client>

=cut

__PACKAGE__->belongs_to(
  "client",
  "BananaDuck::Schema::Result::Client",
  { client_id => "client_id" },
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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-09-16 01:50:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qkWfVkvf71DgTn3xFXhOgw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
