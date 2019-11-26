//
//  Endpoint.h
//  Marvel8
//
//  Created by Tom Bastable on 21/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+MD5.h"

NS_ASSUME_NONNULL_BEGIN

@interface Endpoint : NSObject

-(NSURL *)characterDataUrlWithOffset:(NSNumber *)offset;
-(NSURL *)relatedComicsWithCharId:(NSNumber *)charId andOffset:(NSNumber *)offset;
-(NSURL *)comicDataUrlWithOffset:(NSNumber *)offset;
-(NSURL *)relatedCharacrersWithComicId:(NSNumber *)comicId andOffset:(NSNumber *)offset;



@end

NS_ASSUME_NONNULL_END
