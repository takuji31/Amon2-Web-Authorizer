package TestApp::Web;
use strict;
use warnings;
use utf8;
use parent qw/TestApp Amon2::Web/;
use File::Spec;

# dispatcher
use TestApp::Web::Dispatcher;
sub dispatch {
    return (TestApp::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

if ($ENV{TEST_TYPE} && $ENV{TEST_TYPE} eq 'file') {
    __PACKAGE__->load_plugin(
        'Web::Authorizer' => {
            config => 'File',
            file   => 'auth.pl',
            error_callbacks =>{
                login => sub {
                    my ($c, $args) = @_;
                    return $c->redirect('/account/login');
                },
            },
        },
    );
} elsif ($ENV{TEST_TYPE} && $ENV{TEST_TYPE} eq 'yaml') {
    __PACKAGE__->load_plugin(
        'Web::Authorizer' => {
            config => 'YAML',
            file   => 'auth.yaml',
            error_callbacks =>{
                login => sub {
                    my ($c, $args) = @_;
                    return $c->redirect('/account/login');
                },
            },
        },
    );
} elsif ($ENV{TEST_TYPE} && $ENV{TEST_TYPE} eq 'list') {
    __PACKAGE__->load_plugin(
        'Web::Authorizer' => {
            config => 'List',
            data   => [
                '/user/only' => {
                    modules => [
                        'Session' => {
                            key => 'is_user',
                        },
                    ],
                    on_error => 'login',
                },
                '/user/mypage' => {
                    modules => [
                        'or' => [
                            'Session' => {
                                key => 'is_user',
                            },
                            'Session' => {
                                key => 'is_dev',
                            },
                        ],
                    ],
                    on_error => 'login',
                },
                '/developer/only' => {
                    modules => [
                        'and' => [
                            'Session' => {
                                key => 'is_user',
                            },
                            'Session' => {
                                key => 'is_dev',
                            },
                        ],
                    ],
                    on_error => 'login',
                },
            ],
            error_callbacks =>{
                login => sub {
                    my ($c, $args) = @_;
                    return $c->redirect('/account/login');
                },
            },
        },
    );
} else {
    die "TEST_TYPE not defined";
}

1;
