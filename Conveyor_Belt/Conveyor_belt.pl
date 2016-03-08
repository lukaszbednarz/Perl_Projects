#!/usr/bin/perl -w
#########################################################
# This script is simulating factory conveyor belt
# The following assumptions were made in simulation:
#   1. The length of the belt is the same as number of
#      worker slots having two workers on each side of
#      the belt.
#   2. Workers pick the item for assembly from the belt
#      based on individual decision, based on what item
#      is on the belt in given timeslot and workers do
#      not have knowledge what item will be arriving next.
#   3. Because of 1. and 2. there is no optimisation
#      on deciding which worker shoud pick component
#      on the belt first. Such optimisation could
#      potentialy increase the number of ready products
#      leaving the belt and decrease the number of
#      untouched elements leaving the production line.
#########################################################
use strict;
use warnings;
use warnings qw(once);

use ConveyorBelt;

my $length = 3;
my $cycles = 100;
my $set = ['A', 'B'];
my $prod = 'P';

my $belt = ConveyorBelt->new($length, $set, $prod);

# running the belt for no of cycles + $length of the belt to fill it
for (my $i=0; $i<$cycles + $length; $i++) {
    print "cycle $i\n";
    $belt->Work();
}

foreach (keys %{$belt->{count}}) {
    if ($_ eq $prod) {
        print "Number of ready product ".$_." : ".($belt->{count}->{$_})."\n";
    }
    else {
        print "Number of elements ".$_." left : ".($belt->{count}->{$_})."\n";
    }
}


