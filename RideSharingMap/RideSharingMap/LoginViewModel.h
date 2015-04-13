//
//  LoginModel.h
//  RideSharingMap
//
//  Created by Lach, Agata on 04/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "UserModel.h"

#define NO_ERROR 0
#define NAME_ERROR 1
#define SURNAME_ERROR 2
#define USERNAME_ERROR 3
#define PASSWORD_ERROR 4


@interface LoginViewModel : NSObject

@property (strong, nonatomic) UserModel *model;
-(instancetype)initWithModel:(UserModel *) model;
-(void)inputFirstName:(NSString*) text;
-(void)inputSurname:(NSString*) text;
-(void)changeSex:(NSString*) text;
-(void)changePosition:(NSString*) text;
-(void)changePicture:(UIImage*) picture;
/* returns TRUE if login was successful */
-(BOOL)log_in:(NSString*) username :(NSString *)password;
-(int)sign_up:(NSString*)username :(NSString*)password :(NSString*)name : (NSString*)surname;

- (int) checkForSignupErrors:(NSString *)firstName andLastName:(NSString *)lastName andPassword:(NSString *)password;


@end
