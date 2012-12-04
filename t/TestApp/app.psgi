use strict;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Plack::Builder;

use TestApp::Web;
builder {
    enable 'Plack::Middleware::Session';
    TestApp::Web->to_app();
};
