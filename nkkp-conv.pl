#!/usr/bin/env perl
use strict;
use warnings;

$_ = join("", <>);

$_ = join("", map {s/。(.)/。\n$1/g; $_."\n"} m{<Sentence[^>]*>(.+?)</Sentence>}g);

s/わたつて/わたって/g;
s/よつて/よって/g;
s/あつて/あって/g;
s/ゐる/いる/g;
s/思ふ/思う/g;
s/いづれ/いずれ/g;
s/従ふ/従う/g;
s/立たう/立とう/g;
s/誓ふ/誓う/g;
s/負ふ/負う/g;
s/行ふ/行う/g;
s/与へ/与え/g;
s/伴はない/伴わない/g;
s/問はれ/問われ/g;
s/やうに/ように/g;
s/奪はれ/奪われ/g;
s/行つた/行った/g;
s/行ひ/行い/g;
s/失ふ/失う/g;
s/失はせる/失わせる/g;
s/異なつた/異なった/g;
s/取つた/取った/g;
s/かかはらず/かかわらず/g;
s/先だつて/先だって/g;
s/あつた/あった/g;
s/従ひ/従い/g;
s/従はな/従わな/g;
s/行はれ/行われ/g;
s/ゐない/いない/g;
s/なつて/なって/g;

print;

