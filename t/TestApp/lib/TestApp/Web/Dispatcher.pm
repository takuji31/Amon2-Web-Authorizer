package TestApp::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

any '/' => sub {
    my ($c) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['top']);
};

get '/user/only' => sub {
    my ($c, $args) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['user only!']);
};

get '/developer/only' => sub {
    my ($c, $args) = @_;
    $c->create_response(200, ['Content-Type' => 'text/plain'], ['user only!']);
};

post '/account/logout' => sub {
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

post '/account/login' => sub {
    my ($c, $args) = @_;
    my $user_id = $c->req->param('user_id');
    $c->session->set(user_id => $user_id);
    $c->redirect('/');
};

1;
