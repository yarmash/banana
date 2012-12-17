use utf8;
package BananaDuck::Schema::Result::FbConnection;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::FbConnection

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<fb_connections>

=cut

__PACKAGE__->table("fb_connections");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 fb_id

  data_type: 'bigint'
  is_nullable: 0

=head2 fb_access_token

  data_type: 'text'
  is_nullable: 0

=head2 created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "fb_id",
  { data_type => "bigint", is_nullable => 0 },
  "fb_access_token",
  { data_type => "text", is_nullable => 0 },
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

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<fb_connections_fb_id_key>

=over 4

=item * L</fb_id>

=back

=cut

__PACKAGE__->add_unique_constraint("fb_connections_fb_id_key", ["fb_id"]);

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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-10-30 02:03:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4DA3wEMd/F+g7JcTxHLsWA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
