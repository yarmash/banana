use utf8;
package BananaDuck::Schema::Result::Dish;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::Dish

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<dishes>

=cut

__PACKAGE__->table("dishes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'dishes_id_seq'

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 picture

  data_type: 'text'
  is_nullable: 0

=head2 place_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 likes_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 favorites_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 comments_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 cuisine_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

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
    sequence          => "dishes_id_seq",
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "picture",
  { data_type => "text", is_nullable => 0 },
  "place_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "likes_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "favorites_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "comments_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "cuisine_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
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

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<BananaDuck::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "BananaDuck::Schema::Result::Comment",
  { "foreign.dish_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 cuisine

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::Cuisine>

=cut

__PACKAGE__->belongs_to(
  "cuisine",
  "BananaDuck::Schema::Result::Cuisine",
  { id => "cuisine_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 events

Type: has_many

Related object: L<BananaDuck::Schema::Result::Event>

=cut

__PACKAGE__->has_many(
  "events",
  "BananaDuck::Schema::Result::Event",
  { "foreign.dish_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 favorites

Type: has_many

Related object: L<BananaDuck::Schema::Result::Favorite>

=cut

__PACKAGE__->has_many(
  "favorites",
  "BananaDuck::Schema::Result::Favorite",
  { "foreign.dish_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 flags

Type: has_many

Related object: L<BananaDuck::Schema::Result::Flag>

=cut

__PACKAGE__->has_many(
  "flags",
  "BananaDuck::Schema::Result::Flag",
  { "foreign.dish_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 likes

Type: has_many

Related object: L<BananaDuck::Schema::Result::Like>

=cut

__PACKAGE__->has_many(
  "likes",
  "BananaDuck::Schema::Result::Like",
  { "foreign.dish_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 place

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::Place>

=cut

__PACKAGE__->belongs_to(
  "place",
  "BananaDuck::Schema::Result::Place",
  { id => "place_id" },
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

=head2 users_favorited

Type: many_to_many

Composing rels: L</favorites> -> user

=cut

__PACKAGE__->many_to_many("users_favorited", "favorites", "user");

=head2 users_liked

Type: many_to_many

Composing rels: L</likes> -> user

=cut

__PACKAGE__->many_to_many("users_liked", "likes", "user");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-10-09 17:00:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J46J91qDnrBBxvQUc4IF0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
