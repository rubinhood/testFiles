

import UIKit
import Foundation
import UIKit


class CommonUtilities {
    
    static var sharedInstance = CommonUtilities()
    
    var hud = MBProgressHUD()
    /**
     
     startLoader is a method to call start loader.
     -Paramter View : View is a UIView type
     */
    
    func startLoader(){
        
        hud = MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
        hud.mode = MBProgressHUDModeIndeterminate
        hud.color  = AppConstants.color.lightBlue
        hud.tintColor = UIColor.white
        hud.labelText = "Loading..."
        hud.labelColor = UIColor.white
        
        //hud.bezelView.color = AppCo
        //hud.contentColor = UIColor.white
        //hud.label.textColor = UIColor.white
        //hud.label.text = "Loading..."
        
    }
    
    /**
     
     stopLoader is a method to call stop loader.
     -Paramter View : View is a UIView type
     
     */
    
    func stopLoader(){
        MBProgressHUD.hide(for: appDelegate.window!, animated: true)
    }
    
    class func validateEmail(with email: String) -> Bool {
        let stricterFilter = false
        // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex: String = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return !emailTest.evaluate(with: email)
    }


}

class StringUtilities{
    
    class func getAttributedStrikedString(CurrencyName:String,OriginalPrice:String,DiscountedPrice:String) -> NSAttributedString{
        
        let attriString  = CurrencyName + " " + OriginalPrice + " " + DiscountedPrice
        let somePartStringRange = (attriString as NSString).range(of: OriginalPrice)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: attriString)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: somePartStringRange)
        
        return attributeString
        
    }
    
}




class HandleNavigationScreens{
    
    class func showHomeScreen(){
        
        let homePageView = DashBoardVC.instantiateFromStoryBoard() as! DashBoardVC
        
        let navCntl = UINavigationController(rootViewController: homePageView)
        navCntl.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navCntl
        appDelegate.window?.makeKeyAndVisible()
    }
    
    class func showLoginScreen(){
        
        //let loginCntl = LoginVC.instantiateFromStoryBoard() as! LoginVC
        //let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        //let loginCntl = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let loginCntl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let navCntl = UINavigationController(rootViewController: loginCntl)
        navCntl.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navCntl
        appDelegate.window?.makeKeyAndVisible()

    }
    
    class func logOut() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: appDefaults.USER_PROFILE)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = controller
        appDelegate.window?.makeKeyAndVisible()

    }
    
}






