<?
include_once("../JSON.php");
$json = new Services_JSON();

    $username_already_in_use = $_REQUEST['username_already_in_use'];
	$email_already_in_use = $_REQUEST['email_already_in_use'];
	$pw_insecure = $_REQUEST['pw_insecure'];
	$bad_email = $_REQUEST['bad_email'];
	$username_too_short = $_REQUEST['username_too_short'];
        $uploadError = $_REQUEST['uploadError'];
	$noERROR = $_REQUEST['noERROR'];
	$return=array();
	//Old format
	//if($noERROR==1){
	//	$return[]= array('code' => 5926, 'reason' => 'AOK');}
	//If an error exists, add it to the array
	if($noERROR==1){
		$return['code1']=5926;}
		
	if($username_too_short==3142){
		$return['code2']=3142;}
	
	if($username_already_in_use==3141){
		$return['code3']=3141;}

	if($email_already_in_use==3144){
		$return['code4']=3144;}

	if($pw_insecure==3145){
		$return['code5']=3145;}
	
        if($bad_email==3143){
		$return['code6']=3143;}

        if($uploadError==3199){
		$return['code7']=3199;}

	//Encode and return array
	Echo $json->encode($return);

	//print json_encode($return);
  ?>