//
//  ProfileViewController.m
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    self.profileViewModel = [[ProfileViewModel alloc] initWithProfile:user];
    
    if (user) {
        self.username_label.text = self.profileViewModel.usernameText;
        self.name_label.text = self.profileViewModel.firstNameText;
        self.surname_label.text = self.profileViewModel.lastNameText;
        self.carField.text = self.profileViewModel.carText;
    }
    
    /*
    // Create currentUser object from locally cached user
    PFUser *currentUser = [PFUser currentUser];
    // If user is currently signed in
    if(currentUser) {
        // Set the name_label to the current users username
        _username_label.text = currentUser.username;
        if(currentUser[@"Car"] != nil){
            _carField.text = currentUser[@"Car"];
            
        }
        if(currentUser[@"Name"] != nil){
            _name_label.text = currentUser[@"Name"];
            
        }
        if(currentUser[@"Surname"] != nil){
            _surname_label.text = currentUser[@"Surname"];
            
        }
    }*/
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.profileViewModel getFavPlacesCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.profileViewModel getPlaceAtIndex:indexPath.row] getName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddPlaceViewController *editPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
    editPlaceVC.delegate = self;
    editPlaceVC.editing = YES;
    // set up editPlaceVC for selected place
    NSString *placeName = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    [editPlaceVC view];
    editPlaceVC.placeNameField.text = placeName;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(51.498639, -0.179344);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [editPlaceVC.mapView setRegion:region animated:YES];
    [self.navigationController pushViewController:editPlaceVC animated:YES];
}


/* METHODS FOR UI RESPONSES */

//segue to AddPlaceViewController
- (IBAction)addNewPlaceButtonPressed:(id)sender {
    AddPlaceViewController *addPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
    addPlaceVC.delegate = self;
    [self.navigationController pushViewController:addPlaceVC animated:YES];
}


/* ADDPLACEVC DELEGATE METHODS */

- (void) addNewPlace:(AddPlaceViewController *)vc withName:(NSString *)placeName andCoord:(CLLocationCoordinate2D *)placeCoord {
    //lose object after function ends?.....
    Place *place = [[Place alloc] initWithName:placeName andCoordinates:placeCoord];
    [self.profileViewModel addPlace:place];
    [self.placesTableView reloadData];
}

- (void)editPlace:(AddPlaceViewController *)vc withName:(NSString *)placeName andCoord:(CLLocationCoordinate2D *)placeCoord {
    
}


/* METHODS FOR EDITING THE TABLE */

- (IBAction)editButtonPressed:(id)sender {
    if ([_editPlacesButton.currentTitle isEqualToString:@"Edit"]) {
        [self setEditing:YES animated:YES];
    } else if ([_editPlacesButton.currentTitle isEqualToString:@"Done"]) {
        [self setEditing:NO animated: YES];
    }
}

// function to initiate editing mode in placesTableView
-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.placesTableView setEditing:editing animated:animated];
    if (editing == YES) {
        [_editPlacesButton setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [_editPlacesButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

// function to mark editing style as delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// function to delete rows from placesTableView
- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete the row from data source
        [self.profileViewModel removePlaceAtIndex:[indexPath row]];
        // delete row from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// function to drag move rows in placesTableView
- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    Place *mover = [self.profileViewModel getPlaceAtIndex:[fromIndexPath row]];
    [self.profileViewModel removePlaceAtIndex:[fromIndexPath row]];
    [self.profileViewModel insertPlace:mover atIndex:[toIndexPath row]];
}



- (IBAction)inputCar:(id)sender {
    NSLog(@"edited Car");
    PFUser *currentUser = [PFUser currentUser];
    // If user is currently signed in
    if(currentUser) {
        NSLog(_carField.text);
        NSLog(currentUser.username);
        currentUser[@"Car"] = _carField.text;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
    }

}
@end
