#!/usr/bin/perl

use CGI;
my $q = CGI->new;

print $q->header();
print "<head><title>Here is your ip</title></head>";
print $q->remote_addr();
