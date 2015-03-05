//
//  LoginModel.h
//  RideSharingMap
//
//  Created by Lach, Agata on 04/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface LoginViewModel : NSObject


+(void)inputFirstName:(NSString*) text;
+(void)inputSurname:(NSString*) text;

/* returns TRUE if login was successful */
+(BOOL)log_in:(NSString*) username :(NSString *)password;

+(BOOL)sign_up;




@end