<?php
# Logging in with Google accounts requires setting special identity, so this example shows how to do it.
require 'openid.php';
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

?>
<form action="?login" method="get">
<input type="submit" name="google" value="login with google" />
<input type="submit" name="yahoo" value="login with yahoo" />
</form>
<?php
    } elseif($openid->mode == 'cancel') {
        echo 'User has canceled authentication!';
    } else {
	## Check if login has been successful, else redirect to the main login page
	if(!$openid->validate()) {
		header('http://manage.email360api.com/failed.html');
	}
	## login has been successful, now set cookie and redirect to the next page
	$array = $openid->getAttributes();
	setcookie("user",$array['contact/email'],time()+3600);
    }
} catch(ErrorException $e) {
    echo $e->getMessage();
}
