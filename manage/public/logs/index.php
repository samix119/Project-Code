<?php
$mailserver="Select";
$selectms="";
$selectlf="";

$dict_lf=array();

$dict_lf[0]="0";
$dict_lf[1]="1";
$dict_lf[2]="2";
$dict_lf[3]="3";
$dict_lf[4]="4";

$logdays="Select:Today:Yesterday:Current Week:Previous Week";
$dict_days=explode(":",$logdays);

$mailsrv="relay11.email360api.com (88.198.233.97)|relay12.email360api.com (88.198.233.98)|relay13.email360api.com (88.198.233.99)|relay14.email360api.com (88.198.233.100)|relay15.email360api.com (88.198.233.101)|relay16.email360api.com (88.198.233.102)|relay17.email360api.com (88.198.233.103)|relay18.email360api.com (88.198.233.104)|relay19.email360api.com (88.198.233.105)|relay20.email360api.com (88.198.233.106)|relay21.email360api.com (88.198.233.107)|relay22.email360api.com (88.198.233.108)|relay31.email360api.com (78.47.56.65)|relay33.email360api.com (78.47.56.67)|relay34.email360api.com (78.47.56.68)|relay35.email360api.com (78.47.56.69)|relay36.email360api.com (78.47.56.70)|relay37.email360api.com (78.47.56.71)|relay38.email360api.com (78.47.56.72)|relay39.email360api.com (78.47.56.73)|relay40.email360api.com (78.47.56.74)|relay41.email360api.com (78.47.56.75)|relay42.email360api.com (78.47.56.76)|re1.email360.in (180.149.242.114)|re2.email360.in (180.149.242.115)|re3.email360.in (180.149.242.116)|re4.email360.in (180.149.242.117)|re5.email360.in (180.149.243.114)|re6.email360.in (180.149.243.115)|re7.email360.in (180.149.243.116)|re8.email360.in (180.149.243.117)|im1.india-marketing.in (202.38.172.161)|im2.india-marketing.in (202.38.172.162)|im3.india-marketing.in (202.38.172.163)|im4.india-marketing.in (202.38.172.164)|im5.india-marketing.in (202.38.172.165)|im6.india-marketing.in (202.38.172.166)|im7.india-marketing.in (202.38.172.167)|im8.india-marketing.in (202.38.172.168)|im11.india-marketing.in (202.38.174.233)|im12.india-marketing.in (202.38.174.234)|im13.india-marketing.in (202.38.174.235)|im14.india-marketing.in (202.38.174.236)|im15.india-marketing.in (202.38.174.237)|im16.india-marketing.in (202.38.174.238)|im17.india-marketing.in (202.38.174.239)|im18.india-marketing.in (202.38.174.240)";

$mservers="relay11.email360api.com|relay12.email360api.com|relay13.email360api.com|relay14.email360api.com|relay15.email360api.com|relay16.email360api.com|relay17.email360api.com|relay18.email360api.com|relay19.email360api.com|relay20.email360api.com|relay21.email360api.com|relay22.email360api.com|relay31.email360api.com|relay33.email360api.com|relay34.email360api.com|relay35.email360api.com|relay36.email360api.com|relay37.email360api.com|relay38.email360api.com|relay39.email360api.com|relay40.email360api.com|relay41.email360api.com|relay42.email360api.com|re1.email360.in|re2.email360.in|re3.email360.in|re4.email360.in|re5.email360.in|re6.email360.in|re7.email360.in|re8.email360.in|im1.india-marketing.in|im2.india-marketing.in|im3.india-marketing.in|im4.india-marketing.in|im5.india-marketing.in|im6.india-marketing.in|im7.india-marketing.in|im8.india-marketing.in|im11.india-marketing.in|im12.india-marketing.in|im13.india-marketing.in|im14.india-marketing.in|im15.india-marketing.in|im16.india-marketing.in|im17.india-marketing.in|im18.india-marketing.in";

$dict_ms1=explode("|",$mailsrv);
$dict_ms=explode("|",$mservers);

$emailid=$_POST["emailid"];
$mailserver=$_POST["mailserver"];
$logsfor=$_POST["day"];

//echo ($emailid." ".$mailserver." ".$logsfor);

?>
<html>
# This Maillog Interface accepts the Domain-Name or Email-Address and then passes it to the backend Shell Script.  <br>
# For any issues, please contact [Zakir Shaikh]. <br>
<br>

<head>
<title> VivaConnect </title>
<script type="text/javascript">
        function clear_all()
        {
                document.myform.emailid.value="";
                document.myform.mailserver.value="";
                document.myform.day.value="";
        }
</script>
</head>
<body BACKGROUND="paper.gif" BGCOLOR="#FFFFFF" TEXT="#000000">
<form name="myform" action="<?php echo $_SERVER['PHP_SELF'] ?>" method="POST">
       <p><b>Enter the emailaddress/Domainname :</b>
               <input type="text" name="emailid" id="emailid">
       </p>
       <p><b>Select the Mail Server : </b>
       <select name="mailserver" id="mailserver">
	<option value="" selected>--Select--</option>
<?php
for($k=0;$k<count($dict_ms);$k++){
echo "<option value=\"$dict_ms[$k]\"";
	if($dict_ms[$k]==$mailserver)  {
		echo "selected";
	}
echo ">$dict_ms1[$k]</option>";
}

?>
</select>
       </p>
       <p><b>Logs For : </b>
       <select name="day" id="day">
<?php
for($i=0;$i<=4;$i++) {
	echo "<option value=\"$dict_lf[$i]\"";
	if($dict_lf[$i]==$logsfor) { 
		echo "selected";
	}
	echo ">$dict_days[$i]</option>";
}
?>

       </select>
       </p>
       <p>
               <input type="submit" name="Submit_name" value="Submit">
               <input TYPE="button"  NAME="Clear" VALUE="Clear Form and Start Over" onclick="clear_all()">
       </p>

 </form>
</body>
</html>
<?php
if(1==1)
{
 $dname=$_POST['emailid'];
 $daycount=$_POST['day'];
 $mailserver=$_POST['mailserver'];
//Strip the input off all dangerous charecters
       $pattern = array ('/~/','/`/','/!/','/#/','/%/','/\^/','/\*/','/\(/','/\)/','/\+/','/=/','/\\\/','/\|/','/\[/','/{/','/]/','/}/','/:/','/;/','/"/','/\'/','/</','/,/','/>/','/\?/','/\//','/\s/','/\t/','/&/','/\\$/');
       $replace = array ('','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
$domainname=preg_replace($pattern, $replace, $dname);
$contents1 = null;
$v= "'/var/www/html/LOG-Interface/Maillog-Interface-NEW.sh $mailserver $domainname $daycount'";
$v1="/var/www/html/manage/public/logs/Maillog-Interface-NEW.sh ${mailserver} ${domainname} ${daycount}";
system($v1);

echo ("<br/><br/>");

// To Open a File & Read it:
$myFile = "Maillog-Interface-final.out";
$fh = fopen($myFile, 'r');
$theData = fread($fh, filesize($myFile));
fclose($fh);
echo "<br/>";
$outfile=htmlspecialchars($theData);
$outfile=str_replace("\n","<br/><br/>",$outfile);
echo $outfile;
}
?>

