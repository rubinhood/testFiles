

import UIKit


extension UINavigationController
{   /**
     - usage: self.navigationController(LoginVC.self)
     */
    
    func popToViewController<T: UIViewController>(controller type: T.Type,animated:Bool) {
        for viewController in self.viewControllers {
            if viewController is T {
                self.popToViewController(viewController, animated: animated)
                return
            }
        }
    }
}

/**
 Insantiate ViewController with name
 */
extension UIViewController{
    class func instantiateFromStoryBoard() -> UIViewController?{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vcName = String(describing: self)
        let vc = storyBoard.instantiateViewController(withIdentifier: vcName)
        return vc
    }
}


extension UIWindow{
    static var main:UIWindow{
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!
    }
}

extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

