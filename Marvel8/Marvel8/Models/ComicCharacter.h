//
//  ComicCharacter.h
//  Marvel8
//
//  Created by Tom Bastable on 22/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComicCharacter : NSObject

@property NSString *name;
@property NSNumber *charId;
@property NSString *charDescription;
@property NSString *thumbnailURLString;

@end

NS_ASSUME_NONNULL_END
