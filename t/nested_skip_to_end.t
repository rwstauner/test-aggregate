#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib';
use AggTestTester;
use File::Spec::Functions qw(catfile); # core
use Test::Aggregate::Nested;
use Test::More;

only_with_nested {

  aggregate(
      'Test::Aggregate::Nested',
      [
        catfile('aggtests-extras', 'skip_to_end_undefined.t'),
        catfile('aggtests', 'skip_to_end.t'),
      ],
      [
        [ 1, qr/Tests for .+?\bskip_to_end_undefined\.t/, 'skipped to end' ],
        [ 1, qr/Tests for .+?\bskip_to_end\.t/, 'skipped to end' ],
      ],
      diag => [
      ],
  );
};

done_testing;
