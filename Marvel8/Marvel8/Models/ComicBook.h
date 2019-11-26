//
//  ComicBook.h
//  Marvel8
//
//  Created by Tom Bastable on 22/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Endpoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComicBook : NSObject

@property NSString *comictitle;
@property NSString *comicDescription;
@property NSString *thumbnailURLString;
@property NSNumber *comicId;

@end

NS_ASSUME_NONNULL_END
