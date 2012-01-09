class openvz::conf {

	file {'sysctl-file':
		path    => '/etc/sysctl.conf',
		ensure  => present,
		mode    => 0640,
		source  => 'puppet:///modules/openvz/sysctl.conf'
	}	

#	exec { subscribe-sysctl:
#        	command => "/sbin/sysctl -p && /bin/echo SYSCTL EXECUTED",
#        	logoutput => true,
#        	refreshonly => true,
#        	subscribe => FILE["/etc/sysctl.conf"]
#	}
}	
