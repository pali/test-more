package Test::Builder::Result;
use strict;
use warnings;

use Carp qw/confess/;
use Scalar::Util qw/blessed/;

use Test::Builder::Util qw/accessors new/;

accessors(qw/caller pid depth in_todo source anointed provider constructed/);

sub init {
    my $self = shift;
    my %params = @_;

    $self->constructed([caller(1)]);
    $self->pid($$)             unless $params{pid};
    $self->caller([caller(2)]) unless $params{caller};
}

sub type {
    my $self = shift;
    my $class = blessed($self);
    if ($class && $class =~ m/^.*::([^:]+)$/) {
        return lc($1);
    }

    confess "Could not determine result type for $self";
}

sub indent {
    my $self = shift;
    return '' unless $self->depth;
    return '    ' x $self->depth;
}

1;
