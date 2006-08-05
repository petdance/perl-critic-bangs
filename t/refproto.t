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
# these should fail
my $name = ref $proto || $proto;
# these should not
my $notname = ref $proto || $name;
# my $name = ref $proto || $proto;
END_PERL

my $policy = 'Bangs::ProhibitRefProtoOrProto';
is( pcritique($policy, \$code), 1, $policy);


