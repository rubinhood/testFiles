//
//  ContactsData.h
//  GiftInTime
//
//  Created on 17/01/18.
//
//

#import <Foundation/Foundation.h>

@interface ContactsData : NSObject


@property (strong, nonatomic) NSData *mImage;
@property (assign, nonatomic) BOOL mHasImage;

@property (strong, nonatomic) NSString *mFirstname;
@property (strong, nonatomic) NSString *mLastname;
@property (strong, nonatomic) NSString *mPhone;
@property (strong, nonatomic) NSString *mStrippedPhone;
@property (strong, nonatomic) NSString *mEmail;
@property (strong, nonatomic) NSString *mBirthday;
@property (strong, nonatomic) NSString *mAddress1;
@property (strong, nonatomic) NSString *mAddress2;
@property (strong, nonatomic) NSString *mProvince;
@property (strong, nonatomic) NSString *mCity;
@property (strong, nonatomic) NSString *mPostalcode;
@property (strong, nonatomic) NSString *mCountry;
@property (assign, nonatomic) int mOperationSkip;

@property (strong, nonatomic) NSString *mID;

@end
