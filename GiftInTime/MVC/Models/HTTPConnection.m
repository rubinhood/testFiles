//
//  HTTPConnection.m
//  TaxiApp
//
//  Created by Kondaiah V on 2/21/17.
//  Copyright © 2017 Quick Technosoft Pvt. Ltd. All rights reserved.
//

#import "HTTPConnection.h"

@implementation HTTPConnection

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
    }
    return self;
}

#pragma mark - JSONString
- (NSString *)gettingJSONString_withDictionary:(NSDictionary *)jsonDict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:kNilOptions
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Dictionary jsonstring error: %@", error.localizedDescription);
        return @"";
    }
    else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

- (NSString *)gettingJSONString_withArray:(NSMutableArray *)jsonArray {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:kNilOptions
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Array jsonstring error: %@", error.localizedDescription);
        return @"";
    }
    else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

#pragma mark - WebRequest
- (NSURLSession *)gettingURLSession {
    
    NSURLSessionConfiguration *defaultConfigur = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigur
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    return defaultSession;
}

- (NSMutableURLRequest *)gettingURLRequest_withParameters:(NSString *)parameterString withFile:(NSString *)filename {
    
    
    // form data setup for each fileds(params)
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData *body = [NSMutableData data];
    
    
    // data with details...
    NSString *registerData = parameterString;
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[registerData dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Passing data : %@", registerData);
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", ServerPath, filename];
    NSLog(@"URL : %@", urlString);
    
    // Url request...
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    
    body = nil;
    return request;
}

- (NSMutableURLRequest *)gettingURLRequestWithHeader_withParameters:(NSString *)parameterString withFile:(NSString *)filename {
    
        /*
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               @"tokenstring": tokenString
                               
                               };*/
    
    
    
    // form data setup for each fileds(params)
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData *body = [NSMutableData data];
    
    // data with details...
    NSString *registerData = parameterString;
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[registerData dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Passing data with header : %@", registerData);
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", ServerPath, filename];
    NSLog(@"URL : %@", urlString);
    
    // secretkey...
    NSString *tokenString =[[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];

    
    
    // Url request...
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setValue:tokenString forHTTPHeaderField:@"tokenstring"];
    [request setValue:@"1.0" forHTTPHeaderField:@"version"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    
    body = nil;
    return request;
}

- (NSMutableURLRequest*)gettingURLRequest_ParametersOnly:(NSMutableDictionary *)parametersDict withFile:(NSString*)filename requestType:(NSString *)requestType {
    
    // form data setup for each fileds(params)...
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData *body = [NSMutableData data];
    
    NSArray *keysArray = [parametersDict allKeys];
    
    for (int i=0; i<[keysArray count]; i++) {
        
        NSString *keyString = [NSString stringWithFormat:@"%@", [keysArray objectAtIndex:i]];
        
        // element adding..
        NSString *firstName = [NSString stringWithFormat:@"%@", [parametersDict objectForKey:keyString]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", keyString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[firstName dataUsingEncoding:NSUTF8StringEncoding]];
        //[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@ :: %@", keyString , firstName);
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@", ServerPath, filename];
    NSLog(@"URL  %@ : %@", requestType, urlstring);
    NSString *tokenString =[[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];

    // Url request...
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlstring]];
    [request setValue:tokenString forHTTPHeaderField:@"tokenstring"];

    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:body];
    [request setHTTPMethod:requestType];
    
    return request;
}
- (void)apiGetCall_HTTPConnection:(NSMutableDictionary *)parameters withFile:(NSString*) file withHUD:(UIView *) Vu withServiceDelegate:(id <ApiServiceDelegate>) delegate withServiceCall:(int) serviceNumber {
    
    if( Vu != nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Vu animated:YES];
        [hud hide:YES afterDelay:10.0];
    }
    
    
    // Url request ans session creation...
   // NSMutableURLRequest *request = [[HTTPConnection sharedInstance] gettingURLRequest_ParametersOnly:parameters  withFile:file requestType:@"GET"];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@%@", ServerPath, file];
    
    // Url request...
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlstring]];
    [request setHTTPMethod:@"GET"];

    
    NSURLSession *defaultSession = [[HTTPConnection sharedInstance]  gettingURLSession];
    
    // sending request...
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // JSON serialization...
        if (error == nil) {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"Login response : %@", responseDict);
            
            responseDict = [[RemoveNull sharedInstance] nullFilteredDictionary:responseDict];
            
            if ([[responseDict objectForKey:@"code"] intValue] == 201 || [[responseDict objectForKey:@"code"] intValue] == 200) {
                //[KSToastView ks_showToast:[responseDict objectForKey:@"message"]];
                if([delegate conformsToProtocol:@protocol(ApiServiceDelegate)]) {
                    [delegate onSuccessApiCall:responseDict withServiceCall:serviceNumber ];
                }
                //[self MoveToHomeScreen];
            }else if ([[responseDict objectForKey:@"code"] intValue] == 302 || [[responseDict objectForKey:@"code"] intValue] == 422) {
                [KSToastView ks_showToast:[responseDict objectForKey:@"message"]];

            }else if ([[responseDict objectForKey:@"code"] intValue] == 401 ) {
                [KSToastView ks_showToast:[responseDict objectForKey:@"message"]];
                
            }
            else {
                [KSToastView ks_showToast:[responseDict objectForKey:@"message"]];
            }
        }else {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"\n \n Possible Login Failure: %@ \n \n ", jsonString.description);
            [delegate onFailureApiCall:nil withServiceCall:serviceNumber ];
            
        }
        [MBProgressHUD hideAllHUDsForView:Vu animated:YES];
    }];
    
    [dataTask resume];
}

