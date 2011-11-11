#!/usr/bin/perl

use strict;
use warnings;

## some declarations
my %server_uptimes;

## modules that we are using
use Getopt::Std;
use Net::OpenSSH;

## collect the command line options
my %options = ();
getopts("raf:p:", \%options);

my $path_to_file = $options{f};
my $parent = $options{p};
my $process_all = $options{a};
my $reverse_sort = $options{r};

if (defined($process_all) and defined($parent)) {
	print "$0: -a and -p cannot be both specified\n\n";
	print "usage: $0 -f PATH_TO_IP_LIST [-a|-p PARENT_ID]\n";
	exit(1);
}

if ((!defined($process_all)) and (!defined($parent))) {
	print "$0: -a and -p cannot be both unset\n\n";
	print "usage: $0 -f PATH_TO_IP_LIST [-a|-p PARENT_ID]\n";
	exit(1);
}

if (!defined($path_to_file)) {
	print "$0: -f is a required parameter\n\n";
	print "usage: $0 -f PATH_TO_IP_LIST [-a|-p PARENT_ID]\n";
	exit(1);
}
	


## open the path file if it exists to get the parent ips
open(FILE, $path_to_file) or die "$path_to_file does not exists, aborting\n";

my $start_record = 0;
my @tuple;
my @dead;
while(<FILE>) {
#print "$_";
chomp $_;

if ( $process_all ) {
	## non parent, unhashed lines
	if ( $_ !~ /^#/ ) {
		@tuple = split(/\ /,$_);
		print "$tuple[0] $tuple[1]\n";
		## Try to establish a SSH connection to this box
		my $ssh = Net::OpenSSH->new($tuple[1], master_opts => [-o => "StrictHostKeyChecking=no"]);
		my @uptime = $ssh->capture("uptime");
		print "$tuple[1] is down" if ($ssh->error);
		print @uptime;
	}
} else {
	## see if we have reached a parent
	if ( $_ =~ /^\#parent$parent\./ ) {
		$start_record = 1;
		next;
	}

	## see if we are at the next parent and abort
	if ( $start_record == 1 ) {  
		if ( $_ =~ /^\#parent/ ) {
			last;
		}
	}

	if ($start_record == 1 ) {
		if ( $_ !~ /^#/ ) {
			@tuple = split(/\ /,$_);
#			print "$tuple[0] $tuple[1]\n";
			## Try to establish a SSH connection to this box
			my $ssh = Net::OpenSSH->new($tuple[1],master_opts => [-o => "StrictHostKeyChecking=no"]);
                	if ($ssh->error){
				print "$tuple[0] is not reachable\n";
				next;
			}

			my @uptime = $ssh->capture("uptime \| awk \{\'print \$3\'}");
			chomp $uptime[0];
#			print "key is $uptime[0]";
#			print "$values\n";
			$server_uptimes{"\t$tuple[0]" .'[' . $tuple[1] . ']'}=$uptime[0];
		}
	}
}
}

## Function to sort ascending
sub hashValueAscendingNum {
   $server_uptimes{$a} <=> $server_uptimes{$b};
}

## Function to sort decending
sub hashValueDescendingNum {
   $server_uptimes{$b} <=> $server_uptimes{$a};
}

if ( $reverse_sort ) {
	foreach my $key (sort hashValueDescendingNum(keys(%server_uptimes))) {
   		print "$server_uptimes{$key} day(s) $key\n";
	}
} else {
	foreach my $key (sort hashValueAscendingNum(keys(%server_uptimes))) {
   		print "$server_uptimes{$key} day(s) $key\n";
	}
}
