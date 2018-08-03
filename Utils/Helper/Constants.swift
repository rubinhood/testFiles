


import Foundation
import UIKit

struct AppConstants {
    
    
    
    struct serviceClass {
        
        #if !VENDOR_DEBUG
        static var BASE_URL = "http://23.20.5.8/zyime/webservices/vendor/"
        //static var BASE_URL = "http://192.168.0.102/ecomm/webservices/vendor/"
        #else
        //static var BASE_URL = "http://23.20.5.8/zyime/webservices/vendor/"
        static var BASE_URL = "http://192.168.0.102/ecomm/webservices/vendor/"

        #endif
        static let NO_IMAGE = Bundle.main.url(forResource: "noimg", withExtension: "png")
        static var LOGIN = "login"
        static var DASHBOARD = "dashboard"
        static var MYPRODUCT = "myProduct"
        static var GET_CATEGORY = "addProduct"
        static var ADD_CATEGORY = "actionAddCategory"
        static var ADD_NEW_PRODUCT = "actionAddProduct"
        static var GET_MONTHWISE_DASHBOARD_DATA = "getMonthWiseDashboard"
        static var PUBLISHUNPUBLIS = "updateProductStatus"
        static var UPDATE_PRODUCT = "actionUpdateProduct"
        static var VIEW_PRODUCT = "viewProduct"
        static var DELETE_PRODUCT = "deleteProduct"
        static var VIEW_ORDERS = "viewOrders"
        static var VIEW_ORDER = "viewOrder"
        static var VIEW_PROFILE = "profile"
        static var UPDATE_PROFILE = "actionUpdateprofile"
        static var GET_SUB_CATEGORY = "getSubCategory"
        static var ACTION_CHANGE_PASSWORD = "actionChangePassword"
    }
    
    struct color {
        
        static var lightBlue = UIColor(hex:0x1A81C6 , alpha : 0.4)
    }
    
    struct notification {
        
        static var updateProfileSwipe = "Update_Profile_Swipe"
        static var userProfileInformation = "User_Profile_Information"
    }
    
}

struct appDefaults {
    static var USER_PROFILE = "user_profile"
    static var VENDOR_TOKEN = "vendor_token"
}


struct RequestID{
    
    
    static var login = 1000
    static var dashboard = 1001
    static var getCategory = 1002
    static var addCategory = 1003
    static var addNewProduct = 1004
    static var getMonthWiseDashboard = 1005
    static var publishing = 1006
    static var updateProduct = 1007
    static var viewProduct = 1008
    static var deleteProduct = 1009
    static var viewOrders = 1010
    static var viewOrder = 1011
    static var viewProfile = 1012
    static var updateProfile = 1013
    static var getSubCategory = 1014
    static var changePassword = 1015
}
struct NOTIFICATIONS{

    static var newProductAdded = "NewProductAdded"
    static var productUpdated = "productUpdated"
    static var dashboardRefresh = "dashboardRefresh"
    static var deleteProduct = "deleteProduct"
    static var profileUpdated = "profileUpdated"
    
    }

struct DEBUG{
    
    
    static let debug = 1
    
}
