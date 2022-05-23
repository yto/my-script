#!/usr/bin/env perl
# -*- coding: utf-8 -*-
use strict;
use warnings;
use List::Util qw(minstr reduce);

my @fns = @ARGV;
my @fhs;
my @current_lines;

# open all files and read first line
for (my $i = 0; $i < @fns; $i++) {
    open($fhs[$i], "<", $fns[$i]) or die "can't open [$fns[$i]]";
    $current_lines[$i] = read_oneline($fhs[$i]);
}

my $current_key = minstr(grep {$_ ne ""} map {$_->{key}} @current_lines) || "";
my %current_cont = ();
while (1) {

    # 辞書順でTOPのキー(""以外の文字列)とそれのあるファイル番号を得る
    my $current_fileno = reduce {$current_lines[$a]{key} lt $current_lines[$b]{key} ? $a : $b} grep {$current_lines[$_]{key} ne ""} 0..$#current_lines;

    last if not defined $current_fileno; # すべて "" ならば終了

    if ($current_key ne $current_lines[$current_fileno]{key}) {
        print join("\t", $current_key, sort keys %current_cont)."\n";
	$current_key = $current_lines[$current_fileno]{key};
	%current_cont = ();
    }

    $current_cont{$_} = 1 for @{$current_lines[$current_fileno]{cont}};

    $current_lines[$current_fileno] = read_oneline($fhs[$current_fileno]);
}

print join("\t", $current_key, sort keys %current_cont)."\n" if $current_key;


# close all files
for (my $i = 0; $i < @fhs; $i++) {
    close($fhs[$i]);
}

# read a line
sub read_oneline {
    my ($fh) = @_;
    return {key => ""} if eof($fh);
    my $line = <$fh>;
    chomp $line;
    my ($key, @c) = split(/\t/, $line);
    return {key => $key, cont => \@c};
}
