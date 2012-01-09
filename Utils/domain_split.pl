#!/usr/bin/perl


## Special thanks to rindolf from perl channel #perl on freenode for the regex.
use strict;
use warnings;

use Sys::Hostname;
use constant LIMIT => 3;
my $host = hostname;


my $string = "$host";
my $labels = split(/\./, $host);
$labels-=LIMIT;

for(my $i=0;$i<=$labels;$i++){
        $host  =~ s/^[^.]+\.//;
        $string .= ",$host";
}
print "$string\n";
