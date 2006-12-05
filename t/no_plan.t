#!perl
use strict;
use warnings;
use Test::More tests => 1;
use Perl::Critic::Config;
use Perl::Critic;

# common P::C testing tools
use lib qw(t/tlib);
use PerlCriticTestUtils qw(pcritique);
PerlCriticTestUtils::block_perlcriticrc();

BASIC: {
    my $code = <<'END_PERL';
my @foo = qw( no_plan );
my $foo = 'Test::More qw( no_plan );';
use Test::More qw( no_plan );
use Test::More qw( ono_plan );
use Test::More qw( some_plan no_plan );
# use Test::More qw( no_plan );
END_PERL

    my $policy = 'Bangs::ProhibitNoPlan';
    is( pcritique($policy, \$code), 2, $policy);
}


