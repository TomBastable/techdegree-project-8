//
//  JSONDownloader.m
//  Marvel8
//
//  Created by Tom Bastable on 22/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import "JSONDownloader.h"

@implementation JSONDownloader

//Basic JSON Downloader that takes a URL as an input. Not much to comment - same as my swift version essentially.

+(void)requestWithEndpoint:(NSString *)endpointString completion:(void(^)(NSArray *JSONArray, NSError *error))completion {
    
    NSURL *url = [NSURL URLWithString:endpointString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        
        if (data != nil) {
            
            NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary *JSONResponse = [JSONDict valueForKey:@"data"];
            NSArray *JSONResults = [JSONResponse valueForKey:@"results"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(JSONResults, nil);
            }];
            
        } else {
            
            completion(nil, error);
            
        }
        
    }];
    
    [task resume];
}

@end
