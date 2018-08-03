

import UIKit


@IBDesignable class CustomGradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor(hex: 0x1A81C6, alpha: 1) {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var mid1Color: UIColor = UIColor(hex: 0x3C6CB1, alpha: 1) {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var mid2Color: UIColor = UIColor(hex: 0x5F5AA0, alpha: 1) {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor(hex: 0xBF3077, alpha: 1)  {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .darkGray {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        let gradientLayer = layer as! CAGradientLayer
        //gradientLayer.colors = [startColor.cgColor, mid1Color.cgColor, mid2Color.cgColor, endColor.cgColor]
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        let roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = 1
        layer.shadowPath = roundedRect.cgPath
        
        
    }
}
