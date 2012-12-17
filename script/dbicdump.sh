#!/bin/bash

cd $(dirname $0)/..

dbicdump -Ilib -o dump_directory=lib \
    -o exclude='qr/geography_columns|geometry_columns|spatial_ref_sys|confirmation_types|event_types|flag_types/' \
    -o rel_name_map='{
        User => {
            favorites           => "user_favorites",
            followers_followees => "user_followers",
            followers_followers => "user_followees",
            likes               => "user_likes",
            favorites_3s        => "dishes",
            dishes              => "favorites",
            favorites_2s        => "likes",
        },
        Dish => {
            users              => "users_favorited",
            users_favorited_2s => "users_liked",
        },
    }' \
    -o filter_generated_code='sub {
        my ($type, $class, $text) = @_;

        if ($class eq "BananaDuck::Schema::Result::User") {
            $text =~ s{\QComposing rels: L</user_followers> -> followee}{Composing rels: L</user_followees> -> followee};
            $text =~ s{\Q__PACKAGE__->many_to_many("followees", "user_followers", "followee")}{__PACKAGE__->many_to_many("followees", "user_followees", "followee")};
        }
        return $text;
    },' \
    $* \
    BananaDuck::Schema dbi:Pg:dbname=bananaduck bananaduck g8qJ9zP22

cd - > /dev/null
git status -sb
