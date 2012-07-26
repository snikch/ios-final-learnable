<?
include"master_inc.php";
//--------------------------------------------------------------------------RECEIVE LOCAL VARIABLES FROM FORM
$lastname = strip_tags(substr($_POST['lastname'],0,32));
$firstname = strip_tags(substr($_POST['firstname'],0,32));
$phone = strip_tags(substr($_POST['phone'],0,32));
$password_hint=$_REQUEST['password_hint'];
$noERROR=1;
$udidposted = $_REQUEST['udid'];

//---------------------------------------------------------------------------CHECK IF USERNAME IS LONG ENOUGH
$username = strip_tags(substr($_POST['username'],0,32));
if(trim($username)!=='' && strlen(trim($username)) >= 4){
//---------------------------------------------------------------------------IF LONG ENOUGH THEN RUN A QUERY GETTING ALL DATA FROM THAT USER
$sql="SELECT * FROM users WHERE username='$username'";
$result=mysql_query($sql);
$count=mysql_num_rows($result);
//---------------------------------------------------------------------------IF $sql GOTTEN HAS ROW COUNT > 1 THEN USER ALREADY EXISTS----------------SET EXISTING USER 104 FLAG
if($count>0){
$username_already_in_use = 3141;
}
//---------------------------------------------------------------------------ELSE USERNAME IS TOO SHORT?!?!-------------------------------------------------------SET USER TOO SHORT 104 FLAG
}else{
$username_too_short = 3142;}

//---------------------------------------------------------------------------EMAIL FORMAT CHECK
$email_raw = $_REQUEST['email'];
if(eregi("^[_a-z0-9-]+(\.[_a-z0-9-]+)*@([a-z0-9-]{2,3})+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$", $email_raw))
//if(preg_match("/^[_\.0-9a-zA-Z-]+@([0-9a-zA-Z][0-9a-zA-Z-]+\.)+[a-zA-Z]{2,6}$/i", $email_raw))
{ 
$email = $email_raw;
}else{
//---------------------------------------------------------------------------IF INVALID EMAIL THEN----------------------------------------------------------------------SET INVALID EMAIL 104 FLAG
$bad_email=3143;
} 

//email unique?
$sql="SELECT * FROM users WHERE email='$email'";
$result=mysql_query($sql);
$count=mysql_num_rows($result);
if($count>0){
//---------------------------------------------------------------------------IF SQL FOR EMAIL RETURNS A ROW THEN------------------------------------------------SET EMAIL 104 FLAG
$email_already_in_use=3144;
}

//Secure Password Format Checks
$pw_clean = strip_tags(substr($_POST['password'],0,32));
if (preg_match("/^.*(?=.{4,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\d]).*$/", $pw_clean, $matches)) {
//if (preg_match("/[A-Z]+[a-z]+[0-9]/", $pw_clean, $matches)) {
}else{
//---------------------------------------------------------------------------IF PW NOT IN FORMAT THEN-----------------------------------------------------------------SET PW 104 FLAG
$pw_insecure = 3145;
}

//---------------------------------------------------------------------------IF ERROR FLAGS ARE SET THEN LOG HEADERS----------------------------
if($username_already_in_use==3141 OR $email_already_in_use==3144 OR $pw_insecure==3145 OR $bad_email==3143 OR $username_too_short==3142){
header(
"location:user_add_errors.php?pw_insecure=$pw_insecure&email_already_in_use=$email_already_in_use&username_already_in_use=$username_already_in_use&bad_email=$bad_email&username_too_short=$username_too_short"); 
die();
}
else {header("location:user_add_errors.php?noERROR=$noERROR");}

//End Error Checks________________________

//-------------------------------------------------------------------INSERT INTO SQL
//Encrypt Password
$encrypted_pw = md5($pw_clean);
$query = "INSERT INTO `users` (`username`,
`password`,
`lastname`,
`firstname`,
`email`,
`phone`,
`password_hint`,
`udid`,
`userCreated`)
VALUES
(
'$username',
'$encrypted_pw',
'$lastname',
'$firstname',
'$email',
'$phone',
'$password_hint',
'$udidposted',
now())"; 
// save the info to the database
$results = mysql_query( $query );
// print out the results
if( $results )
{
	if($username_too_short==3142){echo"ShortUser=".$username_too_short;}
	
	if($username_already_in_use==3141){echo"UserTaken=".$username_already_in_use;}

	if($email_already_in_use==3144){echo"EmailTaken=".$email_already_in_use;}

	if($pw_insecure==3145){echo"ShortPass=".$pw_insecure;}
	
    if($bad_email==3143){echo"BadEmail".$bad_email;}
	

	
//echo( "<font size='2' face='Verdana, Arial, Helvetica, sans-serif'>Your changes have been made sucessfully. <br><br><a href='login.php'>Back to login</a></font> " );
}
else
{
die( "Trouble saving information to the database: " . mysql_error() );
}
//--------------------------------------AGAIN?! THIS IS FOR THE FIRST ENTRY I THINK
$sql="SELECT * FROM users";
$result=mysql_query($sql);
$count=mysql_num_rows($result);
if($count==1){

$query = "UPDATE `users` SET `permissions`='5' WHERE `email`='$email'"; 
//---------------------------------------SAVE the info to the database
$results = mysql_query( $query );
//---------------------------------------JUST PRINT CODE
if( $results )
{ echo( "ADMINCREATED" );
}
else
{
die( "ERRORSAVINGADMIN" . mysql_error() );
}

}
?>

