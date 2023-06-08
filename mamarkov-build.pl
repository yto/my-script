#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open ':utf8';
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my %next_words;
while (<>) {
    chomp;
    my $rr = yapima2($_);
    my @words = ("__BOS__", @$rr, "__EOS__");
    for (my $i = 0; $i < @words - 1; $i++) {
	push @{$next_words{$words[$i]}}, $words[$i + 1];
    }
}

foreach my $w (sort keys %next_words) {
    print join("\t", $w, @{$next_words{$w}})."\n";
}

sub yapima2 {
    use LWP::UserAgent;
    use JSON;
    my ($sent) = @_;
    my $appid = "THISISAPEN"; # 自分で取得した AppID を使いましょう
    my $url = "https://jlp.yahooapis.jp/MAService/V2/parse";
    my $params = {
	"id" => "12345678",
	"jsonrpc" => "2.0",
	"method" => "jlp.maservice.parse",
	"params" => { "q" => $sent }
    };
    my $ua = LWP::UserAgent->new;
    $ua->default_header('Content-Type' => 'application/json');
    $ua->default_header('User-Agent' => 'Yahoo AppID: '.$appid);
    my $response = $ua->post($url, content => JSON::encode_json($params));
    if ($response->is_success) {
	my $j = JSON::decode_json($response->content);
	return [map {$_->[0]} @{$j->{result}{tokens}}];
    } else {
        die $response->status_line;
    }
}
