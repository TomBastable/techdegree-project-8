//
//  BookmarkManager.m
//  Marvel8
//
//  Created by Tom Bastable on 24/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import "BookmarkManager.h"

@implementation BookmarkManager


//MARK: - Init
- (instancetype)init {
    
    //init properties
    self.bookmarks = [[NSMutableArray alloc]init];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    //assign saved bookmarks to instance
    NSMutableArray *bookmarks = [self.userDefaults rm_customObjectForKey:@"bookmarksArray"];
    
    //only assign if bookmarks are not nil
    if (bookmarks != nil){
        self.bookmarks = bookmarks;
    }
    
    return self;
}

//MARK: - Save Bookmarks

-(void)saveBookmarks {
    //save bookmarks to userdefaults
    [self.userDefaults rm_setCustomObject:self.bookmarks forKey:@"bookmarksArray"];
    
}
//MARK: - Update Bookmarks
-(void)updateBookmarks {
    //update the bookmarks - used for going between detailview / view.
    self.bookmarks = [self.userDefaults rm_customObjectForKey:@"bookmarksArray"];
    
}

//MARK: - CanRemoveBookmarkIfBookmarked
//If a bookmark can be removed, remove it and return true. Otherwise return false. (I know this func name sucks - sorry Dennis!

-(void)canRemoveBookmarkIfBookmarked:(id)object completion:(void(^)(BOOL canRemove)) completion{
    
    //check for class
    if ([object isKindOfClass:[ComicBook class]]){
        //set the object to correct class
        ComicBook* comic = object;
        //loop through bookmarks
        int i;
        for (i=0; i < self.bookmarks.count; i++) {
            //get the object at index
            id obj = [self.bookmarks objectAtIndex:i];
            //the the class matches
            if ([obj isKindOfClass:[ComicBook class]]){
                //cast to correct class
                ComicBook *storedComic = obj;
                //check for matching id's
                if (comic.comicId == storedComic.comicId){
                    //remove if true
                    [self.bookmarks removeObject:obj];
                    //completion true
                    completion(true);
                    //return to avoid the final completion of false
                    return;
                }
            
            }
        }
        //check for class
        } else if ([object isKindOfClass:[ComicCharacter class]]){
        //set the object to correct class
            ComicCharacter *comicChar = object;
            //loop through bookmarks
            int i;
            for (i=0; i < self.bookmarks.count; i++) {
                //get the object at index
            id obj = [self.bookmarks objectAtIndex:i];
                //the the class matches
            if ([obj isKindOfClass:[ComicCharacter class]]){
                //cast to correct class
                ComicCharacter *storedChar = obj;
                //check for matching id's
                if (comicChar.charId == storedChar.charId){
                     //remove if true
                    [self.bookmarks removeObject:obj];
                    //completion true
                    completion(true);
                    //return to avoid the final completion of false
                    return;
                }
            
            }
            
        }
        
    }
    //if not in the bookmarks or doesn't conform to either class, return false
    completion(false);
}

//MARK: - IS Bookmarked
//Function to check if a bookmark is bookmarked. Probably could have used this in the func above but as the course is closing soon I need to be quick with the final projects.

-(BOOL)isBookmarked:(id)object{
    //check for class
    if ([object isKindOfClass:[ComicBook class]]){
        //assign to correct class
        ComicBook* comic = object;
        //loop through bookmarks
        for (id obj in self.bookmarks) {
            //if it's a matching class
            if ([obj isKindOfClass:[ComicBook class]]){
                //assign object to correct class
                ComicBook *storedComic = obj;
                // if id's match
                if (comic.comicId == storedComic.comicId){
                    //return true
                    return true;
                    
                }
            
            }
        }
        //check for class
        } else if ([object isKindOfClass:[ComicCharacter class]]){
        //assign to correct class
            ComicCharacter *comicChar = object;
            //loop through bookmarks
        for (id obj in self.bookmarks) {
            //if it's a matching class
            if ([obj isKindOfClass:[ComicCharacter class]]){
                //assign object to correct class
                ComicCharacter *storedChar = obj;
                // if id's match
                if (comicChar.charId == storedChar.charId){
                    //return true
                    return true;
                    
                }
            
            }
            
        }
        
    }
    //else if not found or does not conform to either class return false.
    return false;
}

@end
