package Perl::Critic::Policy::Bangs::ProhibitVagueNames;

use strict;
use warnings;
use Perl::Critic::Utils;
use Perl::Critic::Violation;
use base 'Perl::Critic::Policy';

sub default_severity { return $SEVERITY_MEDIUM }
sub applies_to { return 'PPI::Token::Symbol' }
our @DEFAULT_VAGUE_NAMES = qw(
    data
    info
    var
    obj
    object
    tmp
    temp
);

=head1 NAME

Perl::Critic::Policy::Bangs::ProhibitVagueNames - Prohibit vague variable names

=head1 DESCRIPTION

Variables should have descriptive names. Names like C<$data> and
C<$info> are completely vague.

   my $data = shift;      # not OK.
   my $userinfo = shift   # OK

See
http://www.oreillynet.com/onlamp/blog/2004/03/the_worlds_two_worst_variable.html
for more of my ranting on this.

=head1 CONSTRUCTOR

To replace the list of vague names, pass them into the constructor
as a key-value pair where the key is "names" and the value is a
whitespace delimited series of names. Or specify them in your
F<.perlcriticrc> file like this:

    [Bangs::ProhibitVagueNames]
    names = data count line next

To add names to the list, pass them into the constructor as
"add_names", or specify them in your F<.perlcriticrc> file like
this:

    [Bangs::ProhibitVagueNames]
    add_names = foo bar bat

=cut

sub new {
    my $class = shift;
    my %config = @_;

    my $self = bless {}, $class;

    # Set list of vague names from configuration, if defined.
    $self->{_names} =
        defined $config{names}
            ? [ split m{ \s+ }mx, $config{names} ]
            : [ @DEFAULT_VAGUE_NAMES ];

    # Add to list of vague names
    if ( defined $config{add_names} ) {
        push( @{$self->{_names}}, split m{ \s+ }mx, $config{add_names} );
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

    foreach my $naughty ( @{$self->{'_names'}} ) {
        if ( $basename eq $naughty ) {
            my $sev = $self->get_severity();
            my $desc = qq(Variable named "$canonical");
            my $expl = 'Variable names should be specific, not vague';
            return Perl::Critic::Violation->new( $desc, $expl, $elem, $sev );
        }
    }
    return;
}

1;

=head1 AUTHOR

Andy Lester C<< <andy at petdance.com> >> from code by 
Andrew Moore C<< <amoore at mooresystems.com> >>.

=head1 ACKNOWLEDGEMENTS

Adapted from policies by Jeffrey Ryan Thalhammer <thaljef@cpan.org>,
Based on App::Fluff by Andy Lester, "<andy at petdance.com>"

=head1 COPYRIGHT

Copyright (c) 2006 Andy Lester.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut
