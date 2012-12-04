package Amon2::Web::Authorizer::Session;
use 5.012_001;
use warnings;
use utf8;

sub authorize {
    my ($class, $c, $args) = @_;
    my $key = $args->{key};
    die "Session key is required!" unless $key;

    my $equals = $args->{equals};
    my $value = $c->session->get($key);

    return (!defined $equals && defined $value) || (defined $equals && defined $value && $value eq $equals );
}

1;
