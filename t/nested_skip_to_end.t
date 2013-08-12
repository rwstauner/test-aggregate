#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib';
use AggTestTester;
use File::Spec::Functions qw(catfile); # core
use Test::Aggregate::Nested;
use Test::More;

only_with_nested {

  my $diag = \&Test::More::diag;
  my @diags;
  no warnings 'redefine';
  local *Test::More::diag = sub {
    # If it's one of the ones we want, capture it (and hide it).
    if( $_[0] =~ /WARNING:.+unknown if .+? actually finished/sm ){
      push @diags, $_[0];
    }
    # Else just do the normal.
    else {
      $diag->(@_);
    }
  };

  subtest Nested => sub {

    Test::Aggregate::Nested->new({
      verbose         => 2,
      tests           => [
        catfile('aggtests', 'skip_to_end.t'),
        catfile('aggtests-extras', 'skip_to_end_undefined.t'),
      ],
    })->run;

  };

  is @diags, 1, 'only captured one diag';

  foreach my $msg ( @diags ){
    like $msg,
      qr/ unknown if .+?\bskip_to_end_undefined\.t\b.+? actually finished/,
      'undefined value after skip produces warning';

    like $msg,
      qr/ error was set \(\$!\):/,
      'error message included in warning';
  }

};

done_testing;
