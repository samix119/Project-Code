use strict;
use warnings;
use threads;
use threads::shared;
 
print "Starting main program\n";
 
my @threads;
for ( my $count = 1; $count <= $ARGV[0]; $count++) {
        my $t = threads->new(\&send_emails,$ARGV[1], $ARGV[2], $ARGV[3] );
	print "Thread $count created\n";
        push(@threads,$t);
}
foreach (@threads) {
        my $num = $_->join;
        print "done with $num\n";
}
print "End of main program\n";
 
sub send_emails {
        my($mailcount,$mailfile,$relayserver) = @_;

	#print "$mailcount,$mailfile,$relayserver";
	my $mailcontent = undef;
	open MAILFILE, "/root/sameer/Maildir/$mailfile";
	while(<MAILFILE>) {
		$mailcontent = $mailcontent . $_;
	}	
	close MAILFILE;

	use Net::SMTP;
  	my $smtp = Net::SMTP->new("iad$relayserver.indianacademy.org.in", Debug => 0) or die;

	for ( my $scount = 1; $scount <= $mailcount; $scount++) {

		$smtp->mail('bouncesameer@email360api.com');
    		$smtp->to('sameer@test.email360api.com');

	    	$smtp->data();
		$smtp->datasend("\n");
	    	$smtp->datasend($mailcontent);
    		$smtp->dataend();
		#print "sent $scount mail\n";
	}
	#print "relay$num: $mailcount found\n";
    	$smtp->quit;	
	return $mailcount;
}
	
