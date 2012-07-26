<?
include"master_inc.php";
//--------------------------------------------------------------------------RECEIVE LOCAL VARIABLES FROM FORM
$lastname = strip_tags(substr($_POST['lastname'],0,32));
$firstname = strip_tags(substr($_POST['firstname'],0,32));
$phone = strip_tags(substr($_POST['phone'],0,32));
$photo=($_FILES['photo']['name']); 
$password_hint=$_REQUEST['password_hint'];
$noERROR=1;
$udidposted = 9;
//-----------------------CODE FOR SAVING IMAGE STARTS---------------------------------------------------------------
//This is the directory where images will be saved 
 $target = "images/"; 
 $target = $target . basename( $_FILES['photo']['name']); 


 //This gets all the other information from the form 
// move_uploaded_file($_FILES["photo"]["tmp_name"] , $target);

 //Writes the photo to the server 
 if(move_uploaded_file($_FILES['photo']['tmp_name'], $target)) 
 { 
 
 //Tells you if its all ok 
 //echo "The file ". basename( $_FILES['uploadedfile']['name']). " has been uploaded, and your information has been added to the directory";
} 
else { 
 
//Gives and error if its not 
//echo "Sorry, there was a problem uploading your file."; 
$uploadError = 3199;

} 
//-----------------------CODE FOR SAVING IMAGE ENDS-------------------------------------------------------------------

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
if (preg_match("/^.*(?=.{4,})(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$/", $pw_clean, $matches)) {
}else{
//---------------------------------------------------------------------------IF PW NOT IN FORMAT THEN-----------------------------------------------------------------SET PW 104 FLAG
$pw_insecure = 3145;
}

//---------------------------------------------------------------------------IF ERROR FLAGS ARE SET THEN LOG HEADERS----------------------------
if($username_already_in_use==3141 OR $email_already_in_use==3144 OR $pw_insecure==3145 OR $bad_email==3143 OR $username_too_short==3142 OR $uploadError==3199){
header(
"location:user_add_errors.php?pw_insecure=$pw_insecure&email_already_in_use=$email_already_in_use&username_already_in_use=$username_already_in_use&bad_email=$bad_email&username_too_short=$username_too_short&uploadError=$uploadError"); 
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
`userCreated`,
`photo`)
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
now(),
'$photo')"; 
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

        if($uploadError==3199){echo"ErrorUploading".$uploadError;}
	

	
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

