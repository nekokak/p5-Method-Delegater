use inc::Module::Install;
name 'Method-Delegater';
all_from 'lib/Method/Delegater.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
