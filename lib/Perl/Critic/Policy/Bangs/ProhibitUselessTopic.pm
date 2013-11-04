package Perl::Critic::Policy::Bangs::ProhibitUselessTopic;

use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

our $VERSION = '1.11_02';

Readonly::Scalar my $DESC          => q{Useless use of $_};
Readonly::Scalar my $EXPL_REGEX    => q{$_ may be omitted when matching a regular expression};
Readonly::Scalar my $EXPL_FILETEST => q{$_ may be omitted when using a filetest operator};

sub supported_parameters { return () }
sub default_severity     { return $SEVERITY_MEDIUM }
sub default_themes       { return qw( bangs complexity ) }
sub applies_to           { return 'PPI::Token::Magic', 'PPI::Token::Operator' }


my @filetest_operators = qw( -r -w -x -o -R -W -X -O -e -z -s -f -d -l -p -S -b -c -u -g -k -T -B -M -A -C );
my %filetest_operators = map { ($_ => 1) } @filetest_operators;

sub violates {
    my ( $self, $elem, undef ) = @_;

    my $content = $elem->content;
    if ( $content eq '$_' ) {
        # Is there an op following the $_ ?
        my $op_node = $elem->snext_sibling;
        if ( $op_node && $op_node->isa('PPI::Token::Operator') ) {
            # If the op is a regex match, then we have an unnecessary $_ .
            my $op = $op_node->content;
            if ( $op eq '=~' || $op eq '!~' ) {
                return $self->violation( $DESC, $EXPL_REGEX, $elem );
            }
        }
        return;
    }

    # Are we looking at a filetest?
    if ( $filetest_operators{ $content } ) {
        # Is there a $_ following it?
        my $op_node = $elem->snext_sibling;
        if ( $op_node && $op_node->isa('PPI::Token::Magic') ) {
            my $op = $op_node->content;
            if ( $op eq '$_' ) {
                return $self->violation( $DESC, $EXPL_FILETEST, $elem );
            }
        }
        return;
    }

    return;
}


1;

__END__
=head1 NAME

Perl::Critic::Policy::Bangs::ProhibitUselessTopic - Don't use $_ in regexes or filetests.

=head1 AFFILIATION

This Policy is part of the L<Perl::Critic::Bangs> distribution.

=head1 DESCRIPTION

There are a number of places where C<$_>, or "the topic" variable,
is unnecessary.

Match or substitution operations are performed against variables, such as:

    $x =~ /foo/;
    $x =~ s/foo/bar/;
    $x =~ tr/a-mn-z/n-za-m/;

If a variable is not specified, the match is against C<$_>.

    # These are identical.
    /foo/;
    $_ =~ /foo/;

    # These are identical.
    s/foo/bar/;
    $_ =~ s/foo/bar/;

    # These are identical.
    tr/a-mn-z/n-za-m/;
    $_ =~ tr/a-mn-z/n-za-m/;

This applies to negative matching as well.

    # These are identical
    if ( $_ !~ /DEBUG/ ) { ...
    if ( !/DEBUG ) { ...

Including the C<$_ =~> or C<$_ !~> is unnecessary, adds complexity,
and is not idiomatic Perl.

Another place that C<$_> is unnecessary is with a filetest operator.

    # These are identical.
    my $size = -s $_;
    my $size = -s;

    # These are identical.
    if ( -r $_ ) { ...
    if ( -r ) { ...

The exception is after the C<-t> filetest operator, which instead of
defaulting to C<$_> defaults to C<STDIN>.

=head1 CONFIGURATION

This Policy is not configurable except for the standard options.

=head1 TO DO

I hope to expand this to other places that C<$_> is not needed, like in
a call to C<split> or a million other functions where C<$_> is assumed.

=head1 AUTHOR

Andy Lester <andy@petdance.com>

=head1 COPYRIGHT

Copyright (c) 2013 Andy Lester <andy@petdance.com>

This library is free software; you can redistribute it and/or modify it
under the terms of the Artistic License 2.0.

=cut
