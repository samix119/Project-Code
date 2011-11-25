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

	syslog(LOG_NOTICE, "manage: reason.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, reason for action required");
} else {
	syslog(LOG_NOTICE, "manage: reason.php: client: {$_SERVER['REMOTE_ADDR']}, user: unset, sess_id: unset, redirecting auth.php");
	header('Location: http://manage.email360api.com/' . $auth_page);
	exit;
}


##fine, the user has a session
if((!isset($_POST['cmd'])) or (!isset($_POST['c'])) or (!isset($_POST['p'])) or (!isset($_POST['p'])) or  (!isset($_POST['dsc'])) ) {
	header('Location: http://manage.email360api.com/' . $splash_page );
	exit;
}

##variables are set, give the user option to stop, start, reboot the vm's
$servername = $_POST['v'];
$ctid = $_POST['c'];
$parent = $_POST['p'];
$cmd = $_POST['cmd'];
$dsc = $_POST['dsc'];

syslog(LOG_NOTICE, "manage: reason.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, servername: $servername, ctid: $ctid, parent: $parent, cmd: $cmd, dsc: $dsc");

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Viva Connect | Server Management</title>
<link rel="stylesheet" type="text/css" href="reason.css" media="all">
<script>
function show_image(src, width, height, alt) {
    var img = document.createElement("img");
    img.src = src;
    img.width = width;
    img.height = height;
    img.alt = alt;

    // This next line will just add it to the <body> tag
    document.body.appendChild(img);
}
</script>

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

<div style="float: left;">
<form action="worker.php" method="post">
<textarea class="divtextarea" rows="10" cols="40" name="reason">

<?php echo "reason for $dsc ?"; ?>

</textarea>
</div>
<div>
<input type="hidden" name="cmd" value="<?php echo $cmd;?>">
<input type="hidden" name="c" value="<?php echo $ctid;?>">
<input type="hidden" name="p" value="<?php echo $parent;?>">
<input type="hidden" name="v" value="<?php echo $servername;?>">
<input type="hidden" name="dsc" value="<?php echo $dsc;?>">
<button class="okicon" type="submit"></button>
<div>
<a href="index.php"><img class="cancelicon" src="cancel.png" /></a>
</div>
</div>

</div>

</body>
</html>

