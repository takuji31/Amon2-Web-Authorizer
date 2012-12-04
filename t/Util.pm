package t::Util;
use 5.012_001;
use warnings;

use File::Basename;
use File::Spec;
use lib File::Spec->catdir(dirname(__FILE__), 'TestApp', 'lib');
use Plack::Util;

use parent qw/Exporter/;

our @EXPORT = qw/load_app/;

$ENV{PLACK_ENV} = 'test';

sub load_app {
    return Plack::Util::load_psgi(File::Spec->catfile(dirname(__FILE__), 'TestApp', 'app.psgi'));
}

1;
