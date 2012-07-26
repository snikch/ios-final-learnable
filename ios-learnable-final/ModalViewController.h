//
//  ModalViewController.h
//  ios-learnable-final
//
//  Created by Mal Curtis on 11/07/12.
//  Copyright (c) 2012 Learnable. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SantiappsHelper.h"
//#import "PopoverViewController.h"

@interface ModalViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    IBOutlet UIButton *registerUser;
    IBOutlet UIButton *loginUser;
    IBOutlet UITextField *userName;
    IBOutlet UITextField *userPass;
    IBOutlet UITextField *userEmail;
    UIImageView *pickedImage;
    
    NSURLConnection *myConnection;
    NSMutableData *incomingPostData;
    
    //for image picking
    UIImagePickerController* imagePickerController;
    UIPopoverController *popoverController;
    IBOutlet UIView *myView;
    
}
@property (nonatomic,retain) NSURLConnection *myConnection;
@property (nonatomic,retain) NSMutableData *incomingPostData;
@property (nonatomic,retain) IBOutlet UIButton *registerUser;
@property (nonatomic,retain) IBOutlet UIButton *loginUser;
@property (nonatomic,retain) IBOutlet UITextField *userName;
@property (nonatomic,retain) IBOutlet UITextField *userPass;
@property (nonatomic,retain) IBOutlet UITextField *userEmail;
@property (nonatomic,retain) UIImageView *pickedImage;

//for image picking
@property (nonatomic,retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIView *myView;


- (IBAction)setPic;
-(IBAction)userWillLogIn;
-(IBAction)userWillRegister;
-(NSDictionary*)addUser:(NSString *)usuario withPass:(NSString *)clave withAddress:(NSString*)direccion;
-(NSString*)checkUserLogin:(NSString *)loginUsuario withPass:(NSString *)loginClave;

//for image picking
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
@end
