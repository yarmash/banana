use utf8;
package BananaDuck::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BananaDuck::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_id_seq'

=head2 login

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 salt

  data_type: 'varchar'
  is_nullable: 1
  size: 16

A random string for salting the password

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 32

MD5 hash

=head2 full_name

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 birthday

  data_type: 'date'
  is_nullable: 1

=head2 sex

  data_type: 'char'
  is_nullable: 1
  size: 1

Or see http://en.wikipedia.org/wiki/ISO_5218

=head2 is_email_confirmed

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 country

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 avatar

  data_type: 'text'
  is_nullable: 1

=head2 city

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 is_subscribed

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 dishes_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 favorites_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 likes_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 followers_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 followees_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_id_seq",
  },
  "login",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "salt",
  { data_type => "varchar", is_nullable => 1, size => 16 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "full_name",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "birthday",
  { data_type => "date", is_nullable => 1 },
  "sex",
  { data_type => "char", is_nullable => 1, size => 1 },
  "is_email_confirmed",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "created",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "country",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "avatar",
  { data_type => "text", is_nullable => 1 },
  "city",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "is_subscribed",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "dishes_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "favorites_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "likes_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "followers_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "followees_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<users_email_key>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("users_email_key", ["email"]);

=head2 C<users_login_key>

=over 4

=item * L</login>

=back

=cut

__PACKAGE__->add_unique_constraint("users_login_key", ["login"]);

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<BananaDuck::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "BananaDuck::Schema::Result::Comment",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 confirmations

Type: has_many

Related object: L<BananaDuck::Schema::Result::Confirmation>

=cut

__PACKAGE__->has_many(
  "confirmations",
  "BananaDuck::Schema::Result::Confirmation",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 country

Type: belongs_to

Related object: L<BananaDuck::Schema::Result::Country>

=cut

__PACKAGE__->belongs_to(
  "country",
  "BananaDuck::Schema::Result::Country",
  { code => "country" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 dishes

Type: has_many

Related object: L<BananaDuck::Schema::Result::Dish>

=cut

__PACKAGE__->has_many(
  "dishes",
  "BananaDuck::Schema::Result::Dish",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 events

Type: has_many

Related object: L<BananaDuck::Schema::Result::Event>

=cut

__PACKAGE__->has_many(
  "events",
  "BananaDuck::Schema::Result::Event",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 fb_connection

Type: might_have

Related object: L<BananaDuck::Schema::Result::FbConnection>

=cut

__PACKAGE__->might_have(
  "fb_connection",
  "BananaDuck::Schema::Result::FbConnection",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 flags

Type: has_many

Related object: L<BananaDuck::Schema::Result::Flag>

=cut

__PACKAGE__->has_many(
  "flags",
  "BananaDuck::Schema::Result::Flag",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 places

Type: has_many

Related object: L<BananaDuck::Schema::Result::Place>

=cut

__PACKAGE__->has_many(
  "places",
  "BananaDuck::Schema::Result::Place",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 published_events

Type: has_many

Related object: L<BananaDuck::Schema::Result::PublishedEvent>

=cut

__PACKAGE__->has_many(
  "published_events",
  "BananaDuck::Schema::Result::PublishedEvent",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tokens

Type: has_many

Related object: L<BananaDuck::Schema::Result::Token>

=cut

__PACKAGE__->has_many(
  "tokens",
  "BananaDuck::Schema::Result::Token",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tw_connection

Type: might_have

Related object: L<BananaDuck::Schema::Result::TwConnection>

=cut

__PACKAGE__->might_have(
  "tw_connection",
  "BananaDuck::Schema::Result::TwConnection",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_favorites

Type: has_many

Related object: L<BananaDuck::Schema::Result::Favorite>

=cut

__PACKAGE__->has_many(
  "user_favorites",
  "BananaDuck::Schema::Result::Favorite",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_followees

Type: has_many

Related object: L<BananaDuck::Schema::Result::Follower>

=cut

__PACKAGE__->has_many(
  "user_followees",
  "BananaDuck::Schema::Result::Follower",
  { "foreign.follower_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_followers

Type: has_many

Related object: L<BananaDuck::Schema::Result::Follower>

=cut

__PACKAGE__->has_many(
  "user_followers",
  "BananaDuck::Schema::Result::Follower",
  { "foreign.followee_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_likes

Type: has_many

Related object: L<BananaDuck::Schema::Result::Like>

=cut

__PACKAGE__->has_many(
  "user_likes",
  "BananaDuck::Schema::Result::Like",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 favorites

Type: many_to_many

Composing rels: L</user_favorites> -> dish

=cut

__PACKAGE__->many_to_many("favorites", "user_favorites", "dish");

=head2 followees

Type: many_to_many

Composing rels: L</user_followees> -> followee

=cut

__PACKAGE__->many_to_many("followees", "user_followees", "followee");

=head2 followers

Type: many_to_many

Composing rels: L</user_followers> -> follower

=cut

__PACKAGE__->many_to_many("followers", "user_followers", "follower");

=head2 likes

Type: many_to_many

Composing rels: L</user_likes> -> dish

=cut

__PACKAGE__->many_to_many("likes", "user_likes", "dish");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-11-01 21:33:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7TU5et4sq4TkbAUiTjyE1Q

# You can replace this text with custom code or comments, and it will be preserved on regeneration

# returns boolean
sub is_event_published {
    my ($self, $event) = @_;
    return $self->published_events({ type_id => $event->type_id }, { select => [\1] })->single ? 1 : 0;
}

1;
