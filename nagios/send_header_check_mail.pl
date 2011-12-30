#!/usr/bin/perl
use strict;

# syslog
use Sys::Syslog qw(:DEFAULT setlogsock);
setlogsock('unix');
openlog('check_infra','','info');

## collect the command line options
use Getopt::Std;
my %options = ();
getopts("s:i:f:t:u:p:", \%options);

my $smtpserver = $options{s};
my $imapserver = $options{i}; 
my $fromemail = $options{f};
my $toemail = $options{t};
my $imap_user = $options{u};
my $imap_pass = $options{p};

if ((!defined($smtpserver)) or (!defined($fromemail)) or (!defined($toemail))) {
	print "usage: $0 -s SMTPSERVER -f FROMEMAIL -t TOEMAIL\n";
	exit 1;
}

my @email_part = split(/\@/, $toemail);
#print $email_part[1];


## First connect and send the email, return the key
my $key = send_email($smtpserver, $fromemail, $toemail);

sub send_email {

my ($smtpserver,$fromemail,$toemail) = @_;

# Generate key
use String::Random;
my $pass = new String::Random;
$key = $pass->randpattern("CCcncncncccn") or catch_n_report("infracheck: $smtpserver: cannot generate key",$smtpserver);
use MIME::Lite;
    ### Create a new single-part message, to send a GIF file:
    my $msg = MIME::Lite->new(
    From     => "$fromemail",
    To       => "$toemail",
    Subject  => 'infra_header_check' . ':' . $smtpserver . ':' . $key,
    Type     => 'text/plain',
    Data     => $key,
    );

## use Net:SMTP to do the sending
eval { $msg->send('smtp',$smtpserver, Debug=>0 ) }; catch_n_report("infracheck: $smtpserver: cannot send email",$smtpserver) if $@;
return $key;
}

sub catch_n_report {

	my($error,$smtpserver) = @_;
	syslog("info",$error);
	open(MAIL, "|/usr/sbin/sendmail -t");
#        print MAIL "To: zakir\.s\@madinix\.com\;sysad\@madinix.com\n";
        print MAIL "To: sysad\@madinix.com\n";
        print MAIL "From: infracheck\@mis\.email360api\.com\n";
        print MAIL "Subject: IGNORE $smtpserver services are affected\n\n";
        print MAIL $error;
        close(MAIL);
	exit 1;
}
