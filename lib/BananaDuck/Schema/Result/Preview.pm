use utf8;
package BananaDuck::Schema::Result::Preview;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Preview

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<previews>

=cut

__PACKAGE__->table("previews");

=head1 ACCESSORS

=head2 image_url

  data_type: 'text'
  is_nullable: 0

Relative url (but absolute path)

=head2 width

  data_type: 'integer'
  is_nullable: 0

=head2 height

  data_type: 'integer'
  is_nullable: 0

=head2 preview_url

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "image_url",
  { data_type => "text", is_nullable => 0 },
  "width",
  { data_type => "integer", is_nullable => 0 },
  "height",
  { data_type => "integer", is_nullable => 0 },
  "preview_url",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</image_url>

=item * L</width>

=item * L</height>

=back

=cut

__PACKAGE__->set_primary_key("image_url", "width", "height");

=head1 UNIQUE CONSTRAINTS

=head2 C<previews_preview_url_key>

=over 4

=item * L</preview_url>

=back

=cut

__PACKAGE__->add_unique_constraint("previews_preview_url_key", ["preview_url"]);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-11-21 17:31:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KDMXmy2dYzxUHEg2NZs1Vw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
