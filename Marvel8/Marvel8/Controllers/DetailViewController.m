//
//  DetailViewController.m
//  Marvel8
//
//  Created by Tom Bastable on 24/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import "DetailViewController.h"

#define reuseIdentifier @"comicCell"

@interface DetailViewController ()

@end

@implementation DetailViewController

//MARK: - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.client = [[MarvelAPIClient alloc]init];
    self.liveArray = [[NSMutableArray alloc]init];
    self.bookmarkManager = [[BookmarkManager alloc]init];
    self.imageCache = [[NSCache alloc]init];
    
    // initialise an activity indicator for the UINV
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    self.activityIndicator.alpha = 0.0;
    
    // Add a long press gesture recogniser to the collection view (For Bookmarking functionality).
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
    
    //Setup the view with the object - can be re-used upon touch.
    [self setupViewWithFreshObject];
    
}

//MARK: - Setup View With Object
//This can be recalled upon touches - set the object and call.

-(void)setupViewWithFreshObject{
    
    //Indicate the view is updating in the UI.
    [self viewIsUpdating];
    //Set passed images
    self.objectThumbnail.image = self.passedImage;
    self.backgroundImageView.image = self.passedImage;
    //determine if the object is a Comic Book or Character.
    if ([self.object isKindOfClass:[ComicBook class]]){
        //Set the relevant classes properties
        ComicBook *comic = self.object;
        if ([comic.comictitle class] != [NSNull class]) { self.objectTitle.text = comic.comictitle; } else {self.objectDescription.text = @"";}
        if ([comic.comicDescription class] != [NSNull class]) { self.objectDescription.text = comic.comicDescription; } else {self.objectDescription.text = @"";}
        //call the api with the comicId (FYI - [NSNull class] was the only way I could catch empty properties.
        if (comic.comicId > 0) { [self getCharacterAppearancesWithComicId:comic.comicId]; } else {self.objectDescription.text = @"";}
        
    }else if ([self.object isKindOfClass:[ComicCharacter class]]){
        //set the relevant classes properties
        ComicCharacter *comicChar = self.object;
        if ([comicChar.name class] != [NSNull class]) { self.objectTitle.text = comicChar.name; } else {self.objectDescription.text = @"";}
        if ([comicChar.charDescription class] != [NSNull class]) { self.objectDescription.text = comicChar.charDescription; } else {self.objectDescription.text = @"";}
        //cal the api with the charId (Same as above RE: NSNULL)
        if (comicChar.charId > 0) { [self getComicsAppearedInWithCharacterId:comicChar.charId]; }
        
    }
}

//MARK: - Collection View Data Source

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
        
        //If cached image is nil, download image and cache image so that multiple downloads are not required.
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
                    //set stock image in the case of an error
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
        
    }
    
    return cell;
}

//MARK: - Collection View Delegate
// Deals with selected cells

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //get the cell
    ComicCollectionViewCell *cell = (ComicCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    //get the selected object
    id obj = [self.liveArray objectAtIndex:indexPath.row];
    //set the object and image
    self.object = obj;
    self.passedImage = cell.imageView.image;
    //setup view
    [self setupViewWithFreshObject];
    
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

//MARK: - View Is Updating

-(void)viewIsUpdating {
    
    //set chosen UI objects to indicate the view is loading
    self.objectTitle.alpha = 0.0;
    self.objectDescription.alpha = 0.0;
    self.objectThumbnail.alpha = 0.0;
    self.collectionView.alpha = 0.0;
    self.activityIndicator.alpha = 1.0;
    self.bookmarkedIcon.alpha = 0.0;
    [self.activityIndicator startAnimating];
    //scroll to the top
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    
}

//MARK: - View Has Finished Updating

-(void)viewHasFinishedUpdating {
    
    //set chosen UI objects to indicate the view has loaded.
    self.collectionView.alpha = 1.0;
    self.objectThumbnail.alpha = 1.0;
    self.activityIndicator.alpha = 1.0;
    self.objectTitle.alpha = 1.0;
    self.objectDescription.alpha = 1.0;
    [self.activityIndicator stopAnimating];
    //check for bookmark
    if ([self.bookmarkManager isBookmarked:self.object]){ self.bookmarkedIcon.alpha = 1.0; }
    
}

//MARK: - Get Character Appearances

-(void)getCharacterAppearancesWithComicId:(NSNumber *)comicId {
    // call API
    [self.client charactersRelatedTo:comicId withOffset:[NSNumber numberWithInt:0] completion:^(NSMutableArray<ComicCharacter *> * _Nonnull charArray, NSError * _Nonnull error) {
       
        //If there isn't an error
        if (error == nil){
            
            //set the array
            self.liveArray = charArray;
            //reload collection view
            dispatch_async(dispatch_get_main_queue(), ^ {
            [self.collectionView reloadData];
                // indicate the view had loaded
            [self viewHasFinishedUpdating];
            });
            
        // check error
        }else if (error){
            
            //display error
            [self displayError:error];
            
        }
        
    }];
}

//MARK: - Get Comics A Character Appeared In

-(void)getComicsAppearedInWithCharacterId:(NSNumber *)charId {
    // call API
    [self.client comicsRelatedTo:charId withOffset:[NSNumber numberWithInt:0] completion:^(NSMutableArray<ComicBook *> * _Nonnull charArray, NSError * _Nonnull error) {
       //If there isn't an error
        if (error == nil){
            //set the array
            self.liveArray = charArray;
            //reload collection view
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.collectionView reloadData];
                // indicate the view had loaded
                [self viewHasFinishedUpdating];
            });
        // check error
        }else if (error){
            
            //display error
            [self displayError:error];
            
        }
        
    }];
    
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
