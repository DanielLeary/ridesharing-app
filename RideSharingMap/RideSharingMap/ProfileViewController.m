//
//  ProfileViewController.m
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewController.h"

static const CLLocationCoordinate2D imperialCoord = {51.498639, -0.179344};

@implementation ProfileViewController {
    
    UserViewModel *viewModel;
    
}


- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    viewModel = [[UserViewModel alloc] initWithModel:user];
    
    if (user) {
        self.firstNameLabel.text = [viewModel getFirstName];
        self.lastNameLabel.text = [viewModel getLastName];
        //self.profileImageView = [[UIImageView alloc] initWithImage:profileViewModel.profilePictureImage];
    }
}

//temp for testing
- (void) viewDidAppear:(BOOL)animated {
    NSUInteger count = [viewModel getInterestsCount];
    NSLog(@"IN INTEREST ARRAY: %lu", (unsigned long)count);
    NSLog(@"interests: %@", [viewModel getInterestsArray]);
}


/* METHODS FOR UI RESPONSES */

- (IBAction)logoutBarButtonPressed:(UIBarButtonItem *)sender {
    //need to clear user info?
    [viewModel logOut];
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    appDelegateTemp.window.rootViewController = loginVC;
}

- (IBAction)addNewPlaceButtonPressed:(id)sender {
    //segue to AddPlaceViewController
    AddPlaceViewController *addPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
    addPlaceVC.delegate = self;
    [self.navigationController pushViewController:addPlaceVC animated:YES];
}

- (IBAction)editProfileButtonPressed:(UIBarButtonItem *)sender {
    EditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    editProfileVC.delegate = self;
    [self.navigationController pushViewController:editProfileVC animated:YES];
}


/* ADDPLACEVC DELEGATE METHODS */

- (void) addNewPlace:(AddPlaceViewController *)vc place:(Place *)place {
    [viewModel addPlace:place];
    [self.placesTableView reloadData];
}

- (void) editPlace:(AddPlaceViewController *)vc atIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [viewModel replacePlaceAtIndex:indexPath withPlace:place];
    [self.placesTableView reloadData];
}


/* EDITPROFILEVC DELEGATE METHODS */

- (void) updateProfileImage:(EditProfileViewController *)vc image:(UIImage *)image {
    //[profileViewModel setProfilePicture:image];
    [self.profileImageView reloadInputViews];
}

- (void) updateProfileName:(EditProfileViewController *)vc firstName:(NSString *)firstName lastName:(NSString *)lastName {
    self.firstNameLabel.text = firstName;
    self.lastNameLabel.text = lastName;
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [viewModel getFavPlacesCount] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < [viewModel getFavPlacesCount]) {
        cell.textLabel.text = [[viewModel getPlaceAtIndex:indexPath.row] name];
    } else {
        cell.textLabel.text = @"+ Add new place";
    }
    return cell;
}

// upon row selection, go to editPlaceVC for selected Place
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [viewModel getFavPlacesCount]) {
        // set up editPlaceVC
        AddPlaceViewController *editPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
        editPlaceVC.delegate = self;
        editPlaceVC.editing = YES;
        editPlaceVC.placeIndexPath = indexPath.row;
        // update editPlaceVC for selected place
        Place *place = [viewModel getPlaceAtIndex:indexPath.row];
        [editPlaceVC view];
        editPlaceVC.placeNameField.text = place.name;
        editPlaceVC.placeLocationField.text = place.zipcode;
        MKCoordinateRegion region;
        if (CLLocationCoordinate2DIsValid(place.coordinates)) {
            region = MKCoordinateRegionMakeWithDistance(place.coordinates, 500, 500);
            [editPlaceVC.mapView setRegion:region animated:YES];
        } else {
            // hardcode location for now
            NSLog(@"hardcoded location");
            region = MKCoordinateRegionMakeWithDistance(imperialCoord, 500, 500);
            [editPlaceVC.mapView setRegion:region animated:YES];
        }
        [self.navigationController pushViewController:editPlaceVC animated:YES];
    } else {
        AddPlaceViewController *addPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
        addPlaceVC.delegate = self;
        addPlaceVC.editing = NO;
        [self.navigationController pushViewController:addPlaceVC animated:YES];
    }
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
        [viewModel removePlaceAtIndex:[indexPath row]];
        // delete row from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// function to drag move rows in placesTableView
- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    Place *mover = [viewModel getPlaceAtIndex:[fromIndexPath row]];
    [viewModel removePlaceAtIndex:[fromIndexPath row]];
    [viewModel insertPlace:mover atIndex:[toIndexPath row]];
}

/* FUNCTIONS FOR PROFILE PICTURE */




- (IBAction)inputCar:(id)sender {
    NSLog(@"edited Car");
    PFUser *currentUser = [PFUser currentUser];
    // If user is currently signed in
    if(currentUser) {
        NSLog(currentUser.username);
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
