//
//  RemoveNull.m
//  Nyuyu
//
//  Created by Kondaiah V on 5/31/16.
//  Copyright © 2016 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import "RemoveNull.h"

@implementation RemoveNull

+ (id)sharedInstance
{
    
    static id instance_ = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}




- (NSDictionary *)nullFilteredDictionary:(NSDictionary *)dictionary{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    for (id key in mutableDictionary.allKeys){
        id value = mutableDictionary[key];
        mutableDictionary[key] = [self nullFilteredValue:value];
    }
    
    return mutableDictionary;
}

- (NSArray *)nullFiltereArray:(NSArray *)array{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    for (int i = 0; i < mutableArray.count; ++i){
        id value = mutableArray[i];
        mutableArray[i] = [self nullFilteredValue:value];
    }
    
    return mutableArray;
}

- (id)nullFilteredValue:(id)value{
    if ([value isKindOfClass:[NSNull class]]){
        value = @"";
    }else if ([value isKindOfClass:[NSDictionary class]]){
        value = [self nullFilteredDictionary:value];
    }else if ([value isKindOfClass:[NSArray class]]){
        value = [self nullFiltereArray:value];
    }
    return value;
}

    
@end
