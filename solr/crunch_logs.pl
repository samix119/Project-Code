#!/usr/bin/perl

use strict;

use File::ReadBackwards;

## Get hostname
use Sys::Hostname;
my $hostname = hostname;

## # Generate key
use String::Random;
my $pass = new String::Random;
my $filename = $pass->randpattern("CCcncncncCcnCnccCCnc");

## Get all the date formats that we want
use POSIX "strftime";
my $current_year = POSIX::strftime("%Y", localtime());
my $date = POSIX::strftime( "%b %d", localtime());
my $earliest = POSIX::strftime( "%b %_d %H:%M:%S", localtime(time() - 5 * 60) );

## month to numeral key
my %m2n = (
	'Jan' => '1',
	'Feb' => '2',
	'Mar' => '3',
	'Apr' => '4',
	'May' => '5',
	'Jun' => '6',
	'Jul' => '7',
	'Aug' => '8',
	'Sep' => '9',
	'Oct' => '10',
	'Nov' => '11',
	'Dec' => '12',
	);

my $csv_file_name="/tmp/$filename";
open CSV, ">$csv_file_name" or die $!;
print CSV "log_date,id,to_address,to_domain,status,hostname,text\n";

## some vars
my $year_to_print;
my $date_to_print;

##generate the csv file that we are going to put uppah
my $bw = File::ReadBackwards->new( '/var/log/maillog' ) or
                        die "can't read 'log_file' $!" ;
while ( defined( my $log_line = $bw->readline() ) ) {

	## We do not want relay=127 lines
	next if ( $log_line =~ /relay=127\.0\.0\.1/ );
	next if ( $log_line =~ /relay=local,/ );

	## stop if we have slurped the last 5 minutes
	last if $log_line lt $earliest;

	## remove the new lines
	chomp $log_line;

	## remove commas
	$log_line =~ s/\,//g;

	#print "$log_line\n";
	#next;

	if ($log_line =~ /relay=/ ) {

		## suppose the cron wakes at 0:0:0 of 1 Jan 2012 and reads the last 5 minutes of the the previos year 
		## logs, then we want the last years logs to have last years YEAR and not this years
		## below is a dirty way to achieve this
		if (( $log_line =~ /Dec 31/ )  and ( $date =~ /Jan 01/ )) {
			## we need to decrement the year
			$year_to_print = $current_year - 1;
		} else {
			## Either today is not Dec 31 or we have still not hit the new year
			## and reading previous years log entries
			$year_to_print = $current_year;
		}

		#print "processing $log_line\n";
		my @log_parts  = split(/ +/, $log_line);

		## get the m2n for this month
		my $month_to_print = $m2n{$log_parts[0]};

		## get the date to print
		if ($log_parts[1] < 10) {
			$date_to_print  = '0' . $log_parts[1];
		} else {
			$date_to_print  = $log_parts[1];
		}

		## time to print
		my $time_to_print = $log_parts[2];

		## final log_date looks like
		my $log_date = $year_to_print . '-' . $month_to_print . '-' . $date_to_print . 'T' . $time_to_print . 'Z';

		## to address sanitization
		$log_parts[6] =~ s/to=<//;	
		$log_parts[6] =~ s/>//;	

		## to address
		my $to_address = $log_parts[6];

		## to domain
		my @address_array = split(/\@/,$log_parts[6]);
		my $to_domain = $address_array[1];

		## status
		$log_line =~ /status=(\w+)/;
		my $status = $1;

		#print CSV "log_date,id,to_address,to_domain,status,hostname,text\n";
		print CSV "$log_date,$log_parts[5],$to_address,$to_domain,$status,$hostname,$log_line\n";
	}
}

print "/tmp/$filename";
