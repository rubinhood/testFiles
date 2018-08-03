//
//  SocialLoginClass.h
//  SumeruHolidays
//
//  Created by Quick on 20/04/17.
//  Copyright © 2017 Quick. All rights reserved.
//

#define TWITTER_LOGIN   0
#define GOOGLE_LOGIN    0
#define FACEBOOK_LOGIN  1

#import <Foundation/Foundation.h>

#if TWITTER_LOGIN

#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>

#endif 

#if  GOOGLE_LOGIN
#import <GoogleSignIn/GoogleSignIn.h>
#define ARGS UIWebViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate
#else
#define ARGS UIWebViewDelegate
#endif


#if  FACEBOOK_LOGIN
#import <Bolts/Bolts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#endif

@protocol SocialLoginClassDelegate <NSObject>
    
@optional

- (void) onFacebokLoginSuccess:(NSDictionary*) userLoginData;;
- (void) onFacebokLoginFailed:(NSError *)error;
- (void) onFacebokLoginCancelled;

- (void) onGoogleLoginSuccess:(NSDictionary*) userLoginData;
- (void) onGoogleLoginFailed:(NSError *)error;
- (void) onGoogleLoginCancelled;


- (void) onTwitterLoginSuccess;
- (void) onTwitterLoginFailed;
- (void) onTwitterLoginCancelled;


@end

@interface SocialLoginClass : NSObject <ARGS >

@property (strong, nonatomic) id<SocialLoginClassDelegate> delegate;

+ (SocialLoginClass *) sharedInstance ;
- (instancetype) init ;
- (void) initiateFacebookLoginFrom : (UIViewController *) initiator;
- (void) initiateGoogleLoginFrom :(UIViewController *)initiator ;
- (void) initiateTwitterLoginFrom : (UIViewController *) initiator ;

@end
