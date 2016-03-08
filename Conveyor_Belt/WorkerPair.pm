#!/usr/bin/perl -w
use strict;
use warnings;
use warnings qw(once);


package WorkerPair;

use Worker;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    
    $self->{worker1} = Worker->new(@_);
    $self->{worker2} = Worker->new(@_);
       
    return $self;   
}
    
sub Work {
    my $self = shift;
    print "\tWorker1 working \n";
    my $ret = $self->{worker1}->Work();
    
    # second worker working if first hasn't taken something from the belt.
    if (!$ret) {
        print "\tWorker2 working \n";
        $self->{worker2}->Work();
    }
    return 0;
}
1;