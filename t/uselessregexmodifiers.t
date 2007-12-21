#!perl
use strict;
use warnings;
use Test::More tests => 4;
use Perl::Critic::Config;
use Perl::Critic;

# common P::C testing tools
use lib qw(t/tlib);
use PerlCriticTestUtils qw(pcritique);
PerlCriticTestUtils::block_perlcriticrc();

my $policy = 'Bangs::ProhibitUselessRegexModifiers';

{
    my $code = <<'END_PERL';
my $regex = qr(asdf);
if ( $string =~ /$regex/m ) {
}
END_PERL

    is( pcritique($policy, \$code), 1, $policy);
}

{
    my $code = <<'END_PERL';
my $regex = qr(asdf);
if ( $string =~ /$regex/ ) {
}
END_PERL

    is( pcritique($policy, \$code), 0, $policy);
}

{
    my $code = <<'END_PERL';
my $regex = 'asdf';
if ( $string =~ /$regex/m ) {
}
END_PERL

    is( pcritique($policy, \$code), 0, $policy);
}

{
    my $code = <<'END_PERL';
my $regex = qr(asdf);
if ( $string =~ /foo$regex/m ) {
}
END_PERL

    is( pcritique($policy, \$code), 0, $policy);
}
