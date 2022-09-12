package Alien::Base::ModuleBuild::Utils;

use strict;
use warnings;
use Text::Balanced qw/extract_bracketed extract_delimited extract_multiple/;
use parent 'Exporter';

# ABSTRACT: Private utilities
# VERSION

our @EXPORT_OK = qw/find_anchor_targets pattern_has_capture_groups/;

sub find_anchor_targets {
  my $html = shift;

  my @tags = extract_multiple(
    $html,
    [ sub { extract_bracketed($_[0], '<>') } ],
    undef, 1
  );

  @tags =
    map { extract_href($_) }  # find related href=
    grep { /^<a/i }            # only anchor begin tags
    @tags;

  return @tags;
}

sub extract_href {
  my $tag = shift;
  if($tag =~ /href=(?='|")/gci) {
    my $text = scalar extract_delimited( $tag, q{'"} );
    my $delim = substr $text, 0, 1;
    $text =~ s/^$delim//;
    $text =~ s/$delim$//;
    return $text;
  } elsif ($tag =~ /href=(.*?)(?:\s|\n|>)/i) {
    return $1;
  } else {
    return ();
  }
}

sub pattern_has_capture_groups {
  my $re = shift;
  "" =~ /|$re/;
  return $#+;
}


1;

=head1 SEE ALSO

=over 4

=item L<Alien>

=item L<Alien::Base>

=back

=cut
