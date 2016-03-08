#!/usr/bin/perl -w
use strict;
use warnings;
use warnings qw(once);

package Worker;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    
    $self->{belt} = shift;
    $self->{pos} = shift;
    $self->{set} = shift;
    $self->{prod} = shift;
    
    $self->{elements} = [];
    $self->{counter} = 0;
    $self->{hasproduct} = 0;
                
    return $self;   
}

sub Work {
    my $self = shift;
    my $elem = \$self->{belt}->[$self->{pos}];
    print "\t\tWorker on pos ".($self->{pos})." is working.\n";
    print "\t\tElement on the belt is $$elem\n" if $$elem;
    print "\t\tElements in the store are ".join(' and ', @{$self->{elements}})."\n" if @{$self->{elements}};
    if ($self->{hasproduct}) {
        # place product on the belt
        if (!$$elem) {
            ${$elem} = $self->{prod};
            $self->{elements} = [];
            $self->{hasproduct} = 0;
            print "\t\tputting product on the belt\n";
        }
        else {
            print "\t\twaiting for empty slot on the belt\n";
        }
    }
    elsif ($self->{counter} > 0) {
        # decrease wait time
        $self->{counter}--
        ;
        # if assembly time has passed
        $self->{hasproduct} = 1 if $self->{counter} == 0;
        print "\t\tassembling product\n";
    }
    elsif ($$elem && $self->_CheckElement()) {
        # adding element to the set
        print "\t\tadding element ".$$elem." to the set\n";
        push(@{$self->{elements}}, $$elem);
        # removing element from the belt
        ${$elem} = undef;
        
        # checking whether all necessary components are already collected
        if ($self->_SetComplete()) {
            # setting wait to 4
            $self->{counter} = 4;
            print "\t\tcompleted set waiting\n";
        }
        # returning 1 to prevent other worker to put product on the belt
        return 1;
    }
    
    return 0;       
}
    
# this function checks whether worker already has
# the same element as the one on the belt
# it also checks whether the element on the belt
# is not a product
sub _CheckElement {
    my $self = shift;
    my $elem = \$self->{belt}->[$self->{pos}];
    
    return 0 if $$elem eq $self->{prod};

    # return 0 if already has the same element
    foreach (@{$self->{elements}}) {
        return 0 if ($$elem eq $_ );
    }
    # return 1 if hasn't got this element
    return 1;    
}

# this function checks whether set is complete for assembly
sub _SetComplete {
    my $self = shift;
    
    if (@{$self->{elements}} == @{$self->{set}}) {
       return 1; 
    }
    else {
        return 0;
    }
        
}
        
        
1;


