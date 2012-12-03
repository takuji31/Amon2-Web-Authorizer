package Amon2::Web::Authorizer;
use 5.012_001;
use warnings;

our $VERSION = '0.01';



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
            config => 'Simple',
            mode_name => 'auth',
            on_error => sub {
                my ($c, ) = @_;
                $c->create_response(
                    401 => [
                        'Content-Type' => 'text/plain',
                        'Content-Length' => 11
                    ],[
                        'Unauthorized',
                    ]
                );
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
