//
//  ViewController.m
//  Marvel8
//
//  Created by Tom Bastable on 21/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import "ViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

#define reuseIdentifier @"comicCell"

@interface ViewController ()

@end

@implementation ViewController

// MARK:- ViewdidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //General property initialisation
    self.imageCache = [[NSCache alloc]init];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.bookmarkManager = [[BookmarkManager alloc]init];
    self.client = [[MarvelAPIClient alloc]init];
    
    // Setup Navbar UI
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    // initialise an activity indicator for the UINV
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].leftBarButtonItem = barButton;
    self.activityIndicator.alpha = 0.0;
    
    // Add a long press gesture recogniser to the collection view (For Bookmarking functionality).
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
    
    //Display comic list.
    [self displayComicsWithOffset:[NSNumber numberWithInt:0]];
    
}

// MARK:- ViewdidLoad

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:true];
    //Update bookmarks - to reflect any new bookmarks created in the detailview
    [self.bookmarkManager updateBookmarks];
    
    //re-display bookmarks
    if (self.segmentedControl.selectedSegmentIndex == 2){
        [self displayBookmarks];
    }
}

//MARK: - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.liveArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //initialise cell (Same cell for both classes)
    ComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //empty the cell image to avoid messy loads
    cell.imageView.image = nil;
    //properties that will be assigned depending on class
    NSString *title;
    NSString *thumbnailURL;
    
    //assign properties based on class - be it ComicBook or Character.
    if ([[self.liveArray objectAtIndex:indexPath.row] isKindOfClass:[ComicBook class]]){

        ComicBook *comic = [self.liveArray objectAtIndex:indexPath.row];
        title = comic.comictitle;
        thumbnailURL = comic.thumbnailURLString;
        
    }else if ([[self.liveArray objectAtIndex:indexPath.row] isKindOfClass:[ComicCharacter class]]){
  
        ComicCharacter *comicChar = [self.liveArray objectAtIndex:indexPath.row];
        title = comicChar.name;
        thumbnailURL = comicChar.thumbnailURLString;
        
    }
    
    //set title
    cell.comicTitle.text = title;
    
    //Potentially cached image
    UIImage *cachedImage = [self.imageCache objectForKey:thumbnailURL];
    
    //Check if chached image is nil
    if (!cachedImage){
        
        //If cached image is nil, download image and cache image so that multiple downloads are not required. Check if image in nil, if so apply an error indicative image.
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnailURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                
                if(image){
                //set image
                cell.imageView.image = image;
                //cache image
                [self.imageCache setObject:image forKey:thumbnailURL];
                }else{
                    cell.imageView.image = [UIImage imageNamed:@"error"];
                }
            });
            
        });
        
    } else if (cachedImage){
        //Set the cached image, if there is a cached image present
        cell.imageView.image = cachedImage;
        
    }
    
    //Check to see if the object is already bookmarked
    if ([self.bookmarkManager isBookmarked:[self.liveArray objectAtIndex:indexPath.row]]){
        //if it is, display the bookmarked icon
        cell.bookmarkIcon.alpha = 1.0;
    }else{
        //if it isn't, ensure the icon is hidden
        cell.bookmarkIcon.alpha = 0.0;
    }
    
    //Check to see if the last cell has been created - if it has, download more results.
    if (indexPath.row+1 == self.liveArray.count){
        
        //Last cell has been loaded - load more results.
        if (self.segmentedControl.selectedSegmentIndex == 0){
            NSLog(@"comicbook");
            [self displayComicsWithOffset:[NSNumber numberWithLong:self.liveArray.count]];
            
        } else if (self.segmentedControl.selectedSegmentIndex == 1){
            NSLog(@"comiccharacter");
            [self displayCharsWithOffset:[NSNumber numberWithLong:self.liveArray.count]];
            
        } else{
            NSLog(@"bookmarks");
            //do nothing
        }
        
    }
    
    return cell;
}

//MARK: - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailSegue"]) {
        //get cell
        ComicCollectionViewCell *cell = (ComicCollectionViewCell *) sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        //get selected object
        id obj = [self.liveArray objectAtIndex:[indexPath row]];
        // set view controller and pass object and image.
        DetailViewController *vc = [segue destinationViewController];
        vc.object = obj;
        vc.passedImage = cell.imageView.image;
    }
}

//MARK: - Segmented Control IBAction

- (IBAction)segmentedControlChanged:(id)sender {
    
    //comics
    if (self.segmentedControl.selectedSegmentIndex == 0){
        
        [self displayComicsWithOffset:0];
        
    //characters
    } else if (self.segmentedControl.selectedSegmentIndex == 1){
        
        [self displayCharsWithOffset:0];
        
    //bookmarks
    }else if (self.segmentedControl.selectedSegmentIndex == 2){
        
        [self displayBookmarks];
        
    }
    
}

