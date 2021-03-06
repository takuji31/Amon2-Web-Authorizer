use strict;
use warnings;
use Module::Build;
my $build = Module::Build->new(
    dist_author => 'Nishibayashi Takuji <takuji31@gmail.com>',
    dist_abstract => 'Amon2 authorization plugin',
    license     => 'perl',
    module_name => 'Amon2::Web::Authorizer',
    configure_requires => {'Module::Build' => '0.38'},
    requires => {
        'perl'       => '5.12.1',
        'Amon2'      => '3.00',
        'YAML::Syck' => '0',
    },
    build_requires => {
        'Test::LoadAllModules' => '0.021',
        'Test::More' => '0.98',
        'Test::WWW::Mechanize::PSGI' => '0',
    },
    test_files => (-d '.git/' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,

    create_readme => 1,
    create_license => 1,
    create_makefile_pl => 'small',
);
$build->create_build_script;
