//
//  RideSharingMapTests.m
//  RideSharingMapTests
//
//  Created by Vaneet Mehta on 08/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UserModel.h"
#import "LoginViewModel.h"
#import <Parse/Parse.h>


@interface RideSharingMapTests : XCTestCase

@end

@implementation RideSharingMapTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}


- (void)testSignup {
    
    // Create ViewModel instance with UserModel attached
    UserModel* model = [[UserModel alloc] init];
    LoginViewModel* viewModel = [[LoginViewModel alloc] initWithModel:model];
    
    NSString* firstname = @"testFirstName";
    NSString* surname = @"testSurname";
    NSString* username = @"testUser";
    NSString* password = @"incorrectPassword";
    model.firstName = firstname;
    model.lastName = surname;
    
    // Password doesn't have one letter and one number
    XCTAssertEqual([viewModel sign_up:username :password :firstname :surname], PASSWORD_ERROR, @"Issue with password returned incorrect error");
    
    // Set password to correct value and change so firstname doesn't exist
    password = @"c0rrectP4ssword";
    model.firstName= nil;
    XCTAssertEqual([viewModel sign_up:username :password :firstname :surname], NAME_ERROR, @"Issue with signing in without firstname");
    
    // Set firstname to value and remove surname
    model.firstName = @"testFirstName";
    model.lastName = nil;
    XCTAssertEqual([viewModel sign_up:username :password :firstname :surname], SURNAME_ERROR, @"Issue with password returned incorrect error");
    
    // Check that signing in with correct values produces no error
    model.lastName = @"testSurname";
    XCTAssertEqual([viewModel sign_up:username :password :firstname :surname], NO_ERROR, @"Issue with correct values for login");
    
    // try and login as newly Created user and see if that works
    PFUser * testUser = [PFUser logInWithUsername:username password:password];
    XCTAssertNotNil(testUser, @"Issue with loggin in newly created user");
    
    // Try create new user with user name thats already taken
    XCTAssertEqual([viewModel sign_up:username :password :firstname :surname], USERNAME_ERROR, @"Issue with username already in use");
    
    
    
    // Delete the newly created testUser
    if(testUser != nil) {
        [testUser delete];
    }


}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
