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
    
    ProfileViewModel *profileViewModel;
    
}


- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    profileViewModel = [[ProfileViewModel alloc] initWithProfile:user];
    
    if (user) {
        self.name_label.text = profileViewModel.firstNameText;
        self.surname_label.text = profileViewModel.lastNameText;
        //self.profileImageView = [[UIImageView alloc] initWithImage:profileViewModel.profilePictureImage];
    }
}

//temp for testing
- (void) viewDidAppear:(BOOL)animated {
    NSUInteger count = [profileViewModel getInterestsCount];
    NSLog(@"IN INTEREST ARRAY: %lu", (unsigned long)count);
    NSLog(@"interests: %@", [profileViewModel getInterestsArray]);
}


/* METHODS FOR UI RESPONSES */

//segue to AddPlaceViewController
- (IBAction)addNewPlaceButtonPressed:(id)sender {
    AddPlaceViewController *addPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
    addPlaceVC.delegate = self;
    [self.navigationController pushViewController:addPlaceVC animated:YES];
}


/* ADDPLACEVC DELEGATE METHODS */

- (void) addNewPlace:(AddPlaceViewController *)vc place:(Place *)place {
    [profileViewModel addPlace:place];
    [self.placesTableView reloadData];
}

- (void) editPlace:(AddPlaceViewController *)vc atIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [profileViewModel replacePlaceAtIndex:indexPath withPlace:place];
    [self.placesTableView reloadData];
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [profileViewModel getFavPlacesCount] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < [profileViewModel getFavPlacesCount]) {
        cell.textLabel.text = [[profileViewModel getPlaceAtIndex:indexPath.row] name];
    } else {
        cell.textLabel.text = @"+ Add new place";
    }
    return cell;
}

// upon row selection, go to editPlaceVC for selected Place
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [profileViewModel getFavPlacesCount]) {
        // set up editPlaceVC
        AddPlaceViewController *editPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
        editPlaceVC.delegate = self;
        editPlaceVC.editing = YES;
        editPlaceVC.placeIndexPath = indexPath.row;
        // update editPlaceVC for selected place
        Place *place = [profileViewModel getPlaceAtIndex:indexPath.row];
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
        [profileViewModel removePlaceAtIndex:[indexPath row]];
        // delete row from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// function to drag move rows in placesTableView
- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    Place *mover = [profileViewModel getPlaceAtIndex:[fromIndexPath row]];
    [profileViewModel removePlaceAtIndex:[fromIndexPath row]];
    [profileViewModel insertPlace:mover atIndex:[toIndexPath row]];
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
