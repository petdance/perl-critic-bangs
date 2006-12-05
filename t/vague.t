#!perl
use strict;
use warnings;
use Test::More tests => 5;
use Perl::Critic::Config;
use Perl::Critic;

BEGIN {
    use_ok( 'Perl::Critic::Policy::Bangs::ProhibitVagueNames' );
}

# common P::C testing tools
use lib qw(t/tlib);
use PerlCriticTestUtils qw(pcritique);
PerlCriticTestUtils::block_perlcriticrc();

my $test_policy = 'Bangs::ProhibitVagueNames';

COMPLETENESS: {
    my $code = <<'END_PERL';
    my $data = 'foo';
    my $obj = bless {}, 'Class::Name';
    my $target_user = "Named well";
    my $tmp = 12;
    my $temp = $a;
    my $var = "Duh, it's a var.";
    my $data2 = "This will not fail, but will be picked up by ProhibitNumberedNames";
END_PERL

    is( pcritique($test_policy, \$code), 5, $test_policy);
}

ALL_FORMS: {
    my $code = <<'END_PERL';
    my $var = 'crap';
    my @var = qw( crap crap );
    my %var = ( crap => 'crap' );
END_PERL

    is( pcritique($test_policy, \$code), 3, $test_policy);
}

ADD_FROM_CONFIG: {
    my $code = <<'END_PERL';
    my $unspecific = 'crap';
    my $data = 'bonzo';
END_PERL

    is( pcritique($test_policy, \$code, {add_names=>'unspecific vague mumbly'}), 2, 'Should find new vague name');
}

REPLACE_FROM_CONFIG: {
    my $code = <<'END_PERL';
    my $unspecific = 'crap';
    my $data = 'bonzo';
END_PERL

    is( pcritique($test_policy, \$code, {names=>'unspecific vague mumbly'}), 1, 'Should find ONLY new vague name');
}
