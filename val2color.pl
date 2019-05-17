#!/usr/bin/env perl
use strict;
use warnings;


sub val2color {
    my ($val) = @_;
    my $red = int($val * 0xff);
    my $green = int($val * 0x8f);
    my $blue = 0xff - int($val * 0x0f);
    my $color = sprintf("%02x%02x%02x", $red, $green, $blue);
    return $color;
}

sub val2gradcolor {
    my ($from, $to, $val) = @_;
    my @from_rgb = map {hex($_)} $from =~ /^\#?(..)(..)(..)$/;
    my @to_rgb = map {hex($_)} $to =~ /^\#?(..)(..)(..)$/;

    my @res_rgb;
    foreach my $i (0, 1, 2) {
	my $w = $to_rgb[$i] - $from_rgb[$i];
	$res_rgb[$i] = int($val * $w + $from_rgb[$i]);
    }
    my $color = sprintf("%02x%02x%02x", @res_rgb);
    return $color;
#    print "my ($fr, $fg, $fb),  ($tr, $tg, $tb)\n";
}

my $MAX = 17;
for (my $i = 0; $i <= $MAX; $i++) {
    my $val = $i / $MAX;
#    my $color = val2color($val);
    my $color = val2gradcolor("00ff00", "ff00ff", $val);
    # print "$i $val $color\n";
    print qq(
<div style="padding-left:1em;background-color:#$color;color:#808080">
color=#$color, value=$val
</div>
);
} 
