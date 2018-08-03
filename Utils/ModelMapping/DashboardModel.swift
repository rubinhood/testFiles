

import UIKit
import Foundation
import SwiftyJSON


public struct DashboardModel {
    
    public var status:Int?
    public var productCount : Int?
    public var monthOrder: Int?
    public var monthNewOrder: Int?
    public var monthSales: String?
    public var monthList:[MonthListModel]?
    public var newProducts:[NewProductsModel]!
    
    public init?(dictionary: [String:JSON]) {
        status = dictionary["status"]?.int
        productCount = dictionary["productCount"]?.int
        
        monthOrder = dictionary["monthOrder"]?.int
        monthNewOrder = dictionary["monthNewOrder"]?.int
        monthSales = dictionary["monthSales"]?.string
        
        if let data = dictionary["newProduct"]?.array{
            newProducts = NewProductsModel.modelsFromDictionaryArray(array: data)
            
        }
        if let data = dictionary["monthList"]?.array{
            monthList = MonthListModel.modelsFromDictionaryArray(array: data)
            
        }

        
        }

    }

public struct MonthListModel {
    public var id: String?
    public var name: String?
    
    
    public static func modelsFromDictionaryArray(array:[JSON]) -> [MonthListModel]
    {
        var models:[MonthListModel] = []
        for item in array{
            if let dict = item.dictionary{
                models.append(MonthListModel(dictionary: dict)!)
            }
        }
        return models
    }
    
    public init?(dictionary: [String:JSON]) {
        
        if let data = dictionary["id"]?.string{
            id = data
        }
        
        if let data = dictionary["name"]?.string{
            name = data
        }    }

    
    }

public struct NewProductsModel {
    public var discount : DiscountsModel?
    public var productDetail : ProductDetailsModel?
    public var productImages:[ProductImagesModel]!
    
    public static func modelsFromDictionaryArray(array:[JSON]) -> [NewProductsModel]
    {
        var models:[NewProductsModel] = []
        for item in array{
            if let dict = item.dictionary{
                models.append(NewProductsModel(dictionary: dict)!)
            }
        }
        return models
    }
    
    public init?(dictionary: [String:JSON]) {
        
        if let data = dictionary["discount"]?.dictionary{
            discount = DiscountsModel(dictionary: data)
        }
        if let data = dictionary["product"]?.dictionary{
            productDetail = ProductDetailsModel(dictionary: data)
        }
        if let images_array = dictionary["images"]?.array{
            productImages = ProductImagesModel.modelsFromDictionaryArray(array: images_array)
        }
        
    }


    
}


public struct DiscountsModel {
    
    public var discount_type : String?
    public var discount_value : String?
    public var start_time : String?
    public var end_time : String?
    public var discountPrice : Float?
    
    public init?(dictionary: [String:JSON]) {
        discount_type  = dictionary["discount_type"]?.string ?? ""
        discount_value  = dictionary["discount_value"]?.string ?? ""
        start_time  = dictionary["start_time"]?.string ?? ""
        end_time  = dictionary["end_time"]?.string ?? ""
        discountPrice  = dictionary["discountPrice"]?.float ?? 0.00
    
    }
}


public struct ProductDetailsModel {
    
    public var id : String?
    public var vendor_id : String?
    public var product_name : String?
    public var product_code : String?
    public var product_description : String?
    public var add_by : String?
    public var category_id : String?
    public var sub_category_id : String?
    public var status : String?
    public var stock : String?
    public var price : String?

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
   
        
    }
    
    
}

public struct ProductImagesModel {
    public var pImagePath : String?
    public var pImageId : String?
    public static func modelsFromDictionaryArray(array:[JSON]) -> [ProductImagesModel]
    {
        var models:[ProductImagesModel] = []
        for item in array{
            if let dict = item.dictionary{
                models.append(ProductImagesModel(dictionary: dict)!)
            }
        }
        return models
    }

    
    public init?(dictionary: [String:JSON]) {
        
        if let data = dictionary["image_path"]?.string{
            pImagePath = data
        }
        
        if let data = dictionary["image_id"]?.string{
            pImageId = data
        }
    }
}
