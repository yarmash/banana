package BananaDuck::API::Method::CountryCodes;

use Mojo::Base 'BananaDuck::API::Method';

sub execute {
    my ($self) = @_;

    my $rs = $self->schema->resultset('Country');
    my %codes;

    while (my $country = $rs->next) {
        $codes{$country->code} = $country->name;
    }

    return BananaDuck::API::Result->new(data => { country_codes => \%codes });
}

1;
