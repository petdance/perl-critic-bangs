package Perl::Critic::Policy::Bangs::ProhibitFlagComments;

use strict;
use warnings;
use Perl::Critic::Utils;
use base 'Perl::Critic::Policy';

our $VERSION = '1.12';

#----------------------------------------------------------------------------

sub supported_parameters {
    return (
        {
            name           => 'keywords',
            description    => 'Words to prohibit in comments.',
            behavior       => 'string list',
            default_string => 'XXX FIXME TODO',
        },
        {
            name           => 'exempt_pod',
            description    => 'Flag to enable exemption of policy evaluation in POD context.',
            default_string => '0',
            behavior       => 'boolean',
        },
    );
}

sub default_severity     { return $SEVERITY_LOW                             }
sub default_themes       { return qw( bangs maintenance )                   }
sub applies_to           { return qw( PPI::Token::Comment PPI::Token::Pod ) }

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    #We are in POD context, so we consider the exempt POD parameter
    if (ref $elem eq 'PPI::Token::Pod' and $self->{_exempt_pod}) {
        return;
    }

    foreach my $keyword ( keys %{ $self->{'_keywords'} } ) {
        if ( index( $elem->content(), $keyword ) != -1 ) { ## no critic (ProhibitMagicNumbers)
            my $desc = qq(Flag comment '$keyword' found);
            my $expl = qq(Comments containing "$keyword" typically indicate bugs or problems that the developer knows exist);
            return $self->violation( $desc, $expl, $elem );
        }
    }
    return;
}

1;

__END__
=for stopwords FIXME

=head1 NAME

Perl::Critic::Policy::Bangs::ProhibitFlagComments - Don't use XXX, TODO, or FIXME.

=head1 AFFILIATION

This Policy is part of the L<Perl::Critic::Bangs> distribution.

=head1 DESCRIPTION

Programmers often leave comments intended to "flag" themselves to
problems later. This policy looks for comments containing 'XXX',
'TODO', or 'FIXME'.

=head1 CONFIGURATION

By default, this policy only looks for 'XXX', 'TODO', or 'FIXME' in
comments. You can override this by specifying a value for C<keywords>
in your F<.perlcriticrc> file like this:

  [Bangs::ProhibitFlagComments]
  keywords = XXX TODO FIXME BUG REVIEW

In addition you can enable exemption of examination of POD sections
using the exempt_pod flag.

  [Bangs::ProhibitFlagComments]
  exempt_pod = 1

POD is not exempted by default

=head1 AUTHOR

Andrew Moore <amoore@mooresystems.com>

=head1 ACKNOWLEDGMENTS

Adapted from policies by Jeffrey Ryan Thalhammer <thaljef@cpan.org>,
Based on App::Fluff by Andy Lester, "<andy at petdance.com>"

=head1 COPYRIGHT

Copyright (c) 2006-2013 Andy Lester <andy@petdance.com> and Andrew
Moore <amoore@mooresystems.com>.

This library is free software; you can redistribute it and/or modify
it under the terms of the Artistic License 2.0.

=cut
