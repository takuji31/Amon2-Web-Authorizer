package Amon2::Web::Authorizer::Logical;
use 5.012_001;
use warnings;
use utf8;

use parent qw/Amon2::Web::Authorizer/;

sub new {
    my ($class, $logic, $modules) = @_;
    my @loaded_modules;
    while (my ($module, $opts) = splice(@$modules, 0, 2)) {
        push @loaded_modules, $class->load($module, $opts);
    }

    bless {modules => \@loaded_modules, logic => $logic}, $class;
}

sub authorize {
    my ($self, $c, $args) = @_;

    my $logic = $self->{logic};
    for my $module (@{$self->{modules}}){
        my $result = $module->authorize($c, $args);
        if ($logic eq 'and' && !$result) {
            return 0;
        } elsif ($logic eq 'or' && $result) {
            return 1;
        }
    }
    return $logic eq 'and';
}

1;
