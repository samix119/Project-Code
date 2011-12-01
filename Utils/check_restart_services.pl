#!/usr/bin/perl

use strict;
use IO::Socket;

use Sys::Hostname;
my $hostname = hostname;

my ($socket, $status);

my @services = (
	['ssh',$hostname,'22','sshd'],
	['postfix',$hostname, '25','postfix'],
	['nrpe',$hostname, '5666','xinetd'],
	['submission','localhost', '10027','postfix'],
	['dkim','localhost', '10028','dkimproxy'],
);

for my $i ( 0.. $#services ) {
	$socket = IO::Socket::INET->new(PeerAddr => $services[$i][1],
					PeerPort => $services[$i][2],
					Proto => 'tcp',
					type => SOCK_STREAM);

	if (!$socket) {
		if ( $services[$i][3] ==~ /postfix/ ) {
			system("sbin/postfix","stop");
			system("sbin/postfix","start");
		} else {
			system("/etc/init.d/$services[$i][3]", "restart");
		}
	}

#	if ($socket) {
#		print "$services[$i][0] is accepting connections\n";
#	} else {
#		print "$services[$i][0] is not accepting connections\n";
#	}
}


	
