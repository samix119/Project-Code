<?php
require '../lib/manage_functions.php';
require '../lib/config.php';
require '../lib/commands.php';

## check if the user is authenticated and what is the username
session_start();
$id = session_id();

if(isset($_SESSION['username'])) {
	## We know who the user is
	$user = $_SESSION['username'];
	if (!strcmp('admin',$user)) {
                header('Location: http://manage.email360api.com/' . $admin_page);
                exit;
        }

	syslog(LOG_NOTICE, "manage: worker.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, loading worker");
} else {
	syslog(LOG_NOTICE, "manage: worker.php: client: {$_SERVER['REMOTE_ADDR']}, user: unset, sess_id: unset, loading worker");
	header('Location: http://manage.email360api.com/' . $auth_page);
	exit;
}


##fine, the user has a session
if((!isset($_POST['cmd'])) or (!isset($_POST['c'])) or (!isset($_POST['p']))or (!isset($_POST['p']))) {
	syslog(LOG_NOTICE, "manage: worker.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: unset, ctid: unset, parent: unset, cmd: unset");
	header('Location: http://manage.email360api.com/' . $error_page );
	exit;
}

##variables are set, give the user option to stop, start, reboot the vm's
$servername = $_POST['v'];
$ctid = $_POST['c'];
$parent = $_POST['p'];
$cmd = $_POST['cmd'];
$dsc = $_POST['dsc'];
$reason = $_POST['reason'];

## relace all newlines with spaces in the reason variable
syslog(LOG_NOTICE, "manage: worker.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, dsc: $dsc, reason: $reason");

## execute the command now
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Viva Connect | Server Management</title>
<link rel="stylesheet" type="text/css" href="worker.css" media="all">
</head>

<body id="main_body" >
<div id="form_container">
<div style="position: relative; float: left; ">
<img id="top1" src="viva.png" alt="">
</div>

<div class="index_bottom">
<a class="indexa" href="index.php">Home</a>
<t class="index">&nbsp;&nbsp;|&nbsp;&nbsp;</t>
<a class="indexa" href="contact.php">Contact</a>
<t class="index">&nbsp;&nbsp;|&nbsp;&nbsp;</t>
<a class="indexa" href="logout.php">Logoff(<?php echo $user ?>)</a>
<t class="index">&nbsp;&nbsp;</t>
</div>

<img id="top" src="top.png" alt="">
<div class="form_description">
<h2>&nbsp;Viva Connect | Server Management</h2>
&nbsp;Control panel for servers and services
</div>

<div style="float: left;">
<?php
echo "<div class=\"shell\">";
$ret_val = run_command($servername, $ctid, $parent, $cmd, $user, $dsc);
echo "</div>";

echo "<div style=\"margin-top: 20px;\">";
if ( $ret_val == "0" ) {
	echo "<t class=\"cstatus\">&nbsp;$dsc returned success</t>";
} else {
	echo "<t class=\"cstatus\">&nbsp;$dsc returned failure</t>";
}
?>
</div>
</div>
</div>
</body>
</html>

