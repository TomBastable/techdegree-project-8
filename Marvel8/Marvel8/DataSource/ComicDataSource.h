//
//  ComicDataSource.h
//  Marvel8
//
//  Created by Tom Bastable on 23/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ComicCollectionViewCell.h"
#import "ComicBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComicDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *comicArray;
@property (strong, nonatomic) NSCache *imageCache;

-(id) initDataSourceWithArray:(NSMutableArray *)array;
-(void)setNewObject:(NSMutableArray *)comicArray;

@end

NS_ASSUME_NONNULL_END
