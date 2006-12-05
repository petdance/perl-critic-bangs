package Perl::Critic::Policy::Bangs::ProhibitFlagComments;

use strict;
use warnings;
use Perl::Critic::Utils;
use Perl::Critic::Violation;
use base 'Perl::Critic::Policy';

sub default_severity { return $SEVERITY_LOW }
sub applies_to { return 'PPI::Token::Comment' }

#---------------------------------------------------------------------------

sub new {
    my ($class, %config) = @_;
    my $self = bless {}, $class;
    $self->{_keywords} = [ qw( XXX FIXME TODO ) ];

    #Set configuration, if defined.
    if ( defined $config{keywords} ) {
        $self->{_keywords} = [ split m{ \s+ }mx, $config{keywords} ];
    }

    return $self;
}

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    foreach my $keyword ( @{$self->{'_keywords'}} ) {
        if ( index( $elem->content(), $keyword ) != -1 ) {
            my $desc = qq(Flag comment '$keyword' found);
            my $expl = qq(Comments containing "$keyword" typically indicate bugs or problems that the developer knows exist);
            return Perl::Critic::Violation->new( $desc, $expl, $elem, $self->get_severity );
        }
    }
    return;
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Bangs::ProhibitFlagComments

=head1 DESCRIPTION

Programmers often leave comments intended to "flag" themselves to
problems later. This policy looks for comments containing 'XXX',
'TODO', or 'FIXME'.

=head1 CONSTRUCTOR

By default, this policy only looks for 'XXX', 'TODO', or 'FIXME' in
comments. To add words, pass them into the constructor as a key-value
pair, where the key is 'keywords' and the value is a whitespace
delimited series of keywords.  Or specify them in your
F<.perlcriticrc> file like this:

  [Bangs::ProhibitFlagComments]
  keywords = XXX TODO FIXME BUG REVIEW

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
