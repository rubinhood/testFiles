//
//  DataStoreClass.h
//  GiftInTime
//
//  Created by Telugu Desham  on 30/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStoreClass : NSObject

@property (strong,nonatomic) UIImage *mProfileImage;
@property (strong,nonatomic) UIImage *mLoadingImage;
@property (strong,nonatomic) UIImage *mBlankImage;
@property (assign,nonatomic) int mGiftPoints;



+ (id)sharedInstance ;

@end
