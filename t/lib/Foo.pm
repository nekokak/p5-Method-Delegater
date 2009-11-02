package Foo;
use strict;
use warnings;

sub new {
    my ($class, $base) = @_;
    bless {
        base => $base,
    }, $class;
}

sub foo { shift }
sub bar { 'bar' }
sub baz { 'baz' }

1;
