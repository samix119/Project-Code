#!/usr/bin/perl

use strict;
use warnings;

## modules that we are using
use Getopt::Std;
use Net::OpenSSH;

## collect the command line options
my %options = ();
getopts("af:p:", \%options);

my $path_to_file = $options{f};
my $parent = $options{p};
my $process_all = $options{a};

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
       ## parent line
        if ( $_ =~ /^\#parent/ ) {
                @tuple = split(/\ /,$_);
                print "$tuple[0] $tuple[1]\n";
                ## Try to establish a SSH connection to this box
                my $ssh = Net::OpenSSH->new($tuple[1],master_opts => [-o => "StrictHostKeyChecking=no"]);
         	push(@dead,$tuple[0]) if ($ssh->error);
	}

	## non parent, unhashed lines
	if ( $_ !~ /^#/ ) {
		@tuple = split(/\ /,$_);
		print "$tuple[0] $tuple[1]\n";
		## Try to establish a SSH connection to this box
		my $ssh = Net::OpenSSH->new($tuple[1], master_opts => [-o => "StrictHostKeyChecking=no"]);
		push(@dead,$tuple[0]) if ($ssh->error);
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
			#print "$tuple[0] $tuple[1]\n";
			## Try to establish a SSH connection to this box
			my $ssh = Net::OpenSSH->new($tuple[1],master_opts => [-o => "StrictHostKeyChecking=no"]);
			if ($ssh->error) {
				push(@dead,$tuple[0]);
			}
		}
	}
}
}

my $message = "The following machines are not allowing ssh sessions on parent$parent: \n\n";
my $send_mail=0;
foreach(@dead) {
	$send_mail=1;
	$message = $message . $_ . "\n";
}

if ( $send_mail == 1 ) {
	#print "send mail\n";
	open(MAIL, "|/usr/sbin/sendmail -t");
	print MAIL "To: sysad\@madinix.com\n";
	print MAIL "From: root\@mis\.email360api\.com\n";
	print MAIL "Subject: IGNORE THIS MAIL: Parent$parent has some nodes dead\n\n";
	print MAIL $message;
	close(MAIL)
	
}
