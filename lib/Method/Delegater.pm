package Method::Delegater;
use strict;
use warnings;

our $VERSION = '0.01';

sub import {
    my $caller = caller(0);

    my $_delegate_info = {};

    {
        no strict 'refs'; ## no critic.
        *{"$caller\::_delegate_info"} = sub { $_delegate_info };
        for my $func (qw/delegate initialize handles install/) {
            *{"$caller\::$func"} = \&$func;
        }
    }
}

sub _get_caller_class {
    my $caller = caller(1);
    return $caller;
}

sub delegate ($$) {
    my ($key, $code) = @_;

    my $class = _get_caller_class;
    $class->_delegate_info->{stack}->{building_key} = $key;

    $code->();

    return;
}

sub install (&) { shift }

sub initialize (&) {
    my $code = shift;

    my $class = _get_caller_class;
    $class->_delegate_info->{building_initializer} = $code;
}

sub handles {
    my $args = shift;

    my $class = _get_caller_class;
    my $key = $class->_delegate_info->{stack}->{building_key};
    my $code = $class->_delegate_info->{building_initializer};

    for my $func (@{$args}) {
        no strict 'refs'; ## no critic.
        *{"${class}::${func}"} = sub {
            my $self = shift;
            # die
            $self->{$key} ||= $self->$code; 
            $self->{$key}->$func(@_);
        };
    }
}

1;

=head1 NAME

Method::Delegater - delegete other class method.

=head1 SYNOPSIS

  package Your::Module;
  use Method::Delegater;
  delegate key => install {
      initialize => {
          my $self = shift;
          Foo->new($self);
      },
      handles => [qw/bar baz/],
  }

  use Your::Module;
  my $obj = Your::Module->new;
  $boj->bar;

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
