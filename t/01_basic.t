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

    delegate 'Foo' => qw/bar baz/;

    1;
}

describe 'method delegate test' => run {
    test 'bar baz methods delegate ok?' => run {
        can_ok 'Mock', qw/bar baz/;
    };
};

