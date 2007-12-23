package Perl::Critic::Policy::Bangs::ProhibitNumberedNames;

use strict;
use warnings;
use Perl::Critic::Utils;
use Perl::Critic::Violation;
use base 'Perl::Critic::Policy';

our $VERSION = '0.23';

sub supported_parameters { return ( qw( exceptions ) ) }
sub default_severity { return $SEVERITY_MEDIUM }
sub applies_to { return 'PPI::Token::Symbol' }

our @DEFAULT_EXCEPTIONS = qw(
    md5
    x11
    utf8
);

=head1 NAME

Perl::Critic::Policy::Bangs::ProhibitNumberedNames - Prohibit variables differentiated by trailing numbers

=head1 DESCRIPTION

Similar variables should be obviously different.  A lazy way to
differentiate similar variables is by tacking a number at the end.

    my $total = $price * $quantity;
    my $total2 = $total + ($total * $taxrate);
    my $total3 = $total2 + $shipping;

The difference between C<$total> and C<$total3> is not described
by the silly "3" at the end.  Instead, it should be:

    my $merch_total = $price * $quantity;
    my $subtotal = $merch_total + ($merch_total * $taxrate);
    my $grand_total = $subtotal + $shipping;

See
http://www.oreillynet.com/onlamp/blog/2004/03/the_worlds_two_worst_variable.html
for more of my ranting on this.

=head1 CONSTRUCTOR

This policy starts with a list of numbered names that are legitimate
to have ending with a number:

    md5, x11, utf8

To replace the list of exceptions, pass them into the constructor
as a key-value pair where the key is "exceptions" and the value is
a whitespace delimited series of names. Or specify them in your
F<.perlcriticrc> file like this:

    [Bangs::ProhibitNumberedNames]
    exceptions = logan7 babylon5

To add exceptions to the list, pass them into the constructor as
"add_exceptions", or specify them in your F<.perlcriticrc> file
like this:

    [Bangs::ProhibitVagueNames]
    add_names = adam12 route66

=cut

sub new {
    my $class = shift;
    my %config = @_;

    my $self = bless {}, $class;
    $self->{_exceptions} = [ @DEFAULT_EXCEPTIONS ];

    # Set list of exceptions from configuration, if defined.
    if ( defined $config{exceptions} ) {
        $self->{_exceptions} = [ split m{ \s+ }mx, $config{exceptions} ];

    # Add to list of exceptions
    } elsif ( defined $config{add_exceptions} ) {
        push( @{$self->{_exceptions}}, split m{ \s+ }mx, $config{add_exceptions} );
    }

    return $self;
}


sub violates {
    my ( $self, $elem, $doc ) = @_;

    # make $basename be the variable name with no sigils or namespaces.
    my $canonical = $elem->canonical();
    my $basename = $canonical;
    $basename =~ s/.*:://;
    $basename =~ s/^[\$@%]//;

    if ( $basename =~ /\D+\d+$/ ) {
        $basename =~ s/.+_(.+)/$1/; # handle things like "partial_md5"
        $basename = lc $basename;
        for my $exception ( @{$self->{_exceptions}} ) {
            return if $exception eq $basename;
        }

        my $sev = $self->get_severity();
        my $desc = qq(Variable named "$canonical");
        my $expl = 'Variable names should not be differentiated only by digits';
        return Perl::Critic::Violation->new( $desc, $expl, $elem, $sev );
    }
    return;
}

1;

=head1 AUTHOR

Andy Lester C<< <andy at petdance.com> >>

=head1 COPYRIGHT

Copyright (c) 2006 Andy Lester.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut
