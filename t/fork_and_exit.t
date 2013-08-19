use strict;
use warnings;
use Test::More tests => 2; # 1 in agg test, 1 subtest
use lib 't/lib';
use AggTestTester;

my $args = {
  tests => [catfile(qw(aggtests-extras fork_and_exit.t))],
};

Test::Aggregate->new({%$args})->run;

only_with_nested {
  subtest nested => sub {
    Test::Aggregate::Nested->new({%$args})->run;
  };
};
