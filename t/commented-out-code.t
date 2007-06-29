#!perl
use strict;
use warnings;
use Test::More tests => 3;
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

# pass in the default regex used to look for commented code. This
# should behave just as though no extra configuration were provided.
DEFAULTPROFILE: {
    my $code = <<'END_PERL';
my $one = 1;
my $two = '# $foo = "bar"';
# my $three = 'three';
# $four is an important variable.
END_PERL

    my $policy = 'Bangs::ProhibitCommentedOutCode';
    my $config = { commentedcoderegex => q(\$[A-Za-z_].*=) };

    is( pcritique( $policy, \$code, $config ), 1, $policy);
}


# To demonstrate that the config file works, change the regex used to
# look for commented code to only look for variables named 'bang'
# Bug submitted by Oystein Torget
CHANGEPROFILE: {
    my $code = <<'END_PERL';
my $one = 1;
my $two = '# $foo = "bar"';
# my $three = 'three';
# my $bang = 'three';
# $four is an important variable.
END_PERL

    my $policy = 'Bangs::ProhibitCommentedOutCode';
    my $config = { commentedcoderegex => q(\$bang.*=) };

    is( pcritique( $policy, \$code, $config ), 1, $policy);
}


