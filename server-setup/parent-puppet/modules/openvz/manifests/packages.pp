class openvz::packages {

	file {'openvz-repo':
		path    => '/etc/yum.repos.d/openvz.repo',
		ensure  => present,
		mode    => 0640,
		source => 'puppet:///modules/openvz/openvz.repo',
	}

	package {'ovzkernel':
		provider => 'yum',
		ensure => present,
		require => FILE['openvz-repo']
	}

	package {'ovzkernel-devel':
		provider => 'yum',
		ensure => present,
		require => FILE['openvz-repo']
	}

	package {'vzctl':
		provider => 'yum',
		ensure => present,
		require => FILE['openvz-repo']
	}
}
