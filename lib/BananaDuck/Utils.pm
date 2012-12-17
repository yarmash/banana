package BananaDuck::Utils;

use strict;
use warnings;

use Digest::MD5 'md5_hex';
use Data::UUID ();
use Encode qw(is_utf8 encode_utf8);

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(
    get_confirmation_code
    get_file_url
    get_oauth_state_param
    get_password_hash
    get_random_string
    get_salt
    get_uuid_hex
);

sub get_random_string {
    my ($length) = @_;

    my @chars = ("A" .. "Z", "a" .. "z", 0 .. 9);
    my $str = join("", @chars[ map rand(@chars), 1 .. $length ]);
    return $str;
}

sub get_uuid_hex {
    return lc(substr Data::UUID->new->create_hex, 2);
}

sub get_salt {
    return get_random_string(16);
}

sub get_oauth_state_param {
    return get_random_string(10);
}

sub get_confirmation_code {
    return get_uuid_hex;
}

sub get_password_hash {
    # md5_hex() works with bytes only
    return md5_hex( map { is_utf8($_) ? encode_utf8($_) : $_ } @_ );
}

# generates a new url for an uploaded file
# $orig_name is used to preserve the extension
sub get_file_url {
    my ($orig_name) = @_;

    my $filename = get_uuid_hex;

    if ($orig_name && $orig_name =~ /\.([^.]+)\z/) {
        $filename .= ".$1";
    }

    # use additional directory structure (for performance)
    my @subdirs = $filename =~ /^(..)(..)/;

    return join '/', '/files', @subdirs, $filename;
}

1;
