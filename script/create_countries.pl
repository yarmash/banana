#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";

use Mojo::Base -strict;
use BananaDuck::Schema;
use Locale::Country;

main();

sub main {
    my $schema = BananaDuck::Schema->connect;

    create_countries($schema);
}

sub create_countries {
    my ($schema) = @_;

    my $rs = $schema->resultset('Country');

    for my $code ( all_country_codes( LOCALE_CODE_NUMERIC ) ) {
        my $name = code2country($code, LOCALE_CODE_NUMERIC);

        $rs->create({ code => $code, name => $name });
    }
}
