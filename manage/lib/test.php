<?php
##check if this user exists in our database, and them match the password hash
$username='admin';
$password='123!@#qwe07';
$pass_hash_recieved = hash('sha256', $password);
$fp = fopen('../db/passwd','r') or die;
#syslog(LOG_NOTICE, "manage: manage_functions.php: client: {$_SERVER['REMOTE_ADDR']}, localauth, username: $username, password: $password, hash: $pass_hash");

	while(!feof($fp)) {
		echo "****** ITTERATION BEGIN *******\n";
		$tuple = fgets($fp, 1024);
		$trimmed_tuple = trim($tuple,"\n");
		echo "recieved line $trimmed_tuple\n";
		$auth_info=explode(':', $trimmed_tuple);
	
		echo "after explode $auth_info[0] and $auth_info[1]\n";
		echo "compairing $username and $auth_info[0]\n";
	
		if (!strcmp($username,$auth_info[0])) {
			echo "matched $username and $auth_info[0]\n";
			if (!strcmp($auth_info[1],$pass_hash_recieved)) {
				echo "matched $auth_info[1] and $pass_hash_recieved\n";
				return 0;
			} else {
				echo "no matched $auth_info[1] and $pass_hash_recieved\n";
				return 1;	
			}
		} else {
			echo "no match for  $username and $auth_info[0]\n";
		}

	}	

	fclose($fp);
	## this means the us authntication has failed
	return 1;
?>
