package TestApp::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

any '/' => sub {
    my ($c) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['top']);
};

get '/user/mypage' => sub {
    my ($c, $args) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['mypage']);
};

get '/user/only' => sub {
    my ($c, $args) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['user only!']);
};

get '/developer/only' => sub {
    my ($c, $args) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['developer only!']);
};

get '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

get '/account/login' => sub {
    my ($c, $args) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['please login']);
};

get '/account/developer' => sub {
    my ($c, $args) = @_;
    $c->session->set(is_dev => 1);
    $c->redirect('/');
};

get '/account/user' => sub {
    my ($c, $args) = @_;
    $c->session->set(is_user => 1);
    $c->redirect('/');
};

1;
