//
//  RemoveNull.h
//  Nyuyu
//
//  Created by Kondaiah V on 5/31/16.
//  Copyright © 2016 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoveNull : NSObject

+ (id)sharedInstance;

- (NSDictionary *)nullFilteredDictionary:(NSDictionary *)dictionary;
- (NSArray *) nullFiltereArray:(NSArray *)array;
- (id)nullFilteredValue:(id)value;

@end
