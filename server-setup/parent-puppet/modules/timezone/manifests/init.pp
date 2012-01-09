class timezone {
	file {'/etc/localtime':
		ensure => $zonefile
	}

	package {'ntp':
		ensure => present,
	}

	exec { 'sync-time':
        	command => "/usr/sbin/ntpdate 0.us.pool.ntp.org && hwclock --systohc",
        	logoutput => true,
		require => Package['ntp'],
                refreshonly => true,
                subscribe => Package['ntp'],
	}
}

