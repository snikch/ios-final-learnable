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
    
    //1. CALL ASIHTTP & GET DICT
    [self callASIHTTP];
}

-(NSString*)checkUserLogin:(NSString *)loginUsuario withPass:(NSString *)loginClave{
    //CREATE URL TO SEND
    NSString *urlString = [NSString stringWithFormat:@"username=%@&password=%@",loginUsuario,loginClave];
    NSLog(@"login string:%@",urlString);
    //POST THE STRING
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iospart2/login/checklogin.php"]];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iospart2/login/user_add_save.php"]];
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
    NSLog(@"My response data: %@", [[NSString alloc] initWithData:myData encoding:NSASCIIStringEncoding]);
    NSDictionary *tempDict = [NSDictionary dictionaryWithJSONData:myData error:&outError];
    //NSString *string=[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding ];
    NSLog(@"Dict of errors:%@",tempDict);
    return tempDict;
}

-(void)callASIHTTP{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.yourserver.com/learnable/login/user_add_save.php"]];    
    
    // Upload an NSData instance
    NSData *imageData = UIImageJPEGRepresentation(self.pickedImage.image, 90);
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:self.userName.text forKey:@"username"];
    [request addPostValue:self.userPass.text forKey:@"password"];
    [request addPostValue:self.userEmail.text forKey:@"email"];
    NSString *filenameString = [NSString stringWithFormat:@"%@.jpg",self.userName.text];
    [request addData:imageData withFileName:filenameString andContentType:@"image/jpeg" forKey:@"photo"];
    
    //completion blocks
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        if (responseString == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:responseString message:responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        // Use when fetching binary data
        NSError *outError = NULL;
        
        NSData *responseData = [request responseData];
        NSDictionary *tempDict = [NSDictionary dictionaryWithJSONData:responseData error:&outError];
        
        //Test if server response merits dismissing the modalvc
        //2. if dictcount = 1 then dismiss && = 5926, then OK
        if ([[tempDict objectForKey:@"code1"] intValue] == 5926) {
            NSLog(@"yeay");
            //If all is well, then store userDefaults
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:userName.text forKey:@"storedUser"];
            [prefs setObject:userPass.text forKey:@"storedPass"];
            [prefs synchronize];
            //Add UIAlertView
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AllOK" message:@"AllOK" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            //Dismis ModalVC after users first login
            [self dismissModalViewControllerAnimated:YES];
        } else {
            NSLog(@"Errors");
            // extract nsdict
            NSMutableString *resultString = [NSMutableString string];
            for (NSString* key in [tempDict allKeys]){
                if ([resultString length]>0)
                    [resultString appendString:@"&"];
                [resultString appendFormat:@"%@=%@", key, [tempDict objectForKey:key]];
            }
            NSLog(@"rS:%@",resultString);
            //Add UIAlertView
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:resultString message:resultString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            [self dismissModalViewControllerAnimated:YES];
            
        }
        
        NSLog(@"Dict of errors:%@",tempDict);
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    [request startAsynchronous];
    
}

@end