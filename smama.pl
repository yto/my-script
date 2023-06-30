#!/usr/bin/env perl
# echo 今日は良い天気です。エロいピエロです。 | ./smama.pl smama-dic.tsv
use strict;
use warnings;
use utf8;
use open ':utf8';
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

### (A1) 辞書ファイルを読み込む
my $dic_filename = shift @ARGV;
my $dic = read_dic($dic_filename);

### (A2) エントリ文字列を繋げて正規表現用のパターン文字列を作る
my $pat = join("|", map {"\Q$_\E"} sort {length($b) <=> length($a)} keys %$dic);

while (<>) {
    chomp;
    my $sentence = $_;

    ### (B1) 文を形態素に分割
    my $tokens = wakati($sentence);
    print "$sentence\n".join("", map {"[$_]"} @$tokens)."\n\n";

    ### (B2) 形態素区切り位置を保存
    my $i = 0;
    my %kugiri = map {($i += length($_)) => 1} "", @$tokens;    
    print "$sentence\n".join(" ", sort {$a <=> $b} keys %kugiri)."\n\n";

    ### (B3) 辞書にマッチさせる
    # 正規表現でマッチしたエントリ文字列のマッチ開始・終了位置の両方が
    # 形態素区切り位置に一致していればマッチ成功
    while ($sentence =~ /($pat)/g) {
	my ($from, $to) = ($-[0], $-[0] + length($1));
	if ($kugiri{$from} and $kugiri{$to}) {
	    print "MATCH! $from-$to [$1][$dic->{$1}]\n";
	}
    }
}

### 辞書ファイルを読み込む
# FORMAT: ^エントリ文字列\tマッチした時に表示する情報
sub read_dic {
    my ($fn) = @_;
    my %dict;
    open(my $fh, "<", $fn) or die;
    while (<$fh>) {
	chomp;
	my ($key, $cont) = split(/\t/, $_, 2);
	$dict{$key} = $cont;
    }
    close($fh);
    return \%dict;
}

### 形態素解析WebAPIで文を形態素に分割する
sub wakati {
    use LWP::UserAgent;
    use JSON;
    my ($query) = @_;
    my $appid = "THISISAPEN"; # 自分で取得した AppID を使いましょう
    my $ua = LWP::UserAgent->new;
    $ua->default_header('Content-Type' => 'application/json');
    $ua->default_header('User-Agent' => 'Yahoo AppID: '.$appid);
    my $url = "https://jlp.yahooapis.jp/MAService/V2/parse";
    my $params = {
        "jsonrpc" => "2.0",
        "method" => "jlp.maservice.parse",
	"id" => "123",
        "params" => { "q" => $query }
    };
    my $response = $ua->post($url, content => JSON::encode_json($params));
    if ($response->is_success) {
	my $j = decode_json($response->content);
	return [map {$_->[0]} @{$j->{"result"}{"tokens"}}];
    } else {
        die $response->status_line;
    }
}
