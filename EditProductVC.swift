

import UIKit
import SwiftyJSON
import SDWebImage

class EditProductVC:UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    PECropViewControllerDelegate,
    APIServicesDelegate,
    UIPickerViewDelegate,
    UIPickerViewDataSource
{
    
    @IBOutlet weak var mCurrencyDeclaration: UILabel!
    @IBOutlet weak var mNewProductScrollView: UIScrollView!
    @IBOutlet weak var mProductNameTF: UITextField!
    @IBOutlet weak var mProductDescriptionTV: UITextView!
    @IBOutlet weak var mProductPrice: UITextField!
    @IBOutlet weak var mProductCategory: UIButton!
    @IBOutlet weak var mProductStockTF: UITextField!
    @IBOutlet weak var mProductCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var mProductCollection: UICollectionView!
    
    @IBOutlet weak var mDiscountFromDate: UITextField!
    
    @IBOutlet weak var mDiscountCardView: CardView!
    @IBOutlet weak var mDiscountEnableStatusImage: UIImageView!
    @IBOutlet weak var mDiscountEnableBtn: UIButton!
    @IBOutlet weak var mDiscountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mDiscountsType: UITextField!
    @IBOutlet weak var mDiscount: UITextField!
    @IBOutlet weak var mDiscountTillDate: UITextField!
    
    @IBOutlet weak var mDiscountFieldView: UIView!
    
    let mItemSize: Float = Float((UIScreen.main.bounds.size.width-30) / 3)
    var mProductImages = [UIImage]()
    let PLACE_HOLDER_TEXT = "Please Add about your product Details. More you add, better you sale"
    let identifier = "ProductImageCell"
    let MAXIMUM_PRODUCT_IMAGE = 4
    var mImagePicker = UIImagePickerController ()
    
    var mTextField: UITextField?
    var model:NewProductsModel?
    var mUpdateProductImages :[[String: AnyObject]] = []
    
    
    
    let apiSharedObject = APIRequestService.sharedInstance
    var mSelectedCategory:[String:AnyObject]?
    var mDiscountType = ["Percentage", "Flat"]
    
    var mDatePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mProductDescriptionTV.textContainerInset = UIEdgeInsetsMake(
            0,-mProductDescriptionTV.textContainer.lineFragmentPadding, 0,0);
        mProductDescriptionTV.text = PLACE_HOLDER_TEXT
        mProductDescriptionTV.textColor = UIColor.lightGray
        mProductNameTF.delegate  = self
        mProductPrice.delegate  = self
        mProductStockTF.delegate  = self
        mProductDescriptionTV.delegate = self
        
        if (self.model?.discount) != nil {
            mDiscountViewHeight.constant = 200
            mDiscountFieldView.alpha = 1
            mDiscountEnableBtn.isSelected = true
            mDiscountEnableStatusImage.isHighlighted = true
            
            if let discountz = self.model?.discount {
                mDiscountsType.text = discountz.discount_type == "1" ? "Percentage" : "Flat"
                mDiscount.text = discountz.discount_value!
                mDiscountFromDate.text = convertDateFormatForDiscount(dateS: discountz.start_time!)
                mDiscountTillDate.text = convertDateFormatForDiscount(dateS: discountz.end_time!)
                
            }
            
            
        
        } else {
            mDiscountViewHeight.constant = 39.5
            mDiscountFieldView.alpha = 0
            mDiscountEnableBtn.isSelected = false
            mDiscountEnableStatusImage.isHighlighted = false

        }
        
        mDiscountCardView.layer.borderWidth = 0.3
        mDiscountCardView.layer.borderColor = UIColor.lightGray.cgColor
        mDiscountCardView.layer.cornerRadius = 5.0
        mDiscountCardView.layer.masksToBounds = true
        mDiscountCardView.clipsToBounds = true
        mDiscountsType.delegate = self
        mDiscount.delegate = self
        mDiscountFromDate.delegate = self
        mDiscountTillDate.delegate = self
        
        
        
        mProductNameTF.addTarget(mProductDescriptionTV, action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        
        //mProductDescriptionTV.addTarget(mProductPrice, action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)

        mProductPrice.addTarget(mProductStockTF, action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        
        
        mImagePicker.delegate = self
        
        // set up product image set up gallery
        mProductCollection.register(UINib(nibName:identifier, bundle:nil), forCellWithReuseIdentifier: identifier)
        mProductCollection.delegate =  self
        mProductCollection.dataSource = self
        mProductCollectionHeight.constant = CGFloat((mItemSize) + 5);
        
        getProductDetails()
        getImagesDetails()
        // Do any additional setup after loading the view.
        
        setUpPicker()
        setUpDatePicker(textField : mDiscountTillDate)
        setUpDatePicker(textField : mDiscountFromDate)
    }
    
    func setUpDatePicker (textField : UITextField){
        mDatePicker.datePickerMode = UIDatePickerMode.date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        textField.inputView = mDatePicker
        textField.inputAccessoryView = toolbar
        mDatePicker.minimumDate = Date()

    }
    
    func convertDateFormat(dateS:String) -> String{
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "UTC") // set locale to
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateS)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date!)
        print("EXACT_DATE : \(dateString)")
        
        return dateString
    }
    
    func convertDateFormatForDiscount(dateS:String) -> String{
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "UTC") // set locale to
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateS)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date!)
        print("EXACT_DATE : \(dateString)")
        
        return dateString
    }

    
    func convertDateFormatForService(dateS:String) -> String{
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "UTC") // set locale to
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let date = dateFormatter.date(from: dateS)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date!)
        print("EXACT_DATE : \(dateString)")
        
        return dateString
    }
    func compareDate2LaterThanDate1(dateString1:String, dateString2:String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "UTC") // set locale to
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let date1 = dateFormatter.date(from: dateString1)
        let date2 = dateFormatter.date(from: dateString2)
        
        if (date2?.compare(date1!) == ComparisonResult.orderedDescending) {
            return true
        }
        
        return false
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        let newDate = formatter.string(from: mDatePicker.date)
        if mTextField == mDiscountFromDate {
            
            if(mDiscountTillDate.text != "") {
                if(compareDate2LaterThanDate1(dateString1: newDate, dateString2: mDiscountTillDate.text!)) {
                    mDiscountFromDate.text = newDate
                }else {
                    KSToastView.ks_showToast("Discont Strat time should not be later than discount end time")
                }
            }else {
                mDiscountFromDate.text = newDate

            }
        }
        else if mTextField == mDiscountTillDate {
            //Set text for stateField
            
            if(mDiscountFromDate.text != "") {
                if(compareDate2LaterThanDate1(dateString1: mDiscountFromDate.text!, dateString2: newDate)) {
                    mDiscountTillDate.text = newDate
                }else {
                    KSToastView.ks_showToast("Discont Strat time should not be later than discount end time")
                }
            }else {
                mDiscountTillDate.text = newDate
                
            }
        }
        
        
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }

    
    
    func setUpPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        toolbar.setItems([spaceButton,cancelButton], animated: false)
        mDiscountsType.inputView = pickerView
        mDiscountsType.inputAccessoryView = toolbar

        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mDiscountType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mDiscountType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mDiscountsType.text = mDiscountType[row]
    }
    
    @IBAction func mEnableDiscount(_ sender: UIButton) {
        if(sender.isSelected) {
            mDiscountViewHeight.constant = 38.0
            mDiscountFieldView.alpha = 0
            sender.isSelected = false
            mDiscountEnableStatusImage.isHighlighted = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.mDiscountCardView.superview?.superview?.layoutIfNeeded()
                
            }) { _ in
            }
        }else {
            
            mDiscountViewHeight.constant = 200
            mDiscountFieldView.alpha = 1
            sender.isSelected = true
            mDiscountEnableStatusImage.isHighlighted = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.mDiscountCardView.superview?.superview?.layoutIfNeeded()
                
            }) { _ in
            }

        }
        
        
    }
    
    func getProductDetails() {
        mProductNameTF.text = self.model?.productDetail?.product_name ?? ""
        mProductDescriptionTV.text = self.model?.productDetail?.product_description ?? ""
        mProductPrice.text = self.model?.productDetail?.price ?? ""
        mProductStockTF.text = self.model?.productDetail?.stock ?? ""
        mProductDescriptionTV.textColor = UIColor.darkGray

    }
    
    func getImagesDetails() {
        let imageData = self.model?.productImages
        for item in (imageData)! {
            var dictionary:[String:AnyObject] = [:]
            dictionary.updateValue(item.pImagePath as AnyObject, forKey:"image_path")
            dictionary.updateValue(item.pImageId as AnyObject, forKey:"image_id")
            mUpdateProductImages.append(dictionary)
        }
        mProductCollection.reloadData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    
    @IBAction func backToPreviousVC(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showActionSheet(sender: AnyObject) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Camera")
            self.shootPhoto(sender)
            
        })
        
        
        let saveAction = UIAlertAction(title: "PhotoLibrary", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File PhotoLibrary")
            self.photoFromLibrary(sender)
            
        })
        
        
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
            optionMenu.removeFromParentViewController()
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func photoFromLibrary(_ sender: AnyObject) {
        mImagePicker.allowsEditing = false
        mImagePicker.sourceType = .photoLibrary
        //mImagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //mImagePicker.mediaTypes = [kUTTypeImage as String]
        mImagePicker.modalPresentationStyle = .popover
        present(mImagePicker, animated: true, completion: nil)
        //mImagePicker.popoverPresentationController?.barButtonItem = sender
    }
    
    func shootPhoto(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            mImagePicker.allowsEditing = false
            mImagePicker.sourceType = UIImagePickerControllerSourceType.camera
            mImagePicker.cameraCaptureMode = .photo
            mImagePicker.modalPresentationStyle = .fullScreen
            present(mImagePicker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        let cropController : PECropViewController = PECropViewController()
        cropController.delegate = self;
        cropController.image = chosenImage;
        cropController.keepingCropAspectRatio = true;
        cropController.cropAspectRatio = 1.5;
        cropController.isRotationEnabled = true;
        //controller.imageCropRect = CGRectMake((image.size.width  - 200) / 2 ,(image.size.height - 200) / 2,200,200);
        dismiss(animated:true, completion: nil)
        
        let controller   = UINavigationController(rootViewController: cropController )
        self.present(controller, animated: true, completion: nil)
        
        //mProductImages.append(chosenImage)
        // mProductCollection.reloadData()
        //mProductCollectionHeight.constant = mProductCollection.contentSize.height;
        //dismiss(animated:true, completion: nil) //5
        
    }
    func cropViewController(_ controller: PECropViewController, didFinishCroppingImage croppedImage: UIImage) {
        controller.dismiss(animated: true) { _ in }
        let chosenImage: UIImage? = self.image(with: croppedImage, scaledTo: CGSize(width: 400, height: 200))
        var dictionary:[String:AnyObject] = [:]
        //dictionary.updateValue(nil, forKey:"image_path")
        //dictionary.updateValue(nil, forKey:"image_id")
        dictionary.updateValue(chosenImage! as AnyObject , forKey:"image")
        mUpdateProductImages.append(dictionary)
        
        mProductCollection.reloadData()
        mProductCollectionHeight.constant = mProductCollection.contentSize.height;
        //dismiss(animated:true, completion: nil) //5
        
    }
    func image(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func cropViewControllerDidCancel(_ controller: PECropViewController) {
        controller.dismiss(animated: true) { _ in }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        if UIApplication.shared.keyWindow != nil {
            
            let userInfo = sender.userInfo as! [String: AnyObject] as NSDictionary
            let keyboardFrame1 = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! CGRect
            let windowFrame = self.view.window?.convert(self.view.frame, from: self.view)
            let keyBoardFrame = windowFrame?.intersection(keyboardFrame1)
            let coveredFrame: CGRect = view.window!.convert(keyBoardFrame!, to: view)
            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, coveredFrame.size.height , 0.0)
            
            mNewProductScrollView.contentInset = contentInsets;
            mNewProductScrollView.scrollIndicatorInsets = contentInsets;
            
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let contentInsets = UIEdgeInsets.zero;
        mNewProductScrollView.contentInset = contentInsets;
        mNewProductScrollView.scrollIndicatorInsets = contentInsets;
        
    }
    
    func removeProductImage(_ sender: UIButton) {
        let buttonPosition = (sender as UIButton).convert(CGPoint.zero, to: mProductCollection)
        if let indexPath = mProductCollection.indexPathForItem(at: buttonPosition) {
            
            mUpdateProductImages.remove(at: indexPath.row)
            mProductCollection.deleteItems(at: [IndexPath(row: indexPath.row, section: 0)])
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func updateNewProduct(_ sender: UIButton) {
        if(!validateFields()) {
            return;
        }
        updateProduct()

        
        
    }
    
    func validateFields()->Bool  {
        
        if(mProductNameTF.text == "") {
            return false
            KSToastView.ks_showToast("Please add product name")
            
            /*}else if(mProductCategory.title == "Select Category") {
             KSToastView.ks_showToast("Please select product category")
             return false*/
            
        }else if(mProductDescriptionTV.text == PLACE_HOLDER_TEXT) {
            KSToastView.ks_showToast("Please select product dixcription")
            return false
            
        }else if(mProductPrice.text == "") {
            KSToastView.ks_showToast("Please add product price")
            return false
            
        }else if(mProductStockTF.text == "") {
            KSToastView.ks_showToast("Please add product stock details")
            return false
            
        }else if (mUpdateProductImages.count == 0) {
            KSToastView.ks_showToast("Please add product Images")
            return false
            
        }else if(mDiscountEnableBtn.isSelected) {
            if(mDiscountsType.text == "") {
                KSToastView.ks_showToast("Please add Discount type you want to add")
                return false
            } else if(mDiscount.text == "") {
                KSToastView.ks_showToast("Please add Discount value")
                return false
            } else if(mDiscountFromDate.text == "") {
                KSToastView.ks_showToast("Please add Discount from date")
                return false
            }else if(mDiscountTillDate.text == "") {
                KSToastView.ks_showToast("Please add Discount till date")
                return false
            }
        }
        
        
        
        return true
        
        
    }
    
    
    
    func updateProduct() {
        
        
        let url = AppConstants.serviceClass.BASE_URL + AppConstants.serviceClass.UPDATE_PRODUCT
        let defaults = UserDefaults.standard
        var token : String = ""
        if let token1 = defaults.object(forKey: appDefaults.VENDOR_TOKEN) as? String {
            token = token1
            
        }else {
            
        }
        
        var id : String = ""
        if let dictionary = defaults.object(forKey: appDefaults.USER_PROFILE) as? [String:String] {
            id = dictionary["user_id"]!
            
        }
        
        var params : [String : Any] = [
            "product_name": mProductNameTF.text!,
            "product_description": mProductDescriptionTV.text,
            "category_id": (self.model?.productDetail?.category_id)! ,
            "sub_category_id": (self.model?.productDetail?.sub_category_id)! ,
            "id": (self.model?.productDetail?.id)!  ,
            "stock": mProductStockTF.text!,
            "price": mProductPrice.text!,
            "vendor_id": id,
            "set_discount":mDiscountEnableBtn.isSelected ? "1":"2"
            ]
        
        if(mDiscountEnableBtn.isSelected) {
            params.updateValue(mDiscountsType.text == "Flat" ? "2" : "1", forKey: "discount_type")
            params.updateValue(mDiscount.text! , forKey: "discount_value")
            
            params.updateValue(convertDateFormatForService(dateS:  mDiscountFromDate.text!)  , forKey: "start_time")
            params.updateValue(convertDateFormatForService(dateS:  mDiscountTillDate.text!) , forKey: "end_time")
            
        }
        
        var dictionary :[[String:UIImage]] = []
        var product_image:[String] = []
        var i = 0
        var j = 0
        
        /*
        for itm  in mUpdateProductImages {
            let item = itm as [String : AnyObject]
         
            if(item.count==1) {
                var dic = [String:UIImage]()
                let image = item["image"] as! UIImage
                dic.updateValue(image,forKey:"product_image[\(j)]")
                j = j+1
                dictionary.append(dic)

            }else {
                if let id = item["image_id"] as? String {
                    product_image.append(id )
                    let myInt = Int(id)
                    params.updateValue(myInt ?? 0 ,forKey:"existing_image_id[\(i)]")
                    i = i+1
                }else {
                    KSToastView.ks_showToast("Some Error")
                }
            }
        }*/
        //var index = 0
        for (_, itm) in mUpdateProductImages.enumerated()  {
            let item = itm as [String : AnyObject]
            var dic = [String:UIImage]()
            var image :UIImage? = nil
            if(item.count==1) {
                let img = item["image"] as! UIImage
                image = img
                
                
            }else {
                if let id = item["image_path"] as? String {
                    
                    if let image1 = SDImageCache.shared().imageFromDiskCache(forKey: id) {
                        //use image
                        image = image1
                    }
                    else if let image2 = SDImageCache.shared().imageFromMemoryCache(forKey: id) {
                        //use image
                        image = image2

                    }
              
                }
                
                

        
            }
            
            dic.updateValue(image!,forKey:"product_image[]")
            dictionary.append(dic)
        }
        
            
        
    
        
        /*
        if  product_image.count > 0  {
             let data = try! JSONSerialization.data(withJSONObject: product_image)
            let jsonString = String(data: data, encoding: .utf8)!
             params.updateValue(jsonString,forKey:"existing_image_id")
        }*/
       


        
        apiSharedObject.uploadMultipart(url: url, imageParams: dictionary, parameters: params,apiServicesDelegate: self, requestID : RequestID.updateProduct,showActivity:true);
        
        
    }
    
    
    func onSuccess(response: JSON, req_ID: Int) {
        
        if req_ID == RequestID.updateProduct{
            
            if(response["status"].boolValue == true) {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATIONS.productUpdated) , object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATIONS.newProductAdded) , object: nil)
                
                KSToastView.ks_showToast("Upload is Successfull")
                _ = self.navigationController?.popViewController(animated: true)
                
                
            }else {
                
                KSToastView.ks_showToast("Server encountered error please try after some time")
                _ = self.navigationController?.popViewController(animated: true)
                
                
            }
            
            
        }
        
    }
    
    func onFailure(error: Error, req_ID: Int) {
        
        
    }
    
    func selectCategorySelected(categoryName: [String : AnyObject]) {
        let title = categoryName["category_name"] as? String
        mSelectedCategory = categoryName
        mProductCategory.setTitle(title, for: .normal)
    }
    
    
    
}


