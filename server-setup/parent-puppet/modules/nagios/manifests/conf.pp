class nagios::conf {

	service {'xinetd':
		ensure => running
	}

	file {'/etc/xinetd.d/nrpe':
		ensure => present,
		mode => 0640,
		source => 'puppet:///modules/nagios/nrpe',
		notify => Service['xinetd']
	}

	file {'/etc/nagios/nrpe.cfg':
		ensure => present,
		mode => 0640,
		source => 'puppet:///modules/nagios/nrpe.cfg',
		notify => Service['xinetd']
	}
}
