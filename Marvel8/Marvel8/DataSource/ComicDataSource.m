//
//  ComicDataSource.m
//  Marvel8
//
//  Created by Tom Bastable on 23/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import "ComicDataSource.h"

#define reuseIdentifier @"comicCell"

@implementation ComicDataSource

-(id) initDataSourceWithArray:(NSMutableArray *)array
        
{
    if (self = [super init]) {
        self.comicArray = array;
    }
    
    return self;
}

-(void)setNewObject:(NSMutableArray *)comicArray {

    self.comicArray = comicArray;
    NSLog(@"%@", self.comicArray);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"test");
    return self.comicArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tesst");
    ComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ComicBook *comic = [self.comicArray objectAtIndex:indexPath.row];
    
    cell.comicTitle.text = comic.comictitle;
    
    UIImage *cachedImage = [self.imageCache objectForKey:comic.thumbnailURLString];
    
    if (!cachedImage){
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:comic.thumbnailURLString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                
                cell.imageView.image = image;
                [self.imageCache setObject:image forKey:comic.thumbnailURLString];
            });
            
        });
        
    } else if (cachedImage){
        NSLog(@"hello");
        cell.imageView.image = cachedImage;
        
    }
    
    
    return cell;
}

@end
