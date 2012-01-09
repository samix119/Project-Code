class env::bash {

        file {"/root/.bashrc":
                ensure => present,
                mode => 0644,
                source => "puppet:///modules/env/bashrc"
        }


        file {"/root/.bash_profile":
                ensure => present,
                mode => 0644,
                source => "puppet:///modules/env/bash_profile"
        }

	file { "/usr/bin/c":
		ensure => "/usr/bin/clear"	
	}
}

