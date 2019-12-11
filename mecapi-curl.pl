#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my %opt = ();
GetOptions (\%opt, "response=s", "filter=s", "format=s", "dic=s", "url=s");
$opt{url} ||= "https://maapi.net/apis/mecapi";

while (<>) {
    chomp;
    print mecapi(\%opt, $_);
}

sub mecapi {
    my ($opt_r, $sentence) = @_;
    return "" unless $sentence;
    (my $s = $sentence) =~ s/([^0-9A-Za-z_])/'%'.unpack('H2',$1)/ge;
    my $url = $opt_r->{url}
        ."?response=".($opt_r->{response}||"")
        ."&filter=".($opt_r->{filter}||"")
        ."&format=".($opt_r->{format}||"")
        ."&dic=".($opt_r->{dic}||"")
        ."&sentence=".$s;
    return `curl -s '$url'`;
}
