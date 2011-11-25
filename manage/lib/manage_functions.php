<?php
function encryptCookie($value){
   if(!$value){return false;}
   $key = 'manage interface for viva';
   $text = $value;
   $iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB);
   $iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
   $crypttext = mcrypt_encrypt(MCRYPT_RIJNDAEL_256, $key, $text, MCRYPT_MODE_ECB, $iv);
   return trim(base64_encode($crypttext)); //encode for cookie
}

function decryptCookie($value){
   if(!$value){return false;}
   $key = 'manage interface for viva';
   $crypttext = base64_decode($value); //decode cookie
   $iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB);
   $iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
   $decrypttext = mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $key, $crypttext, MCRYPT_MODE_ECB, $iv);
   return trim($decrypttext);
}

function localauth($username, $password) {
##check if this user exists in our database, and them match the password hash
$pass_hash_recieved = hash('sha256', $password);
$fp = fopen('../db/passwd','r') or die;
syslog(LOG_NOTICE, "manage: manage_functions.php: client: {$_SERVER['REMOTE_ADDR']}, localauth, username: $username, password: $password, hash: $pass_hash_recieved");

        while(!feof($fp)) {
syslog(LOG_NOTICE,"****** ITTERATION BEGIN *******");
                $tuple = fgets($fp, 1024);
                $trimmed_tuple = trim($tuple,"\n");
                syslog(LOG_NOTICE,"recieved line $trimmed_tuple");
                $auth_info=explode(':', $trimmed_tuple);

syslog(LOG_NOTICE,"after explode $auth_info[0] and $auth_info[1]");
syslog(LOG_NOTICE,"compairing $username and $auth_info[0]");

                if (!strcmp($username,$auth_info[0])) {
syslog(LOG_NOTICE,"matched $username and $auth_info[0]\n");
                        if (!strcmp($auth_info[1],$pass_hash_recieved)) {
syslog(LOG_NOTICE,"matched $auth_info[1] and $pass_hash_recieved");
                                return 1;
                        } else {
syslog(LOG_NOTICE,"no matched $auth_info[1] and $pass_hash_recieved");
                                return 0;
                        }
                }
        }

        fclose($fp);
        ## this means the us authntication has failed
        return 0;
}
/*
$con = ssh2_connect("127.0.0.1", 22);
	if (ssh2_auth_password($con, $username, $password)) {
		return 1;
	} else  {
		return 0;
	}
}
*/

function check_auth_status() {
## check if the use is already logged in or we need to send him to the login page
   if (isset($_COOKIE["user"])) {
        $user = decryptCookie($_COOKIE["user"]);
        setcookie("user",encryptCookie($user),time()+3600);
	return $user;
   } else {
        header('Location: http://manage.email360api.com/auth.php');
        exit;
   }

}

function authorize_email($email) {
##check if this email exists in our database.
$fp = fopen('../db/email','r') or die;
syslog(LOG_NOTICE, "manage: manage_functions.php: client: {$_SERVER['REMOTE_ADDR']}, emailauth, $email");

        while(!feof($fp)) {
	syslog(LOG_NOTICE,"****** ITTERATION BEGIN *******");
                $tuple = fgets($fp, 1024);
                $trimmed_tuple = trim($tuple,"\n");
                syslog(LOG_NOTICE,"recieved line $trimmed_tuple");

		syslog(LOG_NOTICE,"compairing $email and $trimmed_tuple");

                if (!strcmp($email,$trimmed_tuple)) {
			syslog(LOG_NOTICE,"matched $email and $trimmed_tuple");
                        return 1;
		}
	}
        fclose($fp);
        ## this means the us authntication has failed
        return 0;
}
		

function isValidEmail($email){
        return eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$", $email);
}

?>
