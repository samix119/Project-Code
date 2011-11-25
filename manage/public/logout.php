<?php
// set the expiration date to one hour ago
session_start();
$id = session_id();
$user = $_SESSION['username'];
session_destroy(); 
$idtest = session_id();
if ($idtest == '') {
	syslog(LOG_NOTICE, "manage: logout.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, logout successful");
	header('Location: http://manage.email360api.com' . $auth_page);
	exit;
}
?> 