extension EditProductVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (section==1) {
            return 1
        }
        return mUpdateProductImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProductImageCell
        
        if(indexPath.section == 0) {
            cell.mProductCancelBtn.alpha = 1
            let urlString = (mUpdateProductImages[indexPath.row]["image_path"])
            
            
            if(urlString != nil) {
                cell.mProductImage.sd_setImage(with: URL(string: urlString as! String), placeholderImage: nil)
            }else {
                let image = mUpdateProductImages[indexPath.row]["image"] as! UIImage
                cell.mProductImage.image = image
                
            }
            
            cell.mProductCancelBtn.addTarget(self, action:#selector(removeProductImage(_ :)), for: .touchUpInside)
        }else {
            cell.mProductCancelBtn.alpha = 0
            cell.mProductImage.image = UIImage(named : "add_picture")
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section==1) {
            if(mProductImages.count < MAXIMUM_PRODUCT_IMAGE) {
                self.showActionSheet(sender : UIButton())
            }else {
                KSToastView.ks_showToast("You can not add more images")
                
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: CGFloat(mItemSize), height: CGFloat(mItemSize))
        return size
    }
    
    
}


extension EditProductVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == mProductNameTF) {
            mProductDescriptionTV.becomeFirstResponder()
            return false
        }else if(textField == mProductPrice) {
            mProductStockTF.becomeFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == mProductPrice || textField == mDiscount) {
            let aSet = NSCharacterSet(charactersIn:".0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered

        }else if (textField == mProductStockTF ){
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered

        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        mTextField = textField
        return true
    }
    
}

extension EditProductVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == PLACE_HOLDER_TEXT) {
            textView.text = ""
            textView.textColor = UIColor.darkGray
            textView.becomeFirstResponder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            textView.text = PLACE_HOLDER_TEXT
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
        mProductPrice.becomeFirstResponder()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            self.view.endEditing(true)
            return false
        }
        return true
    }
}
