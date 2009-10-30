package Method::Delegater;
use strict;
use warnings;

our $VERSION = '0.01';

sub import {
    my $caller = caller(0);

    no strict 'refs'; ## no critic.
    *{"${caller}::delegate"} = \&_delegate;
}

sub _delegate {
    my ($class, @methods) = @_;

    eval "use $class"; ## no critic.
    if ( $@ ) { die "can not use $class." }

    my $caller = caller(0);

    for my $method (@methods) {
        my $code = $class->can($method);
        no strict 'refs'; ## no critic.
        *{"${caller}::${method}"} = $code;
    }
}

1;

=head1 NAME

Method::Delegater - delegete other class method.

=head1 SYNOPSIS

  package Your::Module;
  use Method::Delegater;
  delegate 'Foo' => qw/bar baz/;

  use Your::Module;
  Yor::Module->bar;

=head1 DESCRIPTION

delegate other class method for your class.

=head1 AUTHOR

Atsushi Kobayashi <nekokak __at__ gmail.com>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
