

import Foundation
import SwiftyJSON


public struct LoginModel{
    
    public var status:Int?
    public var auth_token:String?
    
    public var user_details:UserDetailModel?
    
    public init?(dictionary: [String:JSON]) {
        
        status = dictionary["status"]?.int
        auth_token = dictionary["auth_token"]?.string
        
        if let data = dictionary["data"]?.dictionary{
            
            user_details = UserDetailModel(dictionary: data)

        }
        
    }
    public static func getNewProfileData(dictionary: [String:JSON]) -> UserDetailModel? {
    
        if let data = dictionary["updatedData"]?.dictionary{
            
            return  UserDetailModel(dictionary: data)
            
        }
        
        return nil
        
        
    }
    
    
}

public struct UserDetailModel {
    
    public var added_by:String?
    public var created_by:String?
    public var created_on: String?
    public var email:String?
    public var modified_on: String?
    public var password: String?

    public var phone : String?
    public var user_id : String?
    public var user_name : String?
    public var user_status : String?
    public var user_type : String?
    public var first_name : String?
    public var last_name : String?
    public var image_path : String?
    public var vendor_name : String?
    public var date_of_birth : String?
    public var image_path2 : String?
    public var image_name : String?
    public var address : String?

    
    var dictionary: [String: String] {
        return [
            "added_by": added_by!,
            "created_by": created_by!,
            "created_on": created_on!,
            "email": email!,
            "modified_on": modified_on!,
            "password": password!,
            
            "phone": phone!,
            "user_id": user_id!,
            "user_name": user_name!,
            "user_status": user_status!,
            "user_type": user_type!,
            "first_name": first_name!,
            "last_name": last_name!,
            "image_path": image_path!,
            "vendor_name": vendor_name!,
            "date_of_birth":date_of_birth!,
            "image_path2":image_path2!,
            "image_name": image_name!,
            "address": address!
        ]
    }
    // TODO: Dictionary Model
    
    public init?(dictionary: [String:JSON]) {

        added_by = dictionary["added_by"]?.string ?? ""
        created_by = dictionary["created_by"]?.string ?? ""
        email = dictionary["email"]?.string ?? ""
        created_on = dictionary["created_on"]?.string  ?? ""
        modified_on = dictionary["modified_on"]?.string ?? ""
        password = dictionary["password"]?.string  ?? ""
        phone = dictionary["phone"]?.string  ?? ""
        user_id = dictionary["user_id"]?.string  ?? ""
        user_name = dictionary["user_name"]?.string  ?? ""
        user_status = dictionary["user_status"]?.string ?? ""
        user_type = dictionary["user_type"]?.string  ?? ""
        first_name = dictionary["first_name"]?.string  ?? ""
        last_name = dictionary["last_name"]?.string ?? ""
        image_path = dictionary["image_path"]?.string  ?? ""
        vendor_name = dictionary["vendor_name"]?.string  ?? ""
        date_of_birth = dictionary["date_of_birth"]?.string  ?? ""
        image_path2 = dictionary["image_path2"]?.string  ?? ""
        image_name = dictionary["image_name"]?.string  ?? ""
        address = dictionary["address"]?.string  ?? ""
        /*
        if let added_by_var = dictionary["added_by"]?.string{
            added_by = added_by_var
        }else {
            added_by = ""
        }
        if let created_by_var = dictionary["created_by"]?.string{
            created_by = created_by_var
        }else {
            created_by = ""
        }
        if let email_var = dictionary["email"]?.string{
            email = email_var
        }else {
            email = ""
        }
        if let created_on_var = dictionary["created_on"]?.string{
            created_on = created_on_var
        }else {
            created_on = ""
        }
        modified_on = dictionary["modified_on"]?.string ?? ""
        /*
        if let modified_on_var = dictionary["modified_on"]?.string{
            modified_on = modified_on_var
        }else {
            modified_on = ""
        }*/
        if let password_var = dictionary["password"]?.string{
            password = password_var
        }else {
            password = ""
        }
        if let phone_var = dictionary["phone"]?.string{
            phone = phone_var
        }else {
            phone = ""
        }
        if let user_id_var = dictionary["user_id"]?.string{
            user_id = user_id_var
        }else {
            user_id = ""
        }
        if let user_name_var = dictionary["user_name"]?.string{
            user_name = user_name_var
        }else {
            user_name = ""
        }
        
        if let user_status_var = dictionary["user_status"]?.string{
            user_status = user_status_var
        }else {
            user_status = ""
        }
        
        if let user_type_var = dictionary["user_type"]?.string{
            user_type = user_type_var
        }else {
            user_type = ""
        }*/
        

    }
  }



