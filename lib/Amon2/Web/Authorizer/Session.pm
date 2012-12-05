package Amon2::Web::Authorizer::Session;
use 5.012_001;
use warnings;
use utf8;

use parent qw/Amon2::Web::Authorizer/;

sub authorize {
    my ($self, $c, $args) = @_;
    my $key = $self->{key};
    die "Session key is required!" unless $key;

    my $equals = $self->{equals};
    my $value = $c->session->get($key);

    return (!defined $equals && defined $value) || (defined $equals && defined $value && $value eq $equals );
}

1;
