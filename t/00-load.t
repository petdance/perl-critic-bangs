#!perl -T

use warnings;
use strict;

use Test::More tests => 1;
use Perl::Critic;

BEGIN {
    use_ok( 'Perl::Critic::Bangs' );
}

diag( "Testing Perl::Critic::Bangs $Perl::Critic::Bangs::VERSION, Perl $], $^X, Perl::Critic $Perl::Critic::VERSION" );
