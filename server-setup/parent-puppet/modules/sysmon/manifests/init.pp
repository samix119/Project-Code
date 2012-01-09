class sysmon {
	
	user {'sysmon':
		ensure => present,
		home => '/home/sysmon',
	}
	
	file {'/opt/scripts':
		ensure => 'directory',
		recurse => 'true'
	}

	file {'/etc/cron.d/sysmon':
		ensure => 'present',
		mode => 0644,
		source => 'puppet:///modules/sysmon/sysmon.cron'
	}

	file {'/opt/scripts/sysmon.sh':
		ensure => 'present',
		mode => 0755,
		source => 'puppet:///modules/sysmon/sysmon.sh'
	}
}
