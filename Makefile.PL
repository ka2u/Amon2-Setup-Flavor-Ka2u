use inc::Module::Install;
use Module::Install::AuthorTests;

name 'Amon2-Setup-Flavor-Ka2u';
all_from 'lib/Amon2/Setup/Flavor/Ka2u.pm';

# requires '';
# requires 'Exporter' => 5.63; # use Exporter 'import';
# requires 'Plack' =>  0.9949;
requires 'Amon2' => 0;
requires 'File::Slurp' => 0;


tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More' => 0.96; # done_testing, subtest
# test_requires 'Test::Requires';
#author_tests('xt');
WriteAll;