- (void)apiCall_HTTPConnection:(NSMutableDictionary *)parameters images:(NSMutableDictionary *)imagesDict withFile:(NSString*) file withHUD:(UIView *) Vu withServiceDelegate:(id <ApiServiceDelegate>) delegate withServiceCall:(int) serviceNumber {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Vu animated:YES];
    [hud hide:YES afterDelay:10.0];
    
    
    // Url request ans session creation...
    //NSMutableURLRequest *request = [[HTTPConnection sharedInstance] gettingURLRequest_ParametersOnly:parameters  withFile:file requestType:@"POST"];
    
    NSMutableURLRequest *request = [[HTTPConnection sharedInstance] gettingURLRequest_WithParameters:parameters images:imagesDict withFile:file requestType:@"PUT"];
    NSURLSession *defaultSession = [[HTTPConnection sharedInstance]  gettingURLSession];
    
    // sending request...
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Login response : %@", strData);
        // JSON serialization...
        if (error == nil) {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            
            NSLog(@"Login response : %@", responseDict);
            
            responseDict = [[RemoveNull sharedInstance] nullFilteredDictionary:responseDict];
            
            if ([[responseDict objectForKey:@"code"] intValue] == 200 || [[responseDict objectForKey:@"code"] intValue] == 201) {
                //[KSToastView ks_showToast:[responseDict objectForKey:@"message"]];
                if([delegate conformsToProtocol:@protocol(ApiServiceDelegate)]) {
                    [delegate onSuccessApiCall:responseDict withServiceCall:serviceNumber ];
                }
                //[self MoveToHomeScreen];
            }else if ([[responseDict objectForKey:@"code"] intValue] == 302 || [[responseDict objectForKey:@"code"] intValue] == 422) {
                [KSToastView ks_showToast:[responseDict objectForKey:@"massage"]];
                
            }else if ([[responseDict objectForKey:@"code"] intValue] == 401 ) {
                [KSToastView ks_showToast:[responseDict objectForKey:@"massage"]];
                
            }
            else {
                [KSToastView ks_showToast:[responseDict objectForKey:@"message"]];
            }
            
        }else {
            
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"\n \n Possible Login Failure: %@ \n \n ", jsonString.description);
            [delegate onFailureApiCall:nil withServiceCall:serviceNumber ];
            
        }
        [MBProgressHUD hideAllHUDsForView:Vu animated:YES];
    }];
    
    [dataTask resume];
}

