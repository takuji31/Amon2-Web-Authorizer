package Amon2::Web::Authorizer;
use 5.012_001;
use warnings;

our $VERSION = '0.01';

use Carp;
use Plack::Util;
use Amon2::Web::Authorizer::Logical;

sub new {
    my ($class, $opts) = @_;
    $opts //= {};
    bless $opts, $class;
}

sub load {
    my ($class, $pkg, $opts) = @_;
    if ($pkg eq 'and' || $pkg eq 'or') {
        $opts //= [];
        return Amon2::Web::Authorizer::Logical->new($pkg => $opts);
    } else {
        $opts //= {};
        $pkg = Plack::Util::load_class($pkg, __PACKAGE__);
        return $pkg->new($opts);
    }
}

sub authorize {
    croak("Please override authorize method");
}


1;
__END__

=head1 NAME

Amon2::Web::Authorizer - Amon2 authorization module

=head1 VERSION

This document describes Amon2::Web::Authorizer version 0.01.

=head1 SYNOPSIS

    #Your Web class
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

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.12.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<Amon2>

=head1 AUTHOR

Nishibayashi Takuji E<lt>takuji31@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, Nishibayashi Takuji. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
