class postfix {
	
	package {"sendmail-cf":
		ensure => absent,
	}

	package {"sendmail":
		ensure => absent,
		require => Package["sendmail-cf"],
	}


	package {"postfix":
		ensure => present,
	}
}
