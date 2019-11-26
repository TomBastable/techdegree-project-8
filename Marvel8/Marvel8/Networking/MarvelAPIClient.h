//
//  MarvelAPIClient.h
//  Marvel8
//
//  Created by Tom Bastable on 22/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComicCharacter.h"
#import "JSONDownloader.h"
#import "Endpoint.h"
#import "ComicBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarvelAPIClient : NSObject


-(void)charactersWithOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicCharacter *> *charArray, NSError *error)) completion;
-(void)charactersRelatedTo:(NSNumber *)comicId withOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicCharacter *> *charArray, NSError *error)) completion;
-(void)comicsWithOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicBook *> *charArray, NSError *error)) completion;
-(void)comicsRelatedTo:(NSNumber *)charId withOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicBook *> *charArray, NSError *error)) completion;


@end

NS_ASSUME_NONNULL_END
