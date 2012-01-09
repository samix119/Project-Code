class utils {

	## define for rpms to be installed
	define install_rpm ($ensure = "present") {
		package { "${name}" :
			ensure => installed,
			provider => "yum";
		}
	}	

	## define to put a cron under /etc/cron.d
	define install_cron ( $ensure = "present" ) {
		file { "/etc/cron.d/${name}":
			source => 'puppet:///modules/utils/${name}',
			ensure => present,
			owner  => root,
			group  => root,
			mode   => 644,
		}	
	}	
}


#  ## define to put scripts under /opt/scripts
#	define utilscripts ( $ensure = "present" ) {
#    file {
#      "/opt/scripts/${name}":
#        require => File["/opt/scripts"],
#        source => [
#                   "puppet:///pwmailutils/${name}.$hostname",
#                   "puppet:///pwmailutils/${name}-$class",
#                   "puppet:///pwmailutils/${name}",
#                   ],
#        mode => 755,
#        ensure => $ensure;
#    }
#	}

