use utf8;
package BananaDuck::Schema::Result::Confirmation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Confirmation

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<confirmations>

=cut

__PACKAGE__->table("confirmations");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'confirmations_id_seq'

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 code

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
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "confirmations_id_seq",
  },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "code",
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

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<confirmations_code_key>

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->add_unique_constraint("confirmations_code_key", ["code"]);

=head2 C<confirmations_user_id_type_id_key>

=over 4

=item * L</user_id>

=item * L</type_id>

=back

=cut

__PACKAGE__->add_unique_constraint("confirmations_user_id_type_id_key", ["user_id", "type_id"]);

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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-10-30 01:19:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ge5XGHnmMVy4swLY0kYTpg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
