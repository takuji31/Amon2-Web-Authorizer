package Amon2::Web::Authorizer::Config;
use 5.012_001;
use warnings;
use utf8;

use Carp;

sub get_config {
    croak("Please override get_config method");
}

1;
