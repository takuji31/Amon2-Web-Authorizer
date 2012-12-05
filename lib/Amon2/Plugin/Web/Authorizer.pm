package Amon2::Plugin::Web::Authorizer;
use 5.012_001;
use warnings;

use Amon2::Web::Authorizer;
use Amon2::Util;
use Carp;
use Class::Load;
use Router::Simple;

sub init {
    my ($class, $pkg, $opts) = @_;

    $opts //= {};

    my $auth_package = Plack::Util::load_class($opts->{config} // '', 'Amon2::Web::Authorizer::Config');
    my $auth_config = $auth_package->get_config($pkg, $opts);


    my $router = Router::Simple->new;

    $opts->{error_callbacks} //= {};
    $opts->{error_callbacks}->{default} //= \&default_error_callback;

    while (my ($path, $auth_opts) = splice(@$auth_config, 0, 2)) {

        croak("modules or authorizer option is required") unless $auth_opts->{modules} || $auth_opts->{authorizer};
        $auth_opts->{authorizer} = Amon2::Web::Authorizer->load(@{delete $auth_opts->{modules}});

        my $on_error = $auth_opts->{on_error} // 'default';
        my $on_error_callback = ref $on_error && ref $on_error eq 'CODE' ? $on_error : $opts->{error_callbacks}{$on_error};
        croak("Error callback $on_error not found") unless $on_error_callback;
        $auth_opts->{on_error} = $on_error_callback;

        $router->connect($path, $auth_opts);
    }


    $pkg->add_trigger(
        BEFORE_DISPATCH => sub  {
            my ($c, ) = @_;
            my $env = $c->req->env;
            if (my $p = $router->match($env)) {
                my $result = $p->{authorizer}->authorize($c, $p);
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
