package Amon2::Plugin::Web::Authorizer;
use 5.012_001;
use warnings;

use Amon2::Util;
use Carp;
use Class::Load;
use Plack::Util;
use Router::Simple;

sub init {
    my ($class, $pkg, $opts) = @_;

    $opts //= {};

    my $auth_package = Plack::Util::load_class($opts->{config} // '', 'Amon2::Web::Authorizer::Config');
    my $auth_config = $auth_package->get_config($pkg, $opts);


    my $router = Router::Simple->new;

    $opts->{error_callbacks} //= {};
    $opts->{error_callbacks}->{default} //= \&default_error_callback;

    while (my ($path, $route) = splice(@$auth_config, 0, 2)) {

        croak("module option is required") unless $route->{module};
        $route->{module} = Plack::Util::load_class($route->{module}, 'Amon2::Web::Authorizer');

        my $on_error = $route->{on_error} // 'default';
        my $on_error_callback = ref $on_error && ref $on_error eq 'CODE' ? $on_error : $opts->{error_callbacks}{$on_error};
        croak("Error callback $on_error not found") unless $on_error_callback;
        $route->{on_error} = $on_error_callback;

        $router->connect($path, $route);
    }


    $pkg->add_trigger(
        BEFORE_DISPATCH => sub  {
            my ($c, ) = @_;
            my $env = $c->req->env;
            if (my $p = $router->match($env)) {
                my $result = $p->{module}->authorize($c, $p);
                unless ($result) {
                    return $p->{on_error}->($c, $p);
                }
            }
            return;
        },
    );
}

sub default_error_callback {
    my ($c, $args) = @_;
    return $c->create_response(
        401 => [
            'Content-Type' => 'text/plain',
            'Content-Length' => 11
        ],[
            'Unauthorized',
        ]
    );
}

1;
