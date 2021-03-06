//
//  ModalViewController.m
//  ios-learnable-final
//
//  Created by Mal Curtis on 11/07/12.
//  Copyright (c) 2012 Learnable. All rights reserved.
//

#import "ModalViewController.h"
#import "NSDictionary_JSONExtensions.h"
#import "ASIFormDataRequest.h"

@implementation ModalViewController
@synthesize myConnection, incomingPostData;
@synthesize registerUser,loginUser,userName,userPass,userEmail;
@synthesize imagePickerController, pickedImage;
@synthesize popoverController, myView;


- (IBAction)setPic{
    //[self presentModalViewController:self.imagePickerController animated:YES];
    if(![popoverController isPopoverVisible]){
        // Popover is not visible
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.allowsEditing = TRUE;
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        popoverController = [[[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:imagePickerController] retain];
        //popoverController = [[[UIPopoverController alloc] initWithContentViewController:imagePickerController] retain];
        [popoverController presentPopoverFromRect:CGRectMake(10.0f, 10.0f, 10.0f, 10.0f) inView:myView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else{
        NSLog(@"pop already present");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    self.pickedImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // Dismiss the image selection and close the program
    [picker dismissModalViewControllerAnimated:YES];
}

-(IBAction)userWillLogIn{
    //Call checklogin.php to compare user/pass and return value
    NSString *loginSuccess = [self checkUserLogin:userName.text withPass:userPass.text];
    if ([loginSuccess isEqualToString:@"SUCCESS"]) {
        NSLog(@"We did it...");
        //If all is well, then store userDefaults
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:userName.text forKey:@"storedUser"];
        [prefs setObject:userPass.text forKey:@"storedPass"];
        [prefs synchronize];
        [self dismissModalViewControllerAnimated:YES];
    } else {
        NSLog(@"Authentication Failed..");
        //Add UIAlertView
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops..." message:loginSuccess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    //if checklogin.php = OK then dismiss
}

-(IBAction)userWillRegister{
    // Create uniqueIdentifier
    //UIDevice *device = [UIDevice currentDevice];
    //NSString *uniqueIdentifier = [device uniqueIdentifier];
    //1. Get the LOGIN errorsDictionary
    NSDictionary *errorsDict = [self addUser:userName.text withPass:userPass.text withAddress:userEmail.text];
    //2. if dictcount = 1 then dismiss && = 5926, then OK
    if ([[errorsDict objectForKey:@"code1"] intValue] == 5926) {
        NSLog(@"yeay");
        //If all is well, then store userDefaults
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:userName.text forKey:@"storedUser"];
        [prefs setObject:userPass.text forKey:@"storedPass"];
        [prefs synchronize];
        //Dismis ModalVC after users first login
        [self dismissModalViewControllerAnimated:YES];
    } else {
        NSLog(@"Errors");
        // extract nsdict
        NSMutableString *resultString = [NSMutableString string];
        for (NSString* key in [errorsDict allKeys]){
            if ([resultString length]>0)
                [resultString appendString:@"&"];
            [resultString appendFormat:@"%@=%@", key, [errorsDict objectForKey:key]];
        }
        NSLog(@"rS:%@",resultString);
        //Add UIAlertView
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Check your user,pass or email" message:resultString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}
-(NSString*)checkUserLogin:(NSString *)loginUser withPass:(NSString *)loginPass{
    //CREATE URL TO SEND
    NSString *urlString = [NSString stringWithFormat:@"username=%@&password=%@",loginUser,loginPass];
    NSLog(@"login string:%@",urlString);
    //POST THE STRING
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.yourserver.com/learnable/login2/checklogin.php"]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    // We should probably be parsing the data returned by this call, for now just check the error.
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSError *outError = NULL;
    //NSDictionary *tempDict = [NSDictionary dictionaryWithJSONData:myData error:&outError];
    NSString *string=[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding ];
    //NSLog(@"string es:%@, %i, %C",string,[string length],[string characterAtIndex:7]);
    NSLog(@"string ess:%@",string);
    //NSLog(@"Dict of errors:%@",tempDict);
    return string;
}

-(NSDictionary*)addUser:(NSString *)usuario withPass:(NSString *)clave withAddress:(NSString*)direccion{
    //CREATE URL TO SEND
    NSString *urlString = [NSString stringWithFormat:@"username=%@&password=%@&email=%@",usuario,clave,direccion];
    NSLog(@"user registration string:%@",urlString);
    //POST THE STRING
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.yourserver.com/learnable/login2/user_add_save.php"]];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    // We should probably be parsing the data returned by this call, for now just check the error.
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSError *outError = NULL;
    NSDictionary *tempDict = [NSDictionary dictionaryWithJSONData:myData error:&outError];
    //NSString *string=[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding ];
    NSLog(@"Dict of errors:%@",tempDict);
    return tempDict;
}
@end