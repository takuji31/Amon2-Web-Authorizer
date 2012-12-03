package Amon2::Plugin::Web::Authorizer;
use 5.012_001;
use warnings;

sub init {
    my ($class, $pkg, $opts) = @_;





    $pkg->add_trigger(
        BEFORE_DISPATCH => sub  {
            my ($c, ) = @_;
            
        },
    );
}

1;
