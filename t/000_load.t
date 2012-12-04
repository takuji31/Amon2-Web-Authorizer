#!perl -w
use strict;

use t::Util;
use Test::More;
use Test::LoadAllModules;

BEGIN {
    use_ok 'Amon2::Plugin::Web::Authorizer';
    all_uses_ok(search_path => 'Amon2::Web::Authorizer');
}
