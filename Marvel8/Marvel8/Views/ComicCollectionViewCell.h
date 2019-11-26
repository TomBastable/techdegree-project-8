//
//  ComicCollectionViewCell.h
//  Marvel8
//
//  Created by Tom Bastable on 23/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComicCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *comicTitle;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkIcon;

@end

NS_ASSUME_NONNULL_END
