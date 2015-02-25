//
//  InitialViewController.h
//  RideSharingMap
//
//  Created by Lach, Agata on 25/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface InitialViewController : UIViewController{
    PFUser *currentUser;
    __weak IBOutlet UILabel *logLabel;
}
- (IBAction)logout:(id)sender;

@end
