use utf8;
package BananaDuck::Schema::Result::PublishedEvent;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::PublishedEvent - Contains events that user wants to be published in FB

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<published_events>

=cut

__PACKAGE__->table("published_events");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</type_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "type_id");

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kqwDg+49TSgAN1kTf5LXxw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
