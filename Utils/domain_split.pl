#!/usr/bin/perl


## Special thanks to rindolf from perl channel #perl on freenode for the regex.
use strict;
use warnings;

use Sys::Hostname;
my $host = hostname;


my $string = "$host";
my $labels = split(/\./, $host);
$labels-=3;

for(my $i=0;$i<=$labels;$i++){
        $string = $string . ',';
        $host  =~ s/^[^.]+\.//;
        $string = $string . $host;
}
print "$string\n";
