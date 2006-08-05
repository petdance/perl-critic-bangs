use strict;
use warnings;
use Test::More tests => 1;
use Perl::Critic::Config;
use Perl::Critic;

# common P::C testing tools
use lib qw(t/tlib);
use PerlCriticTestUtils qw(pcritique);
PerlCriticTestUtils::block_perlcriticrc();

my $code = <<'END_PERL';
# this comment is OK
# XXX I need to fix this comment
my $foo = '#XXX';
my $XXX = 'foo';
END_PERL

my $policy = 'Bangs::ProhibitFlagComments';
is( pcritique($policy, \$code), 1, $policy);
