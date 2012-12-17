package BananaDuck::Config;

use Mojo::Base 'Class::Singleton';
use Mojo::JSON;

has 'config';

sub _new_instance {
    my ($class) = @_;

    my @config_files = glob("$ENV{MOJO_HOME}/conf/*.json");
    my %config;

    for my $file (@config_files) {
        warn qq{Reading config file "$file".\n};
        my $content = do { open my $fh, '<', $file or die "Can't open $file: $!"; local $/; <$fh> };

        my $json = Mojo::JSON->new;
        my $data = $json->decode($content);
        my $error = $json->error;

        die qq{Couldn't parse "$file": $error} if $error;

        while (my ($k, $v) = each $data) {
            $config{$k} = $v;
        }
    }

    bless { config => \%config }, $class;
}

1;
