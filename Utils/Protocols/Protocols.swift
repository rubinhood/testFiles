

import Foundation
import SwiftyJSON

protocol APIServicesDelegate{
    
    func onSuccess(response: JSON, req_ID: Int)
    
    func onFailure(error: Error, req_ID: Int)
    
}

protocol PublishChangDelegate{
    func onPublishChange(raw:Int, status:String)
    
}

protocol NewProductAdderDelegate{
    func onNewProductAdded(status:String)
    
}


