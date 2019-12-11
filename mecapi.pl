#!/usr/bin/perl
# MECAPI CLI (perl)
use strict;
use warnings;
use LWP::Simple;
use URI::Escape;
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
    my $url = $opt_r->{url}
        ."?response=".($opt_r->{response}||"")
        ."&filter=".($opt_r->{filter}||"")
        ."&format=".($opt_r->{format}||"")
        ."&dic=".($opt_r->{dic}||"")
        ."&sentence=".URI::Escape::uri_escape($sentence);
    return get($url);
}
