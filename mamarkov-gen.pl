#!/usr/bin/env perl
use strict;
use warnings;

my %next_words;
while (<>) {
    chomp;
    my ($word, @words) = split(/\t/, $_);
    $next_words{$word} = \@words;
}

my $curent_word = "__BOS__";
for (my $i = 0; $i < 200; $i++) {
    my $words_r = $next_words{$curent_word};
    $curent_word = $words_r->[rand(@$words_r)];
    last if $curent_word eq "__EOS__";
    print $curent_word;
}
print "\n";
