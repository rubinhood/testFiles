//
//  DataStoreClass.m
//  GiftInTime
//
//  Created by Telugu Desham  on 30/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "DataStoreClass.h"

@implementation DataStoreClass

static DataStoreClass  *dataStore;

+ (id)sharedInstance {
    
    static id instance_ = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
        
    });
    return instance_;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _mProfileImage = [UIImage imageNamed:@"img_user_default.png"];
        _mBlankImage = [UIImage imageNamed:@"noImage.png"];
        _mGiftPoints = 0;
    }
    
    //notification
    
    return self;
}

- (void)dealloc {
    
    // dealloc notifications

}


@end
