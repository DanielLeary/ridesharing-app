//
//  ProfileViewController.m
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController {
    
    NSMutableArray *placesArray;
    
}


- (void) viewDidLoad {
    [super viewDidLoad];
    placesArray = [[NSMutableArray alloc] initWithObjects:@"Home", @"Work", nil];
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [placesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [placesArray objectAtIndex:indexPath.row];
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

- (void) addNewPlace:(AddPlaceViewController *)vc withName:(NSString *)placeName andCoord:(CLLocationCoordinate2D)placeCoord {
    [placesArray addObject:placeName];
    [self.placesTableView reloadData];
}

- (void)editPlace:(AddPlaceViewController *)vc withName:(NSString *)placeName andCoord:(CLLocationCoordinate2D)placeCoord {
    
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
        [placesArray removeObjectAtIndex:[indexPath row]];
        // delete row from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// function to drag move rows in placesTableView
- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    NSString *mover = [placesArray objectAtIndex:[fromIndexPath row]];
    [placesArray removeObjectAtIndex:[fromIndexPath row]];
    [placesArray insertObject:mover atIndex:[toIndexPath row]];
    [tableView setEditing:NO animated:YES];
}



@end
