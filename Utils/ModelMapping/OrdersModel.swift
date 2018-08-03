

import UIKit
import Foundation
import SwiftyJSON


public struct OrdersModel{
    
    
    public var newOrders: [OrderModels]?
    public var oldOrders: [OrderModels]?
    
    public init?(dictionary: [String:JSON]) {
        if let new_array = dictionary["newOrders"]?.array{
            newOrders = OrderModels.modelsFromDictionaryArray(array: new_array)
        }
        if let old_array = dictionary["oldOrders"]?.array{
            oldOrders = OrderModels.modelsFromDictionaryArray(array: old_array)
        }
        
        
    }
    
}
public struct OrderModels {
    
    public var overViewOrderedData : OverviewOrderDataModel?
    public var detailedOrderDataModel:[DetailedOrderDataModel]!
    
    public static func modelsFromDictionaryArray(array:[JSON]) -> [OrderModels]
    {
        var models:[OrderModels] = []
        for item in array{
            if let dict = item.dictionary{
                models.append(OrderModels(dictionary: dict)!)
            }
        }
        return models
    }
    
    public init?(dictionary: [String:JSON]) {
        
        if let data = dictionary["OverviewOrderData"]?.dictionary{
            overViewOrderedData = OverviewOrderDataModel(dictionary: data)
        }
        if let images_array = dictionary["detailedOrderData"]?.array{
            detailedOrderDataModel = DetailedOrderDataModel.modelsFromDictionaryArray(array: images_array)
        }
        
    }
    
    
    
}

public struct OverviewOrderDataModel {
    
    public var id:String?
    public var order_code:String?
    public var created_at:String?
    public var payment_name:String?
    public var first_name:String?
    public var last_name:String?
    
    
    public init?(dictionary: [String:JSON]) {
        id  = dictionary["id"]?.string ?? ""
        order_code  = dictionary["order_code"]?.string ?? ""
        created_at  = dictionary["created_at"]?.string ?? ""
        payment_name  = dictionary["payment_name"]?.string ?? ""
        first_name  = dictionary["first_name"]?.string ?? ""
        last_name  = dictionary["last_name"]?.string ?? ""
        
        
    }

    
}
public struct DetailedOrderDataModel {
    
    public var orderProduct : OrderProductModel?
    public var productDetails : OrderProductDetailsModel?
    public var productImages : [OrderProductImagesModel]?

    
    public static func modelsFromDictionaryArray(array:[JSON]) -> [DetailedOrderDataModel]
    {
        var models:[DetailedOrderDataModel] = []
        for item in array{
            if let dict = item.dictionary{
                models.append(DetailedOrderDataModel(dictionary: dict)!)
            }
        }
        return models
    }

    
    public init?(dictionary: [String:JSON]) {
        
        if let data = dictionary["orderProduct"]?.dictionary{
            orderProduct = OrderProductModel(dictionary: data)
        }
        if let data = dictionary["product Details"]?.dictionary{
            productDetails = OrderProductDetailsModel(dictionary: data)
        }
        if let images_array = dictionary["productImages"]?.array{
            productImages = OrderProductImagesModel.modelsFromDictionaryArray(array: images_array)
        }
        
        
    }

    
    
}
public struct OrderProductDetailsModel {
    
    public var id : String?
    public var vendor_id : String?
    public var product_name : String?
    public var product_code : String?
    public var product_description : String?
    public var add_by : String?
    public var category_id : String?
    public var status : String?
    public var stock : String?
    public var price : String?
    public var is_deleted: String?
    public var sub_category_id :String?
    public init?(dictionary: [String:JSON]) {
        id  = dictionary["id"]?.string ?? ""
        vendor_id  = dictionary["vendor_id"]?.string ?? ""
        product_name  = dictionary["product_name"]?.string ?? ""
        product_code  = dictionary["product_code"]?.string ?? ""
        product_description  = dictionary["product_description"]?.string ?? ""
        add_by  = dictionary["add_by"]?.string ?? ""
        category_id  = dictionary["category_id"]?.string ?? ""
        status  = dictionary["status"]?.string ?? ""
        stock  = dictionary["stock"]?.string ?? ""
        price  = dictionary["price"]?.string ?? ""
        sub_category_id  = dictionary["sub_category_id"]?.string ?? ""
        is_deleted  = dictionary["is_deleted"]?.string ?? ""

        
    }
    
    
}

public struct OrderProductModel {
    
    public var id : String?
    public var order_id : String?
    public var product_id : String?
    public var product_varient_id : String?
    public var quantity : String?
    public var gst : String?
    public var amount : String?
    public var status : String?
    public var updated_at : String?
    public var created_at : String?
    
    public init?(dictionary: [String:JSON]) {
        id  = dictionary["id"]?.string ?? ""
        order_id  = dictionary["order_id"]?.string ?? ""
        product_id  = dictionary["product_id"]?.string ?? ""
        product_varient_id  = dictionary["product_varient_id"]?.string ?? ""
        quantity  = dictionary["quantity"]?.string ?? ""
        gst  = dictionary["gst"]?.string ?? ""
        amount  = dictionary["amount"]?.string ?? ""
        status  = dictionary["status"]?.string ?? ""
        updated_at  = dictionary["updated_at"]?.string ?? ""
        created_at  = dictionary["created_at"]?.string ?? ""
        
        
    }
    
    
}

public struct OrderProductImagesModel {
    public var pImagePath : String?
    public var pImageId : String?
    public static func modelsFromDictionaryArray(array:[JSON]) -> [OrderProductImagesModel]
    {
        var models:[OrderProductImagesModel] = []
        for item in array{
            if let dict = item.dictionary{
                models.append(OrderProductImagesModel(dictionary: dict)!)
            }
        }
        return models
    }
    
    
    public init?(dictionary: [String:JSON]) {
        
        if let data = dictionary["image_path"]?.string{
            pImagePath = data
        }
        
        if let data = dictionary["id"]?.string{
            pImageId = data
        }
    }
}


