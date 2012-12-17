package BananaDuck::Constants;

use Mojo::Base 'Exporter';

our %EXPORT_TAGS = (
    auth_levels => [qw(
        AUTH_CLIENT
        AUTH_NONE
        AUTH_TOKEN
    )],
    event_types => [qw(
        EVENT_DISH_COMMENT
        EVENT_DISH_FAVORITE
        EVENT_DISH_LIKE
        EVENT_DISH_NEW
    )],
    confirmation_types => [qw(
        CONFIRMATION_EMAIL
        CONFIRMATION_PASSWORD_RESET
    )],
);

Exporter::export_ok_tags(qw( auth_levels event_types confirmation_types ));

sub AUTH_NONE()   { 0 }
sub AUTH_TOKEN()  { 1 }
sub AUTH_CLIENT() { 2 }

sub EVENT_DISH_NEW()      { 1 }
sub EVENT_DISH_FAVORITE() { 2 }
sub EVENT_DISH_LIKE()     { 3 }
sub EVENT_DISH_COMMENT()  { 4 }

sub CONFIRMATION_EMAIL()          { 1 }
sub CONFIRMATION_PASSWORD_RESET() { 2 }

1;
