<?php

function run_command($servername, $ctid, $parent, $cmd, $user, $dsc) {

	$id = session_id();
	syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, dsc: $dsc");

	$hostname = explode('.', $servername);
	$parent_hostname = explode('.', $parent);

	## stop container
	if ( $cmd == "vmsp" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/stop_vm.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$parent_hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## start container
	if ( $cmd == "vmst" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/start_vm.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## restart container
	if ( $cmd == "vmre" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/restart_vm.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## stop postfix
	if ( $cmd == "pfsp" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/stop_postfix.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## start postfix
	if ( $cmd == "pfst" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/start_postfix.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## restart postfix
	if ( $cmd == "pfre" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/restart_postfix.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## reload postfix
	if ( $cmd == "pfrl" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/reload_postfix.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## purge postfix
	if ( $cmd == "pfpr" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/purge_postfix.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}

	## flush postfix
	if ( $cmd == "pffl" ) {
		exec("sudo -u sysad /opt/scripts/control-panel/flush_postfix.sh $parent $ctid $hostname[0]", $output, $return);
		syslog(LOG_NOTICE, "manage: command.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, command_status: $return");
		foreach($output as $line) {
			echo "$line<br>";
		}
		echo "[root@$hostname[0]]# <t style=\"text-decoration:blink;\"> _</t>";
		return $return;
	}
}
?>
