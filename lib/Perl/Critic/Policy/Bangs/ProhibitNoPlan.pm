package Perl::Critic::Policy::Bangs::ProhibitNoPlan;

use strict;
use warnings;
use Perl::Critic::Utils;
use Perl::Critic::Violation;
use base 'Perl::Critic::Policy';

sub default_severity { return $SEVERITY_HIGHEST }
sub applies_to { return 'PPI::Token::QuoteLike::Words' }

#---------------------------------------------------------------------------

sub new {
    my ($class, %config) = @_;
    my $self = bless {}, $class;
    $self->{_noplanregex} = qr/\bno_plan\b/;

    return $self;
}

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    if ( $elem =~ $self->{'_noplanregex'} ) {

        # Make sure that the previous sibling was Test::More, or return
        my $sib = $elem->sprevious_sibling() || return;
        $sib->isa('PPI::Token::Word') && $sib eq 'Test::More' || return;

        my $desc = q(Test::More with "no_plan" found);
        my $expl = q(Test::More should be given a plan indicating the number of tests run);
        return Perl::Critic::Violation->new( $desc, $expl, $elem, $self->get_severity );
    }
    return;
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Bangs::ProhibitNoPlan

=head1 DESCRIPTION

Test::More should be given a plan indicting the number of tests to be
run. This policy searches for instances of Test::More called with
"no_plan".

=head1 CONSTRUCTOR

This policy looks for qw(no_plan). That can't be changed from the
constructor.

=head1 AUTHOR

Andrew Moore <amoore@mooresystems.com>

=head1 ACKNOWLEDGEMENTS

Adapted from policies by Jeffrey Ryan Thalhammer <thaljef@cpan.org>,
Based on App::Fluff by Andy Lester, "<andy at petdance.com>"

=head1 COPYRIGHT

Copyright (c) 2006 Andrew Moore <amoore@mooresystems.com>.  All rights
reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut
