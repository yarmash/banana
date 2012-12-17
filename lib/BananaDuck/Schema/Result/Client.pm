use utf8;
package BananaDuck::Schema::Result::Client;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Client

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<clients>

=cut

__PACKAGE__->table("clients");

=head1 ACCESSORS

=head2 client_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'clients_client_id_seq'

=head2 client_secret

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "client_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "clients_client_id_seq",
  },
  "client_secret",
  { data_type => "varchar", is_nullable => 0, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</client_id>

=back

=cut

__PACKAGE__->set_primary_key("client_id");

=head1 RELATIONS

=head2 tokens

Type: has_many

Related object: L<BananaDuck::Schema::Result::Token>

=cut

__PACKAGE__->has_many(
  "tokens",
  "BananaDuck::Schema::Result::Token",
  { "foreign.client_id" => "self.client_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07022 @ 2012-04-21 22:01:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nCBXwR7Z8dXMQmbptbHVLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