- (void)apiCall_HTTPConnection:(NSMutableDictionary *)parameters withFile:(NSString*) file withHUD:(UIView *) Vu withServiceDelegate:(id <ApiServiceDelegate>) delegate withServiceCall:(int) serviceNumber {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Vu animated:YES];
    [hud hide:YES afterDelay:10.0];
    
    
    // Url request ans session creation...
    NSMutableURLRequest *request = [[HTTPConnection sharedInstance] gettingURLRequest_ParametersOnly:parameters  withFile:file requestType:@"POST"];
    NSURLSession *defaultSession = [[HTTPConnection sharedInstance]  gettingURLSession];
    
    // sending request...
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // JSON serialization...
        if (error == nil) {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"Login response : %@", responseDict);
            
            responseDict = [[RemoveNull sharedInstance] nullFilteredDictionary:responseDict];
            
            if ([[responseDict objectForKey:@"code"] intValue] == 200 || [[responseDict objectForKey:@"code"] intValue] == 201) {
                //[KSToastView ks_showToast:[responseDict objectForKey:@"message"]];
                if([delegate conformsToProtocol:@protocol(ApiServiceDelegate)]) {
                    [delegate onSuccessApiCall:responseDict withServiceCall:serviceNumber ];
                }
                //[self MoveToHomeScreen];
            }else if ([[responseDict objectForKey:@"code"] intValue] == 302 || [[responseDict objectForKey:@"code"] intValue] == 422) {
                [KSToastView ks_showToast:[responseDict objectForKey:@"massage"]];
                
            }else if ([[responseDict objectForKey:@"code"] intValue] == 401 ) {
                [KSToastView ks_showToast:[responseDict objectForKey:@"massage"]];
                
            }
            else {
                [KSToastView ks_showToast:[responseDict objectForKey:@"message"]];
            }
        }else {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"\n \n Possible Login Failure: %@ \n \n ", jsonString.description);
            [delegate onFailureApiCall:nil withServiceCall:serviceNumber ];
            
        }
        [MBProgressHUD hideAllHUDsForView:Vu animated:YES];
    }];
    
    [dataTask resume];
}


- (NSMutableURLRequest *)gettingURLRequest_WithParameters:(NSMutableDictionary *)parametersDict  images:(NSMutableDictionary *)imagesDict withFile:(NSString *)filename requestType:(NSString *)requestType{
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSString *urlstring = [NSString stringWithFormat:@"%@%@", ServerPath, filename];
    NSLog(@"URL  %@ : %@", requestType, urlstring);

    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"profile_image";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:urlstring];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:requestType];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    if(imagesDict.count != 0) {
        NSArray *imagheKeysArray = [imagesDict allKeys];
        for (int i=0; i<[imagheKeysArray count]; i++) {
            NSString *keyString = [NSString stringWithFormat:@"%@", [imagheKeysArray objectAtIndex:i]];
            UIImage *image = (UIImage *)[imagesDict objectForKey:keyString];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    
    
    

    // add params (all params are strings)
    for (NSString *param in parametersDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parametersDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
        // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    return request;
}


#if 0

- (NSMutableURLRequest *)gettingURLRequest_WithParameters:(NSMutableDictionary *)parametersDict  images:(NSMutableDictionary *)imagesDict withFile:(NSString *)filename requestType:(NSString *)requestType {
    
    // form data setup for each fileds(params)...
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData *body = [NSMutableData data];
    
    if(imagesDict.count != 0) {
        NSArray *imagheKeysArray = [imagesDict allKeys];
        for (int i=0; i<[imagheKeysArray count]; i++) {
             NSString *keyString = [NSString stringWithFormat:@"%@", [imagheKeysArray objectAtIndex:i]];
            UIImage *imageData = (UIImage *)[imagesDict objectForKey:keyString];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_image\"; filename=\"profile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];

            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    
    
    
    NSArray *keysArray = [parametersDict allKeys];
    
    for (int i=0; i<[keysArray count]; i++) {
        
        NSString *keyString = [NSString stringWithFormat:@"%@", [keysArray objectAtIndex:i]];
        
        // element adding..
        NSString *firstName = [NSString stringWithFormat:@"%@", [parametersDict objectForKey:keyString]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", keyString] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[firstName dataUsingEncoding:NSUTF8StringEncoding]];
        //[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@ :: %@", keyString , firstName);
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    if(imagesDict.count != 0) {
        NSArray *imagheKeysArray = [imagesDict allKeys];
        for (int i=0; i<[imagheKeysArray count]; i++) {
            
            NSString *keyString = [NSString stringWithFormat:@"%@", [imagheKeysArray objectAtIndex:i]];
            
            // user_image ...
            UIImage *loImage = (UIImage *)[imagesDict objectForKey:keyString];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n\r\n", keyString] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *imagetype = @"image/jpeg";
            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",imagetype] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:UIImageJPEGRepresentation(loImage, 0.6)];
            NSLog(@"Image added");
        }
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@", ServerPath, filename];
    NSLog(@"URL  %@ : %@", requestType, urlstring);
    NSString *tokenString =[[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    
    
    
    
    // Url request...
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlstring]];
    [request setValue:tokenString forHTTPHeaderField:@"tokenstring"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:body];
    [request setHTTPMethod:requestType];
    
    return request;
}
#endif
@end
