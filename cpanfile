# Validate with cpanfile-dump
# https://metacpan.org/release/Module-CPANfile
# https://metacpan.org/pod/distribution/Module-CPANfile/lib/cpanfile.pod

requires 'List::SomeUtils'               => 0;
requires 'Perl::Critic'                  => 1.122;
requires 'Perl::Critic::Policy'          => 0;
requires 'Perl::Critic::PolicyFactory'   => 0;
requires 'Perl::Critic::PolicyParameter' => 0;
requires 'Perl::Critic::TestUtils'       => 0;
requires 'Perl::Critic::UserProfile'     => 0;
requires 'Perl::Critic::Utils'           => 0;
requires 'Perl::Critic::Violation'       => 0;
requires 'PPI::Cache'                    => 0;
requires 'PPI::Document'                 => 0;
requires 'Readonly'                      => 0;

on 'configure' => sub {
    requires 'ExtUtils::MakeMaker' => '6.46';
};

on 'build' => sub {
    requires 'ExtUtils::MakeMaker' => '6.46';
};

on 'test' => sub {
    requires 'Test::More'         => '0.96'; # For subtest()
    requires 'Test::Perl::Critic' => 1.01;
};

# vi:et:sw=4 ts=4 ft=perl
