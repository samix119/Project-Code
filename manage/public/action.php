<?php
require '../lib/manage_functions.php';
require '../lib/config.php';

## check if the user is authenticated and what is the username
session_start();

if(isset($_SESSION['username'])) {
	## We know who the user is
	$user = $_SESSION['username'];
	$id = session_id();
	if (!strcmp('admin',$user)) {
                header('Location: http://manage.email360api.com/' . $admin_page);
                exit;
        }

	syslog(LOG_NOTICE, "manage: action.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, loading actions");
} else {
	syslog(LOG_NOTICE, "manage: action.php: client: {$_SERVER['REMOTE_ADDR']}, user: unset, sess_id: unset, redirecting auth.php");
	header('Location: http://manage.email360api.com/' . $auth_page);
	exit;
}

##fine, the user has a session
if((!isset($_POST['v'])) or (!isset($_POST['c'])) or (!isset($_POST['i']))or (!isset($_POST['s'])) or (!isset($_POST['p']))) {
	header('Location: http://manage.email360api.com/' . $splash_page );
	exit;
}

##variables are set, give the user option to stop, start, reboot the vm's
$servername = $_POST['v'];
$ctid = $_POST['c'];
$ip = $_POST['i'];
$status = $_POST['s'];
$parent = $_POST['p'];
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Viva Connect | Server Management</title>
<link rel="stylesheet" type="text/css" href="action.css" media="all">
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
<div>
</div>
</div>

<p class="servername">&nbsp;<?php echo "$servername($ip)";?> - <?php echo $status;?></p>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="vmst">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - start vm";?>">
<button class="starticon" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">start vm</p>
</form>
</div>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="vmre">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - restart vm";?>">
<button class="restarticon" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">restart vm</p>
</form>
</div> 

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="vmsp">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - stop vm";?>">
<button class="stopicon" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">&nbsp;stop vm</p>
</form>
</div>

<div style="position: absolute; top: 300px;">
<img class="actionsep" src="top.png" alt="">
<p class="servername">&nbsp;<?php echo "$servername($ip)";?> - Postfix</p>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="pfst">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - postfix start";?>">
<button class="starticon" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">postfix start</p>
</form>
</div>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="pfre">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - postfix restart";?>">
<button class="restarticon" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">postfix restart</p>
</form>
</div>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="pfsp">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - postfix stop";?>">
<button class="stopicon" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">postfix stop</p>
</form>
</div>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="pfrl">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - postfix reload";?>">
<button class="postreload" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">postfix reload</p>
</form>
</div>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="pffl">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - postfix flush";?>">
<button class="postflush" type="submit" onclick="this.form.target='_blank';return true;"></button>
<p class="action">postfix flush</p>
</form>
</div>

<div class="actions">
<form action="reason.php" method="post">
<input type="hidden" name="cmd" value="pfpu">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo "$servername - postfix reload";?>">
<button class="postpurge" type="button" disabled="disabled" onclick="this.form.target='_blank';return true;"></button>
<p class="action">postfix purge</p>
</form>
<br>
<br>
<br>
<br>
</div>

<div style="position: absolute; top: 300px;">

</div>



</div>

</body>
</html>

