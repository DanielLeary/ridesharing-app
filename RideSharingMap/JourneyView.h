//
//  JourneyView.h
//  RideSharingMap
//
//  Created by Daniel Leary on 12/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JourneyView : UIViewController

@property (weak, nonatomic) NSString *rowID;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
