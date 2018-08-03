//
//  APIRequestService.swift
//  
//
//  Created  on 30/10/17.
//  Copyright All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIRequestService: NSObject {
    
    static let sharedInstance = APIRequestService()
    
    //Session manager must always Stored property to a class, otherwise will get error code=-999,since it is not retained
    private var sessionManager:SessionManager?
    
    var alamoFireManager:SessionManager{
        
        if sessionManager == nil{
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            sessionManager = Alamofire.SessionManager(configuration: configuration)
        }
        return sessionManager!
    }
    
    //MARK: Get request call
    
    func getRequestCall(showActivity:Bool, baseURL:String, apiServicesDelegate: APIServicesDelegate, requestID: Int){
        
        if showActivity{
            // Show loader
            
            CommonUtilities.sharedInstance.startLoader()
        }
        
        alamoFireManager.request(baseURL).responseJSON {
            response in
            
            if showActivity{
                // Hide loader
                
                CommonUtilities.sharedInstance.stopLoader()
                
            }
            
            switch (response.result) {
                
            case .success:
                //do json stuff
                
                let jsonResponse = JSON(response.result.value!)
                print("\n\nAuth request sucess:\n \(jsonResponse.description)")
                apiServicesDelegate.onSuccess(response: jsonResponse, req_ID: requestID)
                
                break
                
            case .failure(let encodingError):
                
                let error = encodingError as NSError
                
                if error.code == NSURLErrorTimedOut || error.code ==  NSURLErrorNotConnectedToInternet{
                    //timeout here
                    
                    apiServicesDelegate.onFailure(error: error, req_ID: requestID)
                    
                }
                else if error.code == NSURLErrorNetworkConnectionLost{
                    
                    self.getRequestCall(showActivity: showActivity, baseURL: baseURL, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                }
                else{
                    
                    //                    let userInfoDic: [NSObject : AnyObject] =
                    //                        [ NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Connection interrupted", value: "Something went wrong. Please try again..!", comment: "") as AnyObject]
                    //
                    //                    let errorDes = NSError(domain: "Custom", code: -10002, userInfo: userInfoDic)
                    
                    apiServicesDelegate.onFailure(error: error, req_ID: requestID)
                    
                }
                
                print("\n\nAuth request failed with error:\n \(error)")
                
                break
            }
        }
    }

    //MARK: Request a service call
    
    func sendRequestCall(showActivity:Bool, baseURL : String, dictParameters : [String: Any], apiServicesDelegate: APIServicesDelegate, requestID: Int){
        
        
        if(!NetworkReachabilityManager()!.isReachable){
            KSToastView.ks_showToast("Make sure your device is connected to the internet.")
            return
        }
        if showActivity{
            // Show loader
            print("Show loader")
            
            CommonUtilities.sharedInstance.startLoader()
        }
        
        var header: HTTPHeaders?
        header = nil
        
        let defaults = UserDefaults.standard
        var token : String = ""
        if let token1 = defaults.object(forKey: appDefaults.VENDOR_TOKEN) as? String {
            token = "9999999"+token1
            header = ["tokenstring" : token1]
        }else {
            header = nil
        }
        /*
         if globalUser != nil{
            
            if let auth = globalUser?.user_details?.Authenticationkey{
                
                header = ["Authenticationkey" : auth]

            }
            
        }
        else{
            
            header = nil
        }*/
        
        print(header as Any)
        
            alamoFireManager.request(baseURL, method: .post, parameters: dictParameters, headers: header).responseJSON {
                
            response in
                
                if showActivity{
                    // Hide loader
                    print("Hide loader")
                    
                    CommonUtilities.sharedInstance.stopLoader()
                }
            
            switch (response.result) {
                
            case .success:
                //do json stuff
                
                let jsonResponse = JSON(response.result.value!)
                
                if(jsonResponse["status"].boolValue == false && jsonResponse["message"].stringValue == "token_mismatch") {
                    KSToastView.ks_showToast("Session Expired Please Login Again")
                    let Contoler = apiServicesDelegate as! UIViewController
                    let controller = Contoler.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = controller

                }
                
                print("\n\nAuth request sucess:\n \(jsonResponse.description)")
                apiServicesDelegate.onSuccess(response: jsonResponse, req_ID: requestID)
                
                break
                
            case .failure(let encodingError):
                
                let error = encodingError as NSError
                
                if error.code == NSURLErrorTimedOut || error.code ==  NSURLErrorNotConnectedToInternet{
                    //timeout here
                    
                apiServicesDelegate.onFailure(error: error, req_ID: requestID)
                    
                }
                else if error.code == NSURLErrorNetworkConnectionLost{
                    
                    self.sendRequestCall(showActivity: showActivity,baseURL: baseURL, dictParameters: dictParameters, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                }
                else{
                    
//                    let userInfoDic: [NSObject : AnyObject] =
//                        [ NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Connection interrupted", value: "Something went wrong. Please try again..!", comment: "") as AnyObject]
//                    
//                    let errorDes = NSError(domain: "Custom", code: -10002, userInfo: userInfoDic)
                    
                    apiServicesDelegate.onFailure(error: error, req_ID: requestID)
                    
                }
                
                print("\n\nAuth request failed with error:\n \(error)")
                
                break
            }
        }
    }
    
    
    //MARK: Upload a document
    
    public func sendDataUploadRequest(showActivity:Bool, baseURL : String, dictParameters : [String: Any], uploadContent : [Data], dataParam : String, fileNameExtension : String, fileMimeType : String, apiServicesDelegate: APIServicesDelegate, requestID : Int){
        
        if showActivity{
            // Show loader
            
            print("Show loader")
            
            CommonUtilities.sharedInstance.startLoader()
        }
        
        var header = HTTPHeaders()
        //header = nil
        /*
        if globalUser != nil{
            
            if let auth = globalUser?.user_details?.Authenticationkey{
                
                header = ["Authenticationkey" : auth]
                
            }        }
       */
        print(header as Any)
        
        alamoFireManager.upload(multipartFormData: { multipartFormData in
            
            for uploadData in uploadContent {
                multipartFormData.append(uploadData as Data, withName: dataParam, fileName: "\(Date().timeIntervalSince1970).\(fileNameExtension)", mimeType: fileMimeType)
            }
            
            for (key, value) in dictParameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        },
          //usingThreshold:UInt64.init(),
          to: baseURL,
          method: .post,
          encodingCompletion: { encodingResult in
            
            if showActivity{
                // Hide loader
                print("Hide loader")
                
                CommonUtilities.sharedInstance.stopLoader()
            }
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON{ response in
                    
                    if let jsonData = response.result.value {
                        let jsonResponse = JSON(jsonData)
                        
                         apiServicesDelegate.onSuccess(response: jsonResponse, req_ID: requestID)
                        
                        print("\n\nAuth request sucess:\n \(jsonResponse.description)")
                    }
                }
                
            case .failure(let encodingError):
                let error = encodingError as NSError
                
                if error.code == NSURLErrorTimedOut || error.code == NSURLErrorNotConnectedToInternet{
                    //timeout here
                    
                    apiServicesDelegate.onFailure(error: error, req_ID: requestID)
                }
                else if error.code == NSURLErrorNetworkConnectionLost{
                    
                    self.sendDataUploadRequest(showActivity: showActivity, baseURL: baseURL, dictParameters: dictParameters, uploadContent: uploadContent, dataParam: dataParam, fileNameExtension: fileNameExtension, fileMimeType: fileMimeType, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                }
                else{
                    
                    let userInfoDic: [NSObject : AnyObject] =
                        [ NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Connection interrupted", value: "Something went wrong. Please try again..!", comment: "") as AnyObject]
                    
                    let errorDes = NSError(domain: "Custom", code: -10002, userInfo: userInfoDic)
                    
                    apiServicesDelegate.onFailure(error: errorDes, req_ID: requestID)
                    
                }
                
                print("\n\nAuth request failed with error:\n \(error)")
            }
        })
    }
    
    public func sendMultipartData(showActivity:Bool, baseURL : String, dictParameters : [String: Any], uploadContent : [Data], dataParam : String, fileNameExtension : String, fileMimeType : String, apiServicesDelegate: APIServicesDelegate, requestID : Int){
        
        if showActivity{
            // Show loader
            
            print("Show loader")
            
            CommonUtilities.sharedInstance.startLoader()
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for imageData in uploadContent {
                multipartFormData.append(imageData, withName: dataParam, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in dictParameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: baseURL,
           
           encodingCompletion: { encodingResult in
            
            
            if showActivity{
                // Hide loader
                print("Hide loader")
                
                CommonUtilities.sharedInstance.stopLoader()
            }
            switch encodingResult {
                
            
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let jsonData = response.result.value {
                        let jsonResponse = JSON(jsonData)
                        
                        apiServicesDelegate.onSuccess(response: jsonResponse, req_ID: requestID)
                        
                        print("\n\nAuth request sucess:\n \(jsonResponse.description)")
                    }
                }
            case .failure(let encodingError):
                let error = encodingError as NSError
                
                if error.code == NSURLErrorTimedOut || error.code == NSURLErrorNotConnectedToInternet{
                    //timeout here
                    
                    apiServicesDelegate.onFailure(error: error, req_ID: requestID)
                }
                else if error.code == NSURLErrorNetworkConnectionLost{
                    
                    self.sendDataUploadRequest(showActivity: showActivity, baseURL: baseURL, dictParameters: dictParameters, uploadContent: uploadContent, dataParam: dataParam, fileNameExtension: fileNameExtension, fileMimeType: fileMimeType, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                }
                else{
                    
                    let userInfoDic: [NSObject : AnyObject] =
                        [ NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Connection interrupted", value: "Something went wrong. Please try again..!", comment: "") as AnyObject]
                    
                    let errorDes = NSError(domain: "Custom", code: -10002, userInfo: userInfoDic)
                    
                    apiServicesDelegate.onFailure(error: errorDes, req_ID: requestID)
                    
                }
            }
            
        })
        
        
    }
    // Request with image
    func uploadMultipart(url: String, imageParams: [[String: UIImage]], parameters: [String: Any], apiServicesDelegate: APIServicesDelegate, requestID : Int,showActivity:Bool) {
        
        if(!NetworkReachabilityManager()!.isReachable){
            KSToastView.ks_showToast("Make sure your device is connected to the internet.")
            return
        }
        
        
        let defaults = UserDefaults.standard
        var header: HTTPHeaders?
        header = nil
        var token : String = ""
        if let token1 = defaults.object(forKey: appDefaults.VENDOR_TOKEN) as? String {
            token = token1
            header = ["tokenstring" : token1]
        }else {
            header = nil
        }

        
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        

        if let token1 = defaults.object(forKey: appDefaults.VENDOR_TOKEN) as? String {
            token = token1
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header
                "Content-type": "multipart/form-data",*/
                "tokenstring" : token1
                
            ]
        }
        if showActivity{
            // Hide loader
            print("Hide loader")
            
            CommonUtilities.sharedInstance.startLoader()
        }

        alamoFireManager.upload(multipartFormData: { (multipartData) in
            for (key, value) in parameters {
                multipartData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            for imageParam in imageParams {
                for (key, value) in imageParam {
                    let jpegData = UIImageJPEGRepresentation(value, 0.8)
                    let pngData = UIImagePNGRepresentation(value)
                    if jpegData != nil {
                        multipartData.append(jpegData!, withName: key, fileName: "image.jpeg", mimeType: "image/jpeg")
                    } else if pngData != nil {
                        multipartData.append(pngData!, withName: key, fileName: "image.png", mimeType: "image/png")
                    } else{
                        print("Can not convert Image to either jpg or png")
                    }
                }
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: header) { (result) in
            switch result {
                
                
            case .success(request: let uploadReq, streamingFromDisk: _, streamFileURL: _):
                /*uploadReq.uploadProgress(closure: { (progress) in
                    progresscompletion?(Float(progress.fractionCompleted))
                })*/
                print(uploadReq)
                
                uploadReq.responseJSON(completionHandler: { (response) in
                    
                    let string1 = String(data: response.data!, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                    print(string1)
                    if showActivity{
                        // Hide loader
                        print("Hide loader")
                        
                        CommonUtilities.sharedInstance.stopLoader()
                    }

                    if let err = response.result.error {
                       // onError?(err)
                        print("\n\n Auth request eroor:\n \n  \(err)")
                        apiServicesDelegate.onFailure(error: err, req_ID: requestID)
                        return
                    }
                    let resJson = JSON(response.result.value!)
                    
                    if(resJson["status"].boolValue == false && resJson["token_status"].boolValue == false) {
                        KSToastView.ks_showToast("Session Expired Please Login Again")
                        let Contoler = apiServicesDelegate as! UIViewController
                        let controller = Contoler.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = controller
                        
                    }
                    
                    
                    apiServicesDelegate.onSuccess(response: resJson, req_ID: requestID)
                    
                    print("\n\nAuth request sucess:\n \(resJson.description)")
                    //oncompletion?(resJson)
                })
                break
            case .failure(let error):
                //onError?(error)
                if showActivity{
                    // Hide loader
                    print("Hide loader")
                    
                    CommonUtilities.sharedInstance.stopLoader()
                }
                apiServicesDelegate.onFailure(error: error, req_ID: requestID)
                break
            }
        }
    }
    
    
    
}
