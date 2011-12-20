#!/usr/bin/perl
use File::ReadBackwards;
use POSIX "strftime";

use Socket;
use Sys::Hostname;
my $hostname = hostname;
my $addr = inet_ntoa(scalar(gethostbyname($hostname)) || 'localhost');

my $success;
my $sent=0;
my $bounced=0;
my $deferred=0;
my $mailrecieved=0;
my $earliest = POSIX::strftime( "%b %_d %H:%M:%S", localtime(time() - 60 * 60) );

#print "$earliest\n";

$bw = File::ReadBackwards->new( '/var/log/maillog' ) or
                        die "can't read 'log_file' $!" ;
while ( defined( my $log_line = $bw->readline() ) ) {
	last if $log_line lt $earliest;

	next if ($log_line =~ /to=<root\@/ );

	if ( $log_line =~ /relay=127\.0\.0\.1/ ) {
		if ( $log_line =~ /status=sent/ ) {
			$mailrecieved++;
			next;
		}
		next;
	}

	if ( $log_line =~ /relay=local\,/ ) {
		next;
	}

	if ($log_line =~ /status=sent/) {
		#print $log_line;
		$sent++;
	}

	if ($log_line =~ /status=bounced/) {
		#print $log_line;
		$bounced++;
	}

	if ($log_line =~ /status=deferred/) {
		$deferred++;
		@elements = split(/\ /,$log_line);
		$deferred{$elements[5]}++;
	}
}

#$deferred = keys %deferred;
print "$hostname\[$addr\]: Hourly Mail Summary\n";
print "===================================================\n";
print "sent:$sent bounced:$bounced deferred:$deferred recieved:$mailrecieved\n";
print "===================================================\n";
#print "\nDetails about mails that were deffered\n";
#print "===================================================\n";
#while ( ($k,$v) = each %deferred ) {
#	if ( $v > 5 ) {
#		print "$v attempt(s) to deliver $k have deferred\n";
#	}
#}
#print "remaining emails were deferred less than 5 times";
exit 0;


