#!/usr/bin/env perl

use strict;
use warnings;

use Env qw($TMUX);
#use Data::Dump qw(dump);

package Tmux;

sub new
{
   bless {
      hist => []
   }
}

sub push_hist {
   my ($self, $win) = @_;

   @{ $self->{hist} } = grep { $_ != $win } @{ $self->{hist} };

   unshift @{ $self->{hist} }, $win;
}

#  <1> <2> <3> | choose 2
#  <2> <1> <3> | choose 1
#  <1> <2> <3> | choose 3
#  <3> <2> <1> | back!
#  

sub backward {
   my $self = shift;

   # Operation not possible
   return -1 if scalar @{ $self->{hist} } < 1;

   unshift @{ $self->{hist} }, pop @{ $self->{hist} };

   return $self->{hist}->[0];
}

sub forward {
   my $self = shift;

   # Operation not possible
   return -1 if scalar @{ $self->{hist} } < 1;

   push @{ $self->{hist} }, shift @{ $self->{hist} };

   return $self->{hist}->[0];
}

sub list_windows {
   return split("\n", `tmux list-windows -F '#I'`);
}

sub select_window {
   my ($self, $win) = @_;

   # nothing changed.
   return if $win == -1;

   system('tmux', 'select-window', '-t', $win);

   $self->push_hist($win);
}
1;

sub window_approx($@) {
   my $win = shift;
   my @windows = sort {$a <=> $b} @_;

   return -1 if ($#windows == -1);
   return $windows[0] if ($#windows == 0);

   if ($win <= $windows[0]) {
      return $windows[0];
   }
   elsif ($win >= $windows[$#windows]) {
      return $windows[$#windows];
   }

   my $approx_left;

   for (@windows) {
      # wanted window is available
      return $win if ($win == $_);

      if ($_ > $win) {
         # check if right or left window is closed to the wanted window
         if ($win - $approx_left < $_ - $win) {
            return $approx_left;
         }
         else {
            return $_;
         }
      }

      $approx_left = $_;
   }

   return -1;
}

my $tmux = Tmux->new();

sub tmux_approx_select_window {
   my $win = shift;
   my @windows = $tmux->list_windows();

   $tmux->select_window( window_approx($win, @windows) );
}

sub tmux_history_forward {
   my $win = $tmux->forward();
   my @windows = $tmux->list_windows();

   $tmux->select_window( window_approx($win, @windows) );
}

sub tmux_history_backward {
   my $win = $tmux->backward();
   my @windows = $tmux->list_windows();

   $tmux->select_window( window_approx($win, @windows) );
}

sub tmux_apostrophe {
   my $o = `tmux display-m -p '#W'`;

   if ($o =~ /mcabber/) {
      system('tmux', 'send-keys', "’");
   } else {
      system('tmux', 'send-keys', "'");
   }
}

die "Usage: $0 <FIFO>\n" if ($#ARGV != 0);

fork and exit;

if (! -e $ARGV[0]) {
   system('mkfifo', $ARGV[0]);
}

my %dispatch = (
   'select-window'    => \&tmux_approx_select_window,
   'history-forward'  => \&tmux_history_forward,
   'history-backward' => \&tmux_history_backward,
   'test'             => \&tmux_apostrophe
);

while()
{
   open(my $fh, '<', $ARGV[0]);
   my $line = readline($fh) || next;
   chomp($line);
   $line || next;

   if (fork) {
      my ($cmd, @args) = split(' ', $line);

      unless (exists $dispatch{$cmd}) {
         exec('tmux', 'display-m', "tmux-daemon: no such command: $cmd") or die;
      }

      $dispatch{$cmd}->(@args);
      exit;
   }

   close($fh);
}
