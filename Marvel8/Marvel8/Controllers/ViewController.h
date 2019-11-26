//
//  ViewController.h
//  Marvel8
//
//  Created by Tom Bastable on 21/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarvelAPIClient.h"
#import "ComicCollectionViewCell.h"
#import "BookmarkManager.h"
#import "DetailViewController.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *comicArray;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) NSMutableArray *liveArray;
@property (strong, nonatomic) NSMutableArray *charArray;
@property (strong, nonatomic) MarvelAPIClient *client;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) BookmarkManager *bookmarkManager;

@end

