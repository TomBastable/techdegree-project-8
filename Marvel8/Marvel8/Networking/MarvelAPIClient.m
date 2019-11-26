//
//  MarvelAPIClient.m
//  Marvel8
//
//  Created by Tom Bastable on 22/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

#import "MarvelAPIClient.h"


@implementation MarvelAPIClient

//MARK:- Get Characters Endpoint (With an offset, so this can be reused for infinite scrolling).

-(void)charactersWithOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicCharacter *> *charArray, NSError *error)) completion {
    
    //init Endpoint property
    Endpoint *endpoint = [[Endpoint alloc]init];
    
    //Assign correct endpoint URL
    NSURL *endpointUrl = [endpoint characterDataUrlWithOffset:offset];
    
    //Download and cast JSON to ComicCharacter Objects
    [JSONDownloader requestWithEndpoint:endpointUrl.absoluteString completion:^(NSArray * _Nonnull JSONArray, NSError * _Nonnull error) {
        
        //Check for error in download
        if (error == nil){
            
            //complete with results
            completion([self convertToCharactersFrom:JSONArray], nil);
        
        }else{
            
            //complete with error
            completion(nil, error);
            
        }
    }];
};

// MARK:- Get Characters that are related to a specific comic.

-(void)charactersRelatedTo:(NSNumber *)comicId withOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicCharacter *> *charArray, NSError *error)) completion {
    
    //init Endpoint property
    Endpoint *endpoint = [[Endpoint alloc]init];
    
    //Assign correct endpoint URL
    NSURL *endpointUrl = [endpoint relatedCharacrersWithComicId:comicId andOffset:offset];
    
    //Download and cast JSON to ComicCharacter Objects
    [JSONDownloader requestWithEndpoint:endpointUrl.absoluteString completion:^(NSArray * _Nonnull JSONArray, NSError * _Nonnull error) {
        
        //Check for error in download
        if (error == nil){
            
            //complete with results
            completion([self convertToCharactersFrom:JSONArray], nil);
        
        }else{
            
            //complete with error
            completion(nil, error);
            
        }
    }];
};

//MARK: - Get Comics with an offset amount (Again for infinite scroll).

-(void)comicsWithOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicBook *> *charArray, NSError *error)) completion {
    
    //init Endpoint property
    Endpoint *endpoint = [[Endpoint alloc]init];
    
    //Assign correct endpoint URL
    NSURL *endpointUrl = [endpoint comicDataUrlWithOffset:offset];
    
    //Download and cast JSON to ComicBook Objects
    [JSONDownloader requestWithEndpoint:endpointUrl.absoluteString completion:^(NSArray * _Nonnull JSONArray, NSError * _Nonnull error) {
        
        //Check for error in download
        if (error == nil){
    
            //complete with results
            completion([self convertToComicsFrom:JSONArray], nil);
        
        }else{
            
            //complete with error
            completion(nil, error);
            
        }
    }];
    
};

//MARK: - Get Comics with an offset amount (Again for infinite scroll).

-(void)comicsRelatedTo:(NSNumber *)charId withOffset:(NSNumber *)offset completion:(void(^)(NSMutableArray<ComicBook *> *charArray, NSError *error)) completion {
    
    //init Endpoint property
    Endpoint *endpoint = [[Endpoint alloc]init];
    
    //Assign correct endpoint URL
    NSURL *endpointUrl = [endpoint relatedComicsWithCharId:charId andOffset:offset];
    
    //Download and cast JSON to ComicBook Objects
    [JSONDownloader requestWithEndpoint:endpointUrl.absoluteString completion:^(NSArray * _Nonnull JSONArray, NSError * _Nonnull error) {
        
        //Check for error in download
        if (error == nil){
            
            //complete with results
            completion([self convertToComicsFrom:JSONArray], nil);
        
        }else{
            
            //complete with error
            completion(nil, error);
            
        }
    }];
    
};

//MARK: - Class specific function to convert JSON to ComicCharacter Objects.

-(NSMutableArray *)convertToCharactersFrom:(NSArray*)JSONArray {
    
    //init a new NSMA.
    NSMutableArray<ComicCharacter*> *charArray = [NSMutableArray new];
    
    for (NSDictionary* character in JSONArray)
    {
        //init a new character
        ComicCharacter *newCharacter = [[ComicCharacter alloc]init];
        
        //assign relevant properties to the class properties
        newCharacter.name = [character objectForKey:@"name"];
        newCharacter.charDescription = [character objectForKey:@"description"];
        newCharacter.charId = [character objectForKey:@"id"];
        
        //Thumbnail is a dictionary of path / extension. Lay them out nicely below.
        NSDictionary *thumbnailUrl = [character objectForKey:@"thumbnail"];
        NSString *thumbnailString = [NSString stringWithFormat:@"%@.%@", [thumbnailUrl objectForKey:@"path"], [thumbnailUrl objectForKey:@"extension"]];
        
        //Assign the string
        newCharacter.thumbnailURLString = thumbnailString;
        
        //Add chatacter to array
        [charArray addObject:newCharacter];
        
    }
    
    //after the loop return the array
    return charArray;
    
};

//MARK: - Class specific function to convert JSON to ComicBook Objects.

-(NSMutableArray *)convertToComicsFrom:(NSArray*)JSONArray {
    
    //init a new NSMA.
    NSMutableArray<ComicBook*> *comicArray = [NSMutableArray new];
    
    for (NSDictionary* character in JSONArray)
    {
        //init a new comic book
        ComicBook *newCharacter = [[ComicBook alloc]init];
        
        //assign relevant properties to the class properties
        newCharacter.comictitle = [character objectForKey:@"title"];
        newCharacter.comicDescription = [character objectForKey:@"description"];
        newCharacter.comicId = [character objectForKey:@"id"];
        
        //Thumbnail is a dictionary of path / extension. Lay them out nicely below.
        NSDictionary *thumbnailUrl = [character objectForKey:@"thumbnail"];
        NSString *thumbnailString = [NSString stringWithFormat:@"%@.%@", [thumbnailUrl objectForKey:@"path"], [thumbnailUrl objectForKey:@"extension"]];
        
        //Assign the string
        newCharacter.thumbnailURLString = thumbnailString;
        
        //Add chatacter to array
        [comicArray addObject:newCharacter];
        
    }
    
    //after the loop return the array
    return comicArray;
    
};

@end
