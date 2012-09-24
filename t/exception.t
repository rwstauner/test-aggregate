#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

aggregate('Test::Aggregate');

SKIP: {
    skip 'Need Test::More::subtest() for nested tests', 1
        if !Test::More->can('subtest');

    aggregate('Test::Aggregate::Nested');
}

done_testing;

sub aggregate {
    my $mod = shift;
    eval "require $mod" or die $@;

    # Test::Tester didn't work well with Test::Aggregate
    # so just override the functions used in the tests
    my $tb = {};
    {
        no strict 'refs';
        no warnings 'redefine';
        my $ok = \&Test::More::ok;
        # call the original ok with a true value so that there is a passing test
        local *Test::More::ok   = sub ($;$) { push @{ $tb->{ok}   }, [@_]; $ok->(1, 'shh'); };
        local *Test::More::diag = sub { push @{ $tb->{diag} }, $_[0] };

        $mod->new({
            dirs => 'aggtests-exception',
        })->run;
    }

    is scalar(grep { /Ensure exceptions are not hidden during aggregate tests/ } @{ $tb->{diag} }), 1,
        'Exception displayed via diag()';
}
