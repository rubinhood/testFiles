

import UIKit
import Foundation
import SwiftyJSON


public struct MyProductsModel {
    
    public var status:Int?
    public var myProducts:[NewProductsModel]!
    
    public init?(dictionary: [String:JSON]) {
        status = dictionary["status"]?.int
        if let data = dictionary["myProduct"]?.array{
            myProducts = NewProductsModel.modelsFromDictionaryArray(array: data)
            
        }
        
    }
    public  mutating func joinModelFromDictionaryArray(dictionary: [String:JSON])
    {
        
        if let data = dictionary["myProduct"]?.array{
            
            if(myProducts == nil) {
                myProducts = []
    
            }
            
            for item in data{
                if let dict = item.dictionary{
                    myProducts.append(NewProductsModel(dictionary: dict)!)
                }
            }
            
        }
    }
    
    
    

}


