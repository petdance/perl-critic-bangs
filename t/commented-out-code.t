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
my $one = 1;
my $two = '# $foo = "bar"';
# my $three = 'three';
# $four is an important variable.
END_PERL

    my $policy = 'Bangs::ProhibitCommentedOutCode';
    is( pcritique($policy, \$code), 1, $policy);
}


