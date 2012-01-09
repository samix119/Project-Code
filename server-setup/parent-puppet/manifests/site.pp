node default {
	
	## openvz specific stuff
	include	openvz::packages
	include openvz::conf
	include openvz::vm

	## nagios related stuff
	include nagios::packages
	include nagios::conf
	include nagios::scripts
	nagios::scripts::put_scripts {"check_vm_failcount": ensure => "present"}

	## sudo
	include sudo::packages ## delete for security resons
	include sudo::conf @## deleted for security resons

	## user management
	include user

	## timezone
	$zonefile = "/usr/share/zoneinfo/Asia/Calcutta"
	include timezone

	## util rpms
	utils::install_rpm{"atop": ensure => "present"}
	utils::install_rpm{"sysstat": ensure => "present"}
	utils::install_rpm{"strace": ensure => "present"}

	## system monitor
	include sysmon

	## postfix	
	include postfix

	## env
	include env::bash

	## selinux disable
	include selinux

}
