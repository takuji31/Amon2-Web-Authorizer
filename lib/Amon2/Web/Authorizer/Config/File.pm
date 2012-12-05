package Amon2::Web::Authorizer::Config::File;
use strict;
use warnings;
use utf8;
use 5.012_001;

use parent qw/Amon2::Web::Authorizer::Config/;

use Amon2::Config::Simple;
use File::Spec;

sub get_config {
    my ($class, $pkg, $opts) = @_;

    my $file = "@{[$opts->{file}]}.pl";

    my $config = do File::Spec->catfile($pkg->base_dir, 'config', $file);

    return $config;
}

1;
