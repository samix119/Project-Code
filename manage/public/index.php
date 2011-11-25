<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head >
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Viva Connect | Server Management</title>
<link rel="stylesheet" type="text/css" href="view.css" media="all">
</head>

<body id="main_body">
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

	syslog(LOG_NOTICE, "manage: index.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, loading index");
} else {
	syslog(LOG_NOTICE, "manage: index.php: client: {$_SERVER['REMOTE_ADDR']}, user: undet, sess_id: unset, redirect auth.php");
	header('Location: http://manage.email360api.com/' . $auth_page);
	exit;
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


<table id="ServerList" cellspacing="0" summary="Parent servers">
</tr>
<caption>&nbsp;available parent servers</caption>
<tr>
<th scope="col" abbr="Servername">Servername</th>
<th scope="col" abbr="Vm's">Vm's</th>
</tr>

<?php
## get the list of servers now and generate the tables thus
foreach($servername as $pid) {
	syslog(LOG_NOTICE, "manage: index.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, load parent $pid");

	echo "
		<tr>
		  <td id=\"hoverthis\"><form id=\"serverpost\" action=\"serverlist.php\" method=\"post\">
		  <button type=\"submit\" name=\"s\" value=\"$pid\">$pid</button>
		  </form>
		  </td>

		 <td>";
		
		$lines = file("../lib/$pid.conf");
		foreach ($lines as $line) {
			if(!preg_match('/^#/',$line)) {
				echo "<t class=\"vmname\">$line</t><br>";
			}
		}
	}
?>
</td>
</tr>
</table>
<br>
<img id=\"bottom\" src=\"bottom.png\" />
<br>
<br>
<div id="footer">
Powered by <a href="http://madinix.com">Madinix</a>
</div>
</div>
<img id="bottom" src="bottom.png" alt="">
</body>
</html>

