//
//  Endpoint.m
//  Marvel8
//
//  Created by Tom Bastable on 21/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import "Endpoint.h"

#define publicKey @"57c2219fa6dbfd47bb7a8a481663e6ae"
#define privateKey @"6245e64e2ad1dbe197716e1a033a2834d945168b"

@implementation Endpoint

//MARK: - Character Endpoint

-(NSURL *)characterDataUrlWithOffset:(NSNumber *)offset  {
    
    //assign base url
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://gateway.marvel.com:443/v1/public/characters"];
    
    //Apply query items (Key, Hash, Timestamp, Offset)
    components.queryItems = [self getQueryItemsWithOffset:offset];
    
    //return query url
    return components.URL;
    
};

//MARK: - Character Related Comics Endpoint

-(NSURL *)relatedComicsWithCharId:(NSNumber *)charId andOffset:(NSNumber *)offset  {
    
    //assign base url
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"https://gateway.marvel.com:443/v1/public/characters/%@/comics", charId]];
    
    //apply query items (Key, Hash, Timestamp, Offset)
    components.queryItems = [self getQueryItemsWithOffset:offset];
    
    //return query url
    return components.URL;
    
};

//MARK: - Comic Endpoint

-(NSURL *)comicDataUrlWithOffset:(NSNumber *)offset{
    
    //assign base url
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://gateway.marvel.com:443/v1/public/comics"];
    
    //Apply query items (Key, Hash, Timestamp, Offset)
    components.queryItems = [self getQueryItemsWithOffset:offset];
    
    //return query url
    return components.URL;
    
};

//MARK: - Related Characters to Comic Endpoint

-(NSURL *)relatedCharacrersWithComicId:(NSNumber *)comicId andOffset:(NSNumber *)offset {
    
    //assign base url
    NSURLComponents *components = [NSURLComponents componentsWithString:[NSString stringWithFormat:@"https://gateway.marvel.com:443/v1/public/comics/%@/characters", comicId]];
    
    //Apply query items (Key, Hash, Timestamp, Offset)
    components.queryItems = [self getQueryItemsWithOffset:offset];
    
    //return query url
    return components.URL;
    
};

// MARK: - URL Query Items

-(NSArray<NSURLQueryItem *> *)getQueryItemsWithOffset:(NSNumber *)offset {
    
    // Time stamp
    NSString * timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    // Add additional query items to the URL
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"apikey" value:publicKey];
    NSURLQueryItem *hash = [NSURLQueryItem queryItemWithName:@"hash" value:[self endpointHash:timestamp]];
    NSURLQueryItem *ts = [NSURLQueryItem queryItemWithName:@"ts" value:[NSString stringWithFormat:@"%@", timestamp]];
    NSURLQueryItem *urlOffset = [NSURLQueryItem queryItemWithName:@"offset" value:[NSString stringWithFormat:@"%@", offset]];
    
    return @[ ts, apiKey, hash, urlOffset ];
    
};

//MARK: - MD5 Hash

-(NSString *)endpointHash:(NSString *)timeStampObj {
    
    //Combine both keys and timestamp
    NSString *combined = [NSString stringWithFormat:@"%@%@%@", timeStampObj, privateKey, publicKey];
    //Create an MD5 Hash from above
    NSString *hash = [[NSString alloc] generateMD5:combined];
    
    //Return the hash
    return [hash lowercaseString];
};



@end

@protocol ComicItem

- (int)id;
- (NSString *)title;
- (NSString *)thumbnailUrlString;

@end
