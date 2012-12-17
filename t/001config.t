#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';
use autodie;

use Mojo::JSON;
use Test::More tests => 4;

my $conf_dir = "$ENV{MOJO_HOME}/conf";
chdir $conf_dir;

my @config_files = qw(
    bananaduck.json
    messages.json
);

for my $file (@config_files) {
    parse_config($file);
}

sub parse_config {
    my ($file) = @_;

    my $content = do { open my $fh, '<', $file; local $/; <$fh> };
    my $json   = Mojo::JSON->new;
    my $config = $json->decode($content);
    my $err    = $json->error;

    ok(!$err, qq("$file" parsed ok)) or diag($err);
    ok(ref $config eq 'HASH', qq("$file" parsed to a hashref));

    note(explain($config));
}
