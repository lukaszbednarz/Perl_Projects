#! perl
use strict;
use warnings;
use warnings qw(once);

# create cards set (no jokers)
my @figures = qw(1 2 3 4 5 6 7 8 9 10 W Q K A);
my @colors  = qw(S H D C);

my @CARD_SET;

foreach my $fig (@figures) {
    # here creating anon hash with two keys repr
    # color an figure instead of string like 1S
    # might be useful later when calculating points
    my @set = map { {figure => $fig, color => $_, card => $fig.$_}} @colors;
    push(@CARD_SET, @set);
}

# piles for players
my (@p1_pile, @p2_pile, @p1_stack, @p2_stack, @p1_acc, @p2_acc);

# deal the cards (dealing all set)

# generating set of random numbers from 0 .. length of @CARD_SET
foreach (@CARD_SET) { $_->{rand} = rand()};

# shuffling the cards
my @shuffled_set = sort {$a->{rand} <=> $b->{rand}} @CARD_SET;

#now dealing to initial sets
@p1_pile = @shuffled_set[0..int((@CARD_SET)/2-1)];
@p2_pile = @shuffled_set[(int((@CARD_SET)/2))..(int(@CARD_SET/2) +int(@CARD_SET/2))];

#playing

while (@p1_pile || @p2_pile) {
    
    # player 1 plays
    unshift(@p1_stack, shift(@p1_pile));
    
    # comparing cards on staks
    if (@p1_stack || @p2_stack && ($p1_stack[0]->{card} eq $p2_stack[0]->{card})){
        unshift(@p1_acc, @p1_stack, @p2_stack);        
    }
    
    # player 2 plays
    unshift(@p2_stack, shift(@p2_pile));
        # comparing cards on staks
    if (@p1_stack || @p2_stack && ($p1_stack[0]->{card} eq $p2_stack[0]->{card})){
        unshift(@p2_acc, @p1_stack, @p2_stack);        
    }
         
}

1;
