<?php
require '../lib/manage_functions.php';

## check if the user is authenticated and what is the username
session_start();

if(isset($_SESSION['username'])) {
	## We know who the user is
	$user = $_SESSION['username'];
} else {
	header('Location: http://manage.email360api.com/auth.php');
	exit;
}


?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Viva Connect | Server Management</title>
<link rel="stylesheet" type="text/css" href="view.css" media="all">

</head>
<body id="main_body" >
<div id="wrapper">
<div style="position: absolute; top: 5px; left: 230px;">
<img id="top1" src="viva.png" alt="">
</div>

<img id="top" src="top.png" alt="">


<div id="form_container">
<h1><a>Viva Connect| Server Management </a></h1>
<div class="form_description">
<h2>&nbsp;Viva Connect | Server Management</h2>
&nbsp;Control panel for servers and services
<div id="welcome">
<?php echo "Welcome, $user <a href=\"logout.php\">(logoff)</a>"; ?>
</div>
</div>
<br>
<br>


<?php
require '../lib/config.php';

#<form id="form_135723" class="appnitro">
## get the list of servers now and generate the tables thus
foreach($parentid as $pid) {
	echo "
	<table id=\"ServerList\" cellspacing=\"0\" summary=\"Virtual containers hosted on parent$pid\.email360api\.com\">
	</tr>
	<caption>&nbsp;VM's on Parent-$pid</caption>
	<tr>
	  <th scope=\"col\" abbr=\"Servername\">Servername</th>
	  <th scope=\"col\" abbr=\"Ip Addr\">Ip Addr</th>
	  <th scope=\"col\" abbr=\"Status\">Status</th>
	</tr>";

##		  <td><a href=action.php?server=$b[0]&ctid=$b[3]>$b[0]</a></td>
	$output = array();
	exec("sudo -u sysad /opt/scripts/control-panel/get_vz_list.sh $pid", $output);
	foreach($output as $a) {
		$b = preg_split('/ +/',$a);
		echo "
		<tr>
		  <td id=\"hoverthis\"><form id=\"serverpost\" action=\"action.php\" method=\"post\">
			<input type=\"hidden\" name=\"v\" value=\"$b[0]\">
			<input type=\"hidden\" name=\"i\" value=\"$b[1]\">
			<input type=\"hidden\" name=\"s\" value=\"$b[2]\">
			<input type=\"hidden\" name=\"c\" value=\"$b[3]\">
			<button type=\"submit\">$b[0]</button>
			</form>
		  </td>
		  <td>$b[1]</td>
		  <td>$b[2]</td>
		</tr>";
	}
	echo "</table>";
	echo "<br>";
	echo "<img id=\"bottom\" src=\"bottom.png\" />";
	echo "<br>";
	echo "<br>";
}
?>
<div id="footer">
Powered by <a href="http://madinix.com">Madinix</a>
</div>
</div>
<img id="bottom" src="bottom.png" alt="">
</body>
</html>

