//
//  SocialLoginClass.m
//  SumeruHolidays
//
//  Created by Quick on 20/04/17.
//  Copyright © 2017 Quick. All rights reserved.
//

#import "SocialLoginClass.h"




static SocialLoginClass * mInstance = nil;


@implementation SocialLoginClass

{
    UIViewController *mParent;
    
}


+(SocialLoginClass *) sharedInstance {
    @synchronized (self) {
        if(nil == mInstance) {
            mInstance = [[SocialLoginClass alloc] init];
        }
        
        return mInstance;
    }

}

- (instancetype) init {
    self = [super init];
    if (self) {
        // initialization
    
    }
    return self;
}

#if TWITTER_LOGIN
- (void) initiateTwitterLoginFrom : (UIViewController *) initiator {
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        
        if (session) {
            
            TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
            [client loadUserWithID:[session userID] completion:^(TWTRUser *user, NSError *error) {
                
                // handle the response or error
                if (error == nil) {
                    
                    NSLog(@"User : %@", user.name);
                    NSLog(@"User login : %@", user.userID);
                    NSLog(@"Email error : %@", error.localizedDescription);
                    [client requestEmailForCurrentUser:^(NSString * _Nullable email, NSError * _Nullable error) {
                        
                        // device id...
                        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                        if (deviceToken == nil) {
                            deviceToken = @"3955386a738f7bbd40e12f670ef5f101b259a366";
                        }
                        
                        // email...
                        NSString *emailStr = @"";
                        if (email != nil) {
                            emailStr = email;
                        }
                        
                        // parameter with data....
                        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                        [parameters setObject:user.name forKey:@"first_name"];
                        [parameters setObject:user.name forKey:@"last_name"];
                        [parameters setObject:emailStr forKey:@"email"];
                        [parameters setObject:@"3" forKey:@"social_type"];
                        [parameters setObject:user.userID forKey:@"social_id"];
                        [parameters setObject:deviceToken forKey:@"device_id"];
                        [parameters setObject:@"2" forKey:@"device_type"];
                        [parameters setObject:@"" forKey:@"phone"];
                        [parameters setObject:@"" forKey:@"image"];
                        
                        // getting json sting....
                        
                        if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
                            [self.delegate onFacebokLoginSuccess:parameters];
                        }

                    }];
                }
                else {
                    if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
                        [self.delegate onFacebokLoginFailed:error];
                        
                    }
                }
            }];
        } else {
            if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
                [self.delegate onFacebokLoginFailed:error];
                
            }
        }
    }];
    
    
    
    
}

#endif


#if GOOGLE_LOGIN

- (void) initiateGoogleLoginFrom :(UIViewController *)initiator  {
    // google user login...
    mParent = initiator;
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
    signin.uiDelegate = self;
    [signin signIn];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error) {
        NSLog(@"Google login error : %@", error.localizedDescription);
        if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
            [self.delegate onFacebokLoginFailed:error];
            
        }
        return;
    }
    else {
        NSLog(@"Google User name : %@", user.profile.name);
        
        // device id...
        NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        if (deviceToken == nil) {
            deviceToken = @"3955386a738f7bbd40e12f670ef5f101b259a366";
        }
        
        // parameter with data....
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:user.profile.name forKey:@"first_name"];
        [parameters setObject:@"" forKey:@"last_name"];
        [parameters setObject:user.profile.email forKey:@"email"];
        [parameters setObject:@"2" forKey:@"social_type"];
        [parameters setObject:user.userID forKey:@"social_id"];
        [parameters setObject:deviceToken forKey:@"device_id"];
        [parameters setObject:@"2" forKey:@"device_type"];
        [parameters setObject:@"" forKey:@"phone"];
        [parameters setObject:@"" forKey:@"image"];
        // getting json sting....
        
        if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
            [self.delegate onFacebokLoginSuccess:parameters];
            
        }
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    
    if (error) {
        NSLog(@"Google login error : %@", error.localizedDescription);
        if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
            [self.delegate onFacebokLoginFailed:error];
            
        }

        return;
    }
    else {
        NSLog(@"Google User name : %@", user.profile.name);
    }
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"%@",error.description);
    if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
        [self.delegate onFacebokLoginFailed:error];
        
    }

}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    //present view controller
    [mParent presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    //dismiss view controller
    [mParent dismissViewControllerAnimated:YES completion:nil];
}
#endif

#if FACEBOOK_LOGIN
- (void) initiateFacebookLoginFrom : (UIViewController *) initiator {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile",@"email"]
    fromViewController:initiator
    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [KSToastView ks_showToast:error.localizedDescription];
            if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
                [self.delegate onFacebokLoginFailed:error];
                
            }
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
            if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
                [self.delegate onFacebokLoginCancelled];
                
            }
        } else {
            NSLog(@"Logged in");
            if ([result.grantedPermissions containsObject:@"email"]) {
                [self getFBProfile_Result];
            }
        }
    }];
}

- (void)getFBProfile_Result {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                
                NSLog(@"fb user info : %@", result);
                // device id...
                NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                if (deviceToken == nil) {
                    deviceToken = @"3955386a738f7bbd40e12f670ef5f101b259a366";
                }
                 // parameter with data....
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:[result objectForKey:@"name"] forKey:@"first_name"];
                [parameters setObject:@"" forKey:@"last_name"];
                [parameters setObject:[result objectForKey:@"email"] forKey:@"email"];
                [parameters setObject:@"2" forKey:@"social_type"];
                [parameters setObject:[NSString stringWithFormat:@"%@", [result objectForKey:@"id"]] forKey:@"social_id"];
                [parameters setObject:deviceToken forKey:@"device_id"];
                [parameters setObject:@"2" forKey:@"device_type"];
                [parameters setObject:@"" forKey:@"phone"];
                [parameters setObject:@"" forKey:@"image"];
                
                if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
                    [self.delegate onFacebokLoginSuccess:parameters];
                    
                }
                 // getting json sting....
                 ///[self socialLogin_HTTPConnection:parameters];
             }
             else {
                 NSLog(@"error : %@",error);
                 if([self.delegate conformsToProtocol:@protocol(SocialLoginClassDelegate)]) {
                     [self.delegate onFacebokLoginFailed:error];
                     
                 }
             }
         }];
    }
}
#endif
@end
