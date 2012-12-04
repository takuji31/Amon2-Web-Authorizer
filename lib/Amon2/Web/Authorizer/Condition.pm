package Amon2::Web::Authorizer::Condition;
use 5.012_001;
use warnings;
use utf8;

use Carp;

use parent qw/Amon2::Web::Authorizer/;

sub new {
    my ($class, $type, $modules) = @_;
    $modules //= {};


    die "Conditions are required" unless keys %$modules < 2;

    bless {type => $type, modules => $modules}, $class;
}

1;
