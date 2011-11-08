#!/usr/bin/perl

use CGI;
my $q = CGI->new;
print $q->header(),
	$q->start_html(-title => "Here is your ip");
print $q->remote_addr();
print $q->end_html;
