#!/usr/bin/env perl
use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use utf8;
use open ':utf8';
binmode STDIN, ":utf8";

my $appid = "THISISAPEN"; # 自分で取得した AppId を使いましょう
my $url = "https://jlp.yahooapis.jp/MAService/V2/parse";
my $params = {
  "jsonrpc" => "2.0",
  "method" => "jlp.maservice.parse",
};

my $ua = LWP::UserAgent->new;
$ua->default_header('Content-Type' => 'application/json');
$ua->default_header('User-Agent' => 'Yahoo AppID: '.$appid);

while (<>) {
    chomp;
    $params->{id} = $.;
    $params->{params}{q} = $_;
    my $response = $ua->post($url, content => JSON::encode_json($params));
    if ($response->is_success) {
	print $response->content."\n";
    } else {
	die $response->status_line;
    }
}