// MARK:- Display Comics
// Makes an API call and returns an array that has been modelled correctly. Then displays that data in the view controller.
-(void)displayComicsWithOffset:(NSNumber *)offset {
    
    //Make view indicate the update
    [self viewIsUpdating];
    
    //call API
    [self.client comicsWithOffset:offset completion:^(NSMutableArray<ComicBook *> * _Nonnull comicArray, NSError * _Nonnull error) {
        
        //Check for error
        if (error) {
            //Display an error
            dispatch_async(dispatch_get_main_queue(), ^ {
            NSLog(@"error");
            [self viewHasFinishedUpdating];
                [self displayError:error];
                });
        }else{
        //check for valid offset
        int offsetInt = [offset intValue];
        if (offsetInt != 0){
            //If the offset is more than zero, add the objects
            NSLog(@"one %@", offset);
            [self.liveArray addObjectsFromArray:comicArray];
        }else if (offsetInt == 0){
            NSLog(@"two");
            // if the offset is zero, assign the array instead.
            self.liveArray = comicArray;
        }
        //reload collection view and inidicate the view has finished loading
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.collectionView reloadData];
            [self viewHasFinishedUpdating];
        });
            
        }
    }];
    
}

// MARK:- Display Characters
// Makes an API call and returns an array that has been modelled correctly. Then displays that data in the view controller.
-(void)displayCharsWithOffset:(NSNumber *)offset {
    
    [self viewIsUpdating];
    
    [self.client charactersWithOffset:offset completion:^(NSMutableArray<ComicCharacter *> * _Nonnull charArray, NSError * _Nonnull error) {
        
        //Check for error
       if (error) {
           //Display an error
           dispatch_async(dispatch_get_main_queue(), ^ {
               NSLog(@"error");
               [self viewHasFinishedUpdating];
               [self displayError:error];
           });
           
       }else{
           //check for valid offset
        int offsetInt = [offset intValue];
        if (offsetInt != 0){
            //If the offset is more than zero, add the objects
            NSLog(@"one %@", offset);
            [self.liveArray addObjectsFromArray:charArray];
        }else if (offsetInt == 0){
            NSLog(@"two");
            // if the offset is zero, assign the array instead.
           self.liveArray = charArray;
        }
        //reload collection view and inidicate the view has finished loading
        dispatch_async(dispatch_get_main_queue(), ^ {
        [self.collectionView reloadData];
        [self viewHasFinishedUpdating];
        });
           
       }
    }];
    
}

// MARK:- Display Bookmarks
// Makes an API call and returns an array that has been modelled correctly. Then displays that data in the view controller.
-(void)displayBookmarks {
    
    //indicate the view is updating
    [self viewIsUpdating];
    //remove objects
    [self.liveArray removeAllObjects];
    //set bookmarks to live from the bookmark manager
    self.liveArray = self.bookmarkManager.bookmarks;
    
    //reload collection view and indicate the view has finished loading
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.collectionView reloadData];
        [self viewHasFinishedUpdating];
    });
    
}

// MARK:- View is updating
//This displays the activity indicator in the Nav bar and disables the segemented control.

-(void)viewIsUpdating {
    
    [self.segmentedControl setEnabled:false];
    self.activityIndicator.alpha = 1.0;
    [self.activityIndicator startAnimating];
    
}

// MARK:- View Has Finished Updating
//This hides the activity indicator in the Nav bar and enables the segemented control.

-(void)viewHasFinishedUpdating {
    
    self.activityIndicator.alpha = 0.0;
    [self.activityIndicator stopAnimating];
    [self.segmentedControl setEnabled:true];
    
}

// MARK:- Gesture Recogniser Method
//Handles Long touches - in this case it bookmarks and unbookmarks objects.

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    //Find co-ordinate of long press and convert to an IndexPath from the collectionview.
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    //Check for invalid indexpath
    if (indexPath == nil){
        
        NSLog(@"couldn't find index path");
        
    } else {
        
        //remove bookmark if object is bookmarked
        [self.bookmarkManager canRemoveBookmarkIfBookmarked:[self.liveArray objectAtIndex:indexPath.row] completion:^(BOOL canRemove) {
            
            //if bookmark wasn't removed
            if (!canRemove) {
                
                //it means it wasn't bookmarked - so bookmark it!
                [self.bookmarkManager.bookmarks addObject:[self.liveArray objectAtIndex:indexPath.row]];
                
            }
            //save bookmarks and reload the collectionview
            [self.bookmarkManager saveBookmarks];
            dispatch_async(dispatch_get_main_queue(), ^ {
            [self.collectionView reloadData];
            });
        }];
    }
}

// MARK:- Display Error
// Display a UIAlert displaying Error details. Common errors displayed in plain text. Uncommon errors will display raw.

-(void)displayError:(NSError *)error{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]
                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
