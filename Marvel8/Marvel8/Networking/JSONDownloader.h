//
//  JSONDownloader.h
//  Marvel8
//
//  Created by Tom Bastable on 22/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSONDownloader : NSObject

+(void)requestWithEndpoint:(NSString *)endpointString completion:(void(^)(NSArray *JSONArray, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
