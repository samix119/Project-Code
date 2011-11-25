<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head >
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Viva Connect | Server Management</title>
<link rel="stylesheet" type="text/css" href="admin.css" media="all">
</head>

<body id="main_body" onLoad="preloader()">
<?php
require '../lib/manage_functions.php';
require '../lib/config.php';

## check if the user is authenticated and what is the username
session_start();

if(isset($_SESSION['username'])) {
	## We know who the user is
	$user = $_SESSION['username'];
	$id = session_id();
	if (strcmp('admin',$user)) {
		header('Location: http://manage.email360api.com/' . $warn_page);
		exit;
	}

	syslog(LOG_NOTICE, "manage: index.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, loading admin");
} else {
	syslog(LOG_NOTICE, "manage: index.php: client: {$_SERVER['REMOTE_ADDR']}, user: undet, sess_id: unset, redirect auth.php");
	header('Location: http://manage.email360api.com/' . $auth_page);
	exit;
}

if(isset($_POST['a'])) {
	$email = $_POST['emailaddress'];
	syslog(LOG_NOTICE, "manage: admin.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, cmd: add($email)");

	$retval = isValidEmail($email);
	if ( $retval == "1" ) {
		$current = file_get_contents('../db/email');
		$current .= "$email" . "\n";
		file_put_contents('../db/email', $current);
		echo "<t class=\"invalidemail\">$email added</t>";
	} else {
		echo "<t class=\"invalidemail\">invalid email address</t>";
	}
}

if(isset($_POST['d'])) {
	$email = $_POST['emailaddress'];
	syslog(LOG_NOTICE, "manage: admin.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, cmd: del($email)");

	$fname = "../db/email";
	$lines = file($fname);
	$out = "";
	foreach ($lines as $line) {
		if (strstr($line, $email) == "") {
		$out .= $line;
		}
	}
	$f = fopen($fname, "w");
	fwrite($f, $out);
	fclose($f);
	echo "<t class=\"invalidemail\">$email deleted</t>";
}

?>


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
<div>
</div>
</div>



<t class="action">add emailaddress</t>
<form action="admin.php" method="post">
<div style="float:left;width:100px;height:50x;margin-top:14px;margin-left:10px;margin-bottom:1px;">
<input name="emailaddress" type="text" maxlength="255" value=""/>
</div>
<div style="float:left;width:100px;height:50px;margin-bottom:1px;">
<button class="addicon" type="submit" name="a" value="add"></button>
</div>
</form>

<table id="ServerList" cellspacing="0" summary="Email addresses allowed to login" align="left">
</tr>
<caption>&nbsp;emailaddress list</caption>
<tr>
<th scope="col" abbr="emailaddress">emailaddress</th>
</tr>
<?php

$data = file('../db/email');
foreach($data as $value) {
	$trimmed = trim($value,"\n\n");
	syslog(LOG_NOTICE, "manage: admin.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, $trimmed");
	echo "
		<tr>
		<td>
		<div style=\"float: left\";>
		$trimmed
		</div>
		<div style=\"float:right;height:10px;\"><form action=\"?\" method=\"post\">
		<input type=\"hidden\" name=\"emailaddress\" value=\"$trimmed\" />
		<button class=\"delicon\" type=\"submit\" name=\"d\" value=\"del\"></button>
		</form>
		</td>
		</tr>
	";
}
?>
</table>




<div id="footer">
Powered by <a href="http://madinix.com">Madinix</a>
</div>
</div>
<img id="bottom" src="bottom.png" alt="">
</body>
</html>

