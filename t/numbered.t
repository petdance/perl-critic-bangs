use strict;
use warnings;
use Test::More tests => 6;
use Perl::Critic::Config;
use Perl::Critic;

BEGIN {
    use_ok( 'Perl::Critic::Policy::Bangs::ProhibitNumberedNames' );
}

# common P::C testing tools
use lib qw(t/tlib);
use PerlCriticTestUtils qw(pcritique);
PerlCriticTestUtils::block_perlcriticrc();

my $test_policy = 'Bangs::ProhibitNumberedNames';

COMPLETENESS: {
    my $code = <<'END_PERL';
    my $data = 'foo';
    my $data3 = 'bar';
    my @obj4 = qw( Moe Larry Curly );
    my %user5 = ();
    print $1; # This is OK
END_PERL

    is( pcritique($test_policy, \$code), 3);
}

SUBROUTINES: {
    my $code = <<'END_PERL';
    sub utf8 { return; }
END_PERL

    is( pcritique($test_policy, \$code), 0 );
}

DEFAULT_EXCEPTIONS: {
    my $code = <<'END_PERL';

    my $md5;
    my $x11;
    my $UTF8;
END_PERL

    is( pcritique($test_policy, \$code), 0, "Exceptions OK" );
}

REPLACE_EXCEPTIONS: {
    my $code = <<'END_PERL';

    my $md5;
    my $x11;
    my $logan7;
END_PERL

    is( pcritique($test_policy, \$code, {exceptions=>'logan7'}), 2, "Replace exceptions" );
}

ADD_EXCEPTIONS: {
    my $code = <<'END_PERL';

    my $md5;
    my $x11;
    my $logan7;
END_PERL

    is( pcritique($test_policy, \$code, {add_exceptions=>'logan7'}), 0, "Added exceptions" );
}

