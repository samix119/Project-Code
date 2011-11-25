<?php
# Logging in with Google accounts requires setting special identity, so this example shows how to do it.
require '../lib/openid.php';
require '../lib/manage_functions.php';
require '../lib/config.php';
try {
    # Change 'localhost' to your domain name.
    $openid = new LightOpenID('manage.email360api.com');
    if(!$openid->mode) {
        if(isset($_GET['google'])) {
	$openid->required = array('contact/email');
            $openid->identity = 'https://www.google.com/accounts/o8/id';
            header('Location: ' . $openid->authUrl());
        }

        if(isset($_GET['yahoo'])) {
		$openid->required = array('contact/email');
            $openid->identity = 'https://me.yahoo.com';
            header('Location: ' . $openid->authUrl());
        }


    } elseif($openid->mode == 'cancel') {
        echo 'User has canceled authentication!';
    } else {
	## Check if login has been successful, else redirect to the main login page
	if(!$openid->validate()) {
		header('Location: http://manage.email360api.com/failed.html');
	}
	## login has been successful, now set cookie and redirect to the next page
	$array = $openid->getAttributes();
	session_start();
	$id = session_id();
	$_SESSION['username'] = $array['contact/email'];
	$user = $array['contact/email'];
	if(authorize_email($user)) {
		syslog(LOG_NOTICE, "manage: provider.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, login successful");
		header('Location: http://manage.email360api.com/' . $splash_page);
		exit;
	} else { 
		syslog(LOG_NOTICE, "manage: provider.php: client: {$_SERVER['REMOTE_ADDR']}, user: $user, sess_id: $id, authorization refused");
		header('Location: http://manage.email360api.com/' . $auth_page);
                exit;
	}
    }
} catch(ErrorException $e) {
    echo $e->getMessage();
}
?>
