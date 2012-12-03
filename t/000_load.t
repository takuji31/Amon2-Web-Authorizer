#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Amon2::Web::Authorizer';
}

diag "Testing Amon2::Web::Authorizer/$Amon2::Web::Authorizer::VERSION";
