use strict;
use strict;

use t::Util;
use Test::More;
use Test::WWW::Mechanize::PSGI;

my $app = load_app;
my $mech = Test::WWW::Mechanize::PSGI->new(app => $app);

subtest "not login" => sub {
    $mech->get_ok('/user/only');
    $mech->content_is('please login' => 'Not logined and redirect');
};

subtest "logined" => sub {
    $mech->post_ok('/account/login', {user_id => 1}, 'do login');
    $mech->get_ok('/user/only');
    $mech->content_is('user only!' => 'Logined');
};

subtest "logouted" => sub {
    $mech->post_ok('/account/logout', 'do logout');
    $mech->get_ok('/user/only');
    $mech->content_is('please login' => 'Logouted');
};


done_testing;
