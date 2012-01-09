class nagios::packages {

	package {'nagios-nrpe':
		provider => 'yum',
		ensure => present
	}

	package {'nagios-plugins':
		provider => 'yum',
		ensure => present
	}

	package {'xinetd':
		provider => 'yum',
		ensure => present
	}


}
