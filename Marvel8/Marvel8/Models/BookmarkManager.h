//
//  BookmarkManager.h
//  Marvel8
//
//  Created by Tom Bastable on 24/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComicBook.h"
#import "ComicCharacter.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookmarkManager : NSObject

@property (strong, nonatomic) NSMutableArray *bookmarks;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

-(void)canRemoveBookmarkIfBookmarked:(id)object completion:(void(^)(BOOL canRemove)) completion;
-(BOOL)isBookmarked:(id)object;
-(void)saveBookmarks;
-(void)updateBookmarks;

@end

NS_ASSUME_NONNULL_END
