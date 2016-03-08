#!/usr/bin/perl -w
     
use strict;
use warnings;
use warnings qw(once);

package ConveyorBelt;
use WorkerPair;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
       
    $self->{length} = shift;
    $self->{set} = shift;
    $self->{prod} = shift;
    
    $self->_InitBelt();
    
    return $self;
}
    
sub _InitBelt {
    my $self = shift;
    my $length = $self->{length};
    my @belt;
    my @workers;
    
    for(my $i=0; $i<$length; $i++) {
        # adding worker pair 
        push(@workers, WorkerPair->new(\@belt, $i, $self->{set}, $self->{prod}));
        # initializing belt space;
        push(@belt, undef);
        
    }
    $self->{belt} = \@belt;
    $self->{workers} = \@workers;
}

# this function will add random element to the belt    
sub _AddRandomElem {
    my $self = shift;
    my $set = $self->{set};
    # getting random index to element array
    # adding 1 to account for index out of array
    # length which will give undef representing
    # empty belt
    my $ind = int(rand(@{$set} + 1));
    
    my $elem = $set->[$ind];
    
    unshift(@{$self->{belt}}, $elem);
    
    return 0;
}

sub Work {
    my $self = shift;
    # putting element on belt
    $self->_AddRandomElem();
    
    # processing
    foreach (@{$self->{workers}}) {
        print "Worker pair working\n";
        $_->Work();
    }
    
    # removing last element and counting
    my $elem = pop(@{$self->{belt}});
    # updating count of elements
    $self->{count}->{$elem}++ if $elem;
    $self->{count}->{'EMPTY'}++ if !$elem;
    print "Element $elem is leaving the belt.\n" if $elem;
    print "Empty slot is leaving the belt.\n" if !$elem;
    return 0;
    
}

1;

