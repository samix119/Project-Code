class selinux {
	
	file {'/etc/sysconfig/selinux':
		ensure => present,
		mode => 644,
		source => 'puppet:///modules/selinux/selinux',
	}
}
