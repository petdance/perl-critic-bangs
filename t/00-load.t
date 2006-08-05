#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'Perl::Critic::Bangs' );
    use_ok( 'Perl::Critic::Policy::Bangs::ProhibitVagueNames' );
    #use_ok( 'Perl::Critic::Policy::Bangs::ProhibitNumberedNames' );
}

diag( "Testing Perl::Critic::Bangs $Perl::Critic::Bangs::VERSION, Perl $], $^X" );
