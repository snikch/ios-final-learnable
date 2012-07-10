//
//  MasterViewController.h
//  ios-learnable-final
//
//  Created by Mal Curtis on 11/07/12.
//  Copyright (c) 2012 Learnable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
