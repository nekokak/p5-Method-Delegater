use strict;
use warnings;
use Test::Declare;
use lib './t/lib';

plan tests => blocks;

{
    package Mock;
    use strict;
    use warnings;
    use Method::Delegater;
    use Foo;

    sub new {
        my $class = shift;
        bless {}, $class;
    }
    delegate '_foo' => install {
        initialize {
            my $self = shift;
            Foo->new($self);
        };
        handles [qw/bar baz foo/];
    };

    1;
}

describe 'method delegate test' => run {
    test 'bar baz methods delegate ok?' => run {
        can_ok 'Mock', qw/bar baz/;
    };

    test 'delegate methods tests' => run {
        my $obj = Mock->new;
        is $obj->bar, 'bar';
        is $obj->baz, 'baz';
        isa_ok $obj->foo, 'Foo';
        isa_ok $obj->foo->{base}, 'Mock';
    };
};

