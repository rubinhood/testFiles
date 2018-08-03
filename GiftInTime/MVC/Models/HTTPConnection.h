//
//  HTTPConnection.h
//  TaxiApp
//
//  Created by Kondaiah V on 2/21/17.
//  Copyright © 2017 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApiServiceDelegate <NSObject>

-(void) onSuccessApiCall:(NSDictionary*) data withServiceCall:(int)seriviceNumber ;
-(void) onFailureApiCall:(NSDictionary*) data withServiceCall:(int)seriviceNumber ;

@end


@interface HTTPConnection : NSObject

typedef void(^ResponseBlock)(const BOOL success, id resultObject, NSError *error);

+ (id)sharedInstance;

- (NSString *)gettingJSONString_withDictionary:(NSDictionary *)jsonDict;
- (NSString *)gettingJSONString_withArray:(NSMutableArray *)jsonArray;

- (NSURLSession *)gettingURLSession;
- (NSMutableURLRequest *)gettingURLRequest_withParameters:(NSString *)parameterString withFile:(NSString *)filename;
- (NSMutableURLRequest *)gettingURLRequestWithHeader_withParameters:(NSString *)parameterString withFile:(NSString *)filename;
- (NSMutableURLRequest*)gettingURLRequest_ParametersOnly:(NSMutableDictionary *)parametersDict withFile:(NSString*)filename requestType:(NSString *)requestType;
-(void)updateProfile:(NSDictionary *)userDetails :(NSData *)profilePic :(ResponseBlock)block ;
- (NSMutableURLRequest *)gettingURLRequest_WithParameters:(NSMutableDictionary *)parametersDict  images:(NSMutableDictionary *)imagesDict withFile:(NSString *)filename requestType:(NSString *)requestType;

- (void)apiCall_HTTPConnection:(NSMutableDictionary *)parameters withFile:(NSString*) file withHUD:(UIView *) Vu withServiceDelegate:(id <ApiServiceDelegate>) delegate withServiceCall:(int) serviceNumber ;
- (void)apiGetCall_HTTPConnection:(NSMutableDictionary *)parameters withFile:(NSString*) file withHUD:(UIView *) Vu withServiceDelegate:(id <ApiServiceDelegate>) delegate withServiceCall:(int) serviceNumber;

- (void)apiCall_HTTPConnection:(NSMutableDictionary *)parameters images:(NSMutableDictionary *)imagesDict withFile:(NSString*) file withHUD:(UIView *) Vu withServiceDelegate:(id <ApiServiceDelegate>) delegate withServiceCall:(int) serviceNumber ;

@end
