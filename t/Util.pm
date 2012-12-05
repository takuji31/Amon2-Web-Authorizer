package t::Util;
use 5.012_001;
use warnings;

use File::Basename;
use File::Spec;
use Plack::Util;

use Test::More;
use Test::WWW::Mechanize::PSGI;

use parent qw/Exporter/;

our @EXPORT = qw/common_test/;

$ENV{PLACK_ENV} = 'test';

sub load_app {
    return Plack::Util::load_psgi(File::Spec->catfile(dirname(__FILE__), 'TestApp', 'app.psgi'));
}

sub common_test {
    my ($class, ) = @_;

    my $app = load_app;
    my $mech = Test::WWW::Mechanize::PSGI->new(app => $app);

    subtest "not login" => sub {
        $mech->get_ok('/user/only');
        $mech->content_is('please login' => 'Not logined and redirect');
    };

    subtest "single" => sub {

        $mech->get_ok('/account/user', 'login user');
        $mech->get_ok('/user/only');
        $mech->content_is('user only!' => 'Logined');

        $mech->get_ok('/account/logout', 'logout');

        $mech->get_ok('/account/developer', 'login developer');
        $mech->get_ok('/user/only');
        $mech->content_is('please login' => 'developer cannot access mypage');
    };

    subtest "or" => sub {
        $mech->get_ok('/account/logout', 'logout');

        $mech->get_ok('/account/user', 'login user');
        $mech->get_ok('/user/mypage');
        $mech->content_is('mypage' => 'Logined');

        $mech->get_ok('/account/logout', 'logout');

        $mech->get_ok('/account/developer', 'login developer');
        $mech->get_ok('/user/mypage');
        $mech->content_is('mypage' => 'Logined');

        $mech->get_ok('/account/user', 'login user');
        $mech->get_ok('/user/mypage');
        $mech->content_is('mypage' => 'Logined');

    };

    subtest "and" => sub {
        $mech->get_ok('/account/logout', 'logout');

        $mech->get_ok('/account/user', 'login user');
        $mech->get_ok('/developer/only');
        $mech->content_is('please login' => 'user cannot access developer only page');

        $mech->get_ok('/account/logout', 'logout');

        $mech->get_ok('/account/developer', 'login developer');
        $mech->get_ok('/developer/only');
        $mech->content_is('please login' => 'this is wrong user?');

        $mech->get_ok('/account/user', 'login user');
        $mech->get_ok('/developer/only');
        $mech->content_is('developer only!' => 'developer can access developer only page');
    };

    subtest "logouted" => sub {
        $mech->get_ok('/account/logout', 'do logout');
        $mech->get_ok('/user/only');
        $mech->content_is('please login' => 'Logouted');
    };

}

1;
