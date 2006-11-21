package Perl::Critic::Policy::Bangs::ProhibitCommentedOutCode;

use strict;
use warnings;
use Perl::Critic::Utils;
use Perl::Critic::Violation;
use base 'Perl::Critic::Policy';

sub default_severity { return $SEVERITY_LOW }
sub applies_to { return 'PPI::Token::Comment' }


sub new {
    my ($class, %config) = @_;
    my $self = bless {}, $class;
    $self->{_commentedcoderegex} = qr/\$[A-Za-z_].*=/;

    # Set commentedcode regex from configuration, if defined.
    if ( defined $config{commentedcoderegex} ) {
        $self->{_commentedcoderegex} = $config{commentedcoderegex};
    }

    return $self;
}

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;
    my @viols = ();

    my $nodes = $doc->find( 'PPI::Token::Comment' );

    if ( $elem =~ $self->{_commentedcoderegex} ) {
        my $sev  = $self->get_severity();
        my $desc = q(Code found in comment);
        my $expl = q(Commented-out code found can be confusing);
        return Perl::Critic::Violation->new( $desc, $expl, $elem, $sev );
    }
    return;
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Bangs::ProhibitCommentedOutCode

=head1 DESCRIPTION

Commented-out code is often a sign of a place where the developer
is unsure of how the code should be.  If historical information
about the code is important, then keep it in your version control
system.

=head1 CONSTRUCTOR

By default, this policy attempts to look for commented out code. It
does that by looking for variable assignments in code as represented
by the regular expression: qr/\$[A-Za-z_].*=/ found in a comment. To
change that regex, pass one into the constructor as a key-value pair,
where the key is 'coderegex' and the value is a qr() constructed
regex. Or specify them in your F<.perlcriticrc> file
like this:

  [Bangs::ProhibitCommentedOutCode]
  coderegex = qr(\$[A-Za-z_].*=/)

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
