//
//  DetailViewController.h
//  ios-learnable-final
//
//  Created by Mal Curtis on 11/07/12.
//  Copyright (c) 2012 Learnable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
