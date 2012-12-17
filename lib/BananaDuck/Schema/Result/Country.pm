use utf8;
package BananaDuck::Schema::Result::Country;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Country

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<countries>

=cut

__PACKAGE__->table("countries");

=head1 ACCESSORS

=head2 code

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "code",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</code>

=back

=cut

__PACKAGE__->set_primary_key("code");

=head1 RELATIONS

=head2 users

Type: has_many

Related object: L<BananaDuck::Schema::Result::User>

=cut

__PACKAGE__->has_many(
  "users",
  "BananaDuck::Schema::Result::User",
  { "foreign.country" => "self.code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-06 01:05:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WPEjrv1OVasDPGtPcYZXYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
