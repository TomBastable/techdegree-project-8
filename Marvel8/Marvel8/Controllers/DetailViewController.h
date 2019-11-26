//
//  DetailViewController.h
//  Marvel8
//
//  Created by Tom Bastable on 24/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkManager.h"
#import "ComicBook.h"
#import "ComicCharacter.h"
#import "ComicCollectionViewCell.h"
#import "MarvelAPIClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *objectTitle;
@property (weak, nonatomic) IBOutlet UILabel *objectDescription;
@property (weak, nonatomic) IBOutlet UIImageView *objectThumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkedIcon;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) id object;
@property (strong, nonatomic) NSMutableArray *liveArray;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) BookmarkManager *bookmarkManager;
@property (strong, nonatomic) MarvelAPIClient *client;
@property (strong, nonatomic) UIImage *passedImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END
