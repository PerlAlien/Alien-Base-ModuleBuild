package Alien::Base::ModuleBuild::Repository::HTTP;

use strict;
use warnings;

our @ISA = 'Alien::Base::ModuleBuild::Repository';

use Carp;

sub connection {

  my $self = shift;

  return $self->{connection}
    if $self->{connection};

  # allow easy use of HTTP::Tiny subclass
  $self->{connection_class} ||= 'HTTP::Tiny';

  my $http = $self->{connection_class}->new();

  $self->{connection} = $http;

  return $http;

}

sub get_file {
  my $self = shift;
  my $file = shift || croak "Must specify file to download";

  my $host = $self->{host};
  my $from = $self->{folder};

  my $http = $self->connection();

  my $response = HTTP::Tiny->new->mirror( $host . $from . $file, $file );
  croak "Download failed: " . $response->{reason} unless $response->{success};

  return 1;
}

sub list_files {
  croak "HTTP list_files Not Implemented";
}

1;
