<?php
function isValidEmail($email){
return eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$", $email);
}
/*
$lines = file('../db/email');
$email = 'samix_119@yahoo.com';

foreach ($lines as $line_num => $line) {
	$line = trim($line,"\n");
	
	if(!strcmp($email,$line)) {
		$deleted = 1;
	} else {
		$fh = fopen('../', 'w');

}


*/

 $fname = "test.txt"; 
 $exclude = "some string"; 
 $lines = file($fname); 
 $out = ""; 
 foreach ($lines as $line) { 
  if (strstr($line, $exclude) == "") { 
   $out .= $line; 
  } 
 } 
 $f = fopen($fname, "w"); 
 fwrite($f, $out); 
 fclose($f); 
?>
