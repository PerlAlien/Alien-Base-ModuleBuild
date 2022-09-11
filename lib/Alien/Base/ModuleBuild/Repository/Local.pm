package Alien::Base::ModuleBuild::Repository::Local;

use strict;
use warnings;
use Carp;
use File::chdir;
use File::Copy qw/copy/;
use Path::Tiny qw( path );
use parent 'Alien::Base::ModuleBuild::Repository';

# ABSTRACT: Local file repository handler
# VERSION

sub is_network_fetch { 0 }
sub is_secure_fetch  { 1 }

sub new {
  my $class = shift;

  my $self = $class->SUPER::new(@_);

  # make location absolute
  local $CWD = $self->location;
  $self->location("$CWD");

  return $self;
}

sub list_files {
  my $self = shift;

  local $CWD = $self->location;

  opendir( my $dh, $CWD);
  my @files =
    grep { ! /^\./ }
    readdir $dh;

  return @files;
}

sub get_file  {
  my $self = shift;
  my $file = shift || croak "Must specify file to copy";

  my $full_file = do {
    local $CWD = $self->location;
    croak "Cannot find file: $file" unless -e $file;
    path($file)->absolute->stringify;
  };

  copy $full_file, $CWD;

  return $file;
}

1;

