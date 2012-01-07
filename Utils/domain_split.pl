#!/usr/bin/perl


## Special thanks to rindolf from perl channel #perl on freenode for the regex.
use Sys::Hostname;
$host = hostname;


$string = "$host";
$labels = split(/\./, $host);
$labels=$labels - 3;

for($i=0;$i<=$labels;$i++){
        $string = $string . ',';
        $host  =~ s/^[^.]+\.//;
        $string = $string . $host;
}
print "$string\n";
