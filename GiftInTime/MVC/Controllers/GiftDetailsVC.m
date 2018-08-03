//
//  GiftDetailsVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 09/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "GiftDetailsVC.h"
#import "GiftDetailsOtherCell.h"
#import "EditableResponderBtn.h"

@interface GiftDetailsVC () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDelegate, ApiServiceDelegate>

@end

@implementation GiftDetailsVC
{
    NSMutableArray *mImageData ;
    NSInteger mTotalPicture;
    NSTimer *mTimer;
    float mCellWidth;
    NSArray *mVendorData;
    UIPickerView *mPickerVu;
    NSMutableArray *mVariantOptions;
    NSString *mSelectedOption;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    mImageData = [[NSMutableArray alloc] init];
    mVariantOptions = [[NSMutableArray alloc] init];

    [self getProductDetails];
    mTotalPicture = [_mProductData[@"master_variant_images"] count];
    _mPictureScroll.delegate  = self;
    [_mPictureScroll.superview.superview layoutIfNeeded];
    [_mPictureScroll layoutIfNeeded];
    
    _mPageControl.numberOfPages = mTotalPicture;
    _mPageControl.currentPage = 0;
    [self setupScroller];
    
    
    //mTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(slideToNextPage) userInfo:nil repeats:YES];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    mCellWidth = (screenWidth-40) / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.

    
    mVendorData =_mProductData[@"vendor_products"];
    
    [_mOtherCollection registerNib:[UINib nibWithNibName:@"GiftDetailsOtherCell" bundle:nil] forCellWithReuseIdentifier:@"GiftDetailsOtherCell"];
    
    _mOtherCollection.delegate = self;
    _mOtherCollection.dataSource = self;
    [_mOtherCollection layoutIfNeeded];
    [_mOtherCollection reloadData];
    [_mOtherCollection layoutIfNeeded];

    _mOtherColectionHeight.constant = mCellWidth +5;
    //_mOtherCollection.contentInset = UIEdgeInsetsMake(10, 10, 10, 15);
    [self setUpPicker:_mOptionsBtn];
    
}

- (void) setupScroller {
    [_mPictureScroll layoutIfNeeded];
    _mPictureScroll.backgroundColor = [UIColor whiteColor];
    if(mTotalPicture == 0) {
        UIImageView *ivu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mPictureScroll.frame.size.width, _mPictureScroll.frame.size.height)];
        //ivu.image = [mImageData objectAtIndex:i];
        [ivu sd_setImageWithURL:nil placeholderImage:DataInstance.mBlankImage];//DataInstance.mNoImage
        [_mPictureScroll addSubview:ivu];
        _mPictureScroll.contentSize = CGSizeMake(_mPictureScroll.frame.size.width * mTotalPicture , _mPictureScroll.frame.size.height);
        return;
        
    }
    
    for(int i=0; i< mTotalPicture; i++) {
        UIImageView *ivu = [[UIImageView alloc] initWithFrame:CGRectMake(_mPictureScroll.frame.size.width *i, 0, _mPictureScroll.frame.size.width, _mPictureScroll.frame.size.height)];
        //ivu.image = [mImageData objectAtIndex:i];
        [ivu sd_setImageWithURL:[NSURL URLWithString:[_mProductData[@"master_variant_images"] objectAtIndex:i]] placeholderImage:DataInstance.mBlankImage];//DataInstance.mNoImage
        [_mPictureScroll addSubview:ivu];
        
    }
    _mPictureScroll.contentSize = CGSizeMake(_mPictureScroll.frame.size.width * mTotalPicture , _mPictureScroll.frame.size.height);
    
}

-(void) getProductDetails {
    _mProductName.text = [NSString stringWithFormat:@"%@",  _mProductData[@"name"]];
    _mOriginalPrice.text = [NSString stringWithFormat:@"%@ %@",  _mProductData[@"cost_currency"],_mProductData[@"price"]];
    _mDiscountedPrice .text = [NSString stringWithFormat:@"%@ %@",  _mProductData[@"cost_currency"],_mProductData[@"price"]];
    _mDiscountPercentage.text = [NSString stringWithFormat:@"(0 %%)"];
    _mByStore.text =[NSString stringWithFormat:@"By %@",  _mProductData[@"user"][@"firstname"]];
    
    
    _mProductDetails.attributedText = [self getAttributedString:_mProductData[@"description"]];
    _mShippingDetails.attributedText = [self getAttributedString:_mProductData[@"shipping_and_returns"]];
    
   
}

- (NSMutableAttributedString *) getAttributedString:(NSString *)stringData {
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[stringData dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSRange range = (NSRange){0,[newString length]};
    
    UIFont *font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:13.0];
        UIColor *color = [UIColor grayColor]; // select needed color
    NSDictionary *attrbs = @{ NSForegroundColorAttributeName : color , NSFontAttributeName : font };
    [newString addAttributes:attrbs range:range];
    newString = [self  attributedStringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] withAttribStr:newString];
    
    return newString;
    
}

- (NSMutableAttributedString *)attributedStringByTrimmingCharactersInSet:(NSCharacterSet *)set withAttribStr:(NSMutableAttributedString *) newStr{
    
    NSRange range;
    
    // First clear any characters from the set from the beginning of the string
    range = [[newStr string] rangeOfCharacterFromSet:set];
    while (range.length != 0 && range.location == 0)
    {
        [newStr replaceCharactersInRange:range
                              withString:@""];
        range = [[newStr string]
                 rangeOfCharacterFromSet:set];
    }
    
    // Then clear them from the end
    range = [[newStr string] rangeOfCharacterFromSet:set
                                             options:NSBackwardsSearch];
    while (range.length != 0 && NSMaxRange(range) ==
           [newStr length]) {
        [newStr replaceCharactersInRange:range withString:@""];
        range = [[newStr string] rangeOfCharacterFromSet:set options:NSBackwardsSearch];
    }
    
    return newStr;
}
- (IBAction)addTowishListAction:(id)sender {
    [self addTowishlist];
}

- (void)addTowishlist {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:AUTH_KEY];
    [params setObject:_mProductData[@"master_variant_id"] forKey:@"variant_id"];
    [params setObject:@(1) forKey:@"quantity"];
    
    [[HTTPConnection sharedInstance] apiCall_HTTPConnection:params withFile:FILE_ADDTO_WISHLIST withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_ADDTO_WISHLIST];
}
- (void)getProductDetails:(NSString*) urlString {
    if([urlString hasPrefix:ServerPath]) {
        urlString = [urlString substringFromIndex:[ServerPath length]];
    }
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:urlString withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_PRODUCT_DETAILS];
    
}




- (void) onSuccessApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_ADDTO_WISHLIST) {
        [KSToastView ks_showToast:data[@"message"]];
        
    }if(serviceNumber == SERVICE_GET_PRODUCT_DETAILS) {
        if([data[@"code"] intValue] != 200) {
            return ;
        }
        [KSToastView ks_showToast:data[@"message"]];
        GiftDetailsVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftDetailsVC"];
        NSArray *dataArray = data[@"product"];
        if(dataArray.count==0) {
            [KSToastView ks_showToast:@"Could not fetch product Details"];
        }
        controller.mProductData = dataArray[0] ;
        [self.navigationController pushViewController:controller animated:YES];
    }

    
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_ADDTO_WISHLIST) {
        [KSToastView ks_showToast:@"Login Failure"];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    _mPageControl.currentPage = (int)currentPage;
    
}


- (void) slideToNextPage {
    CGFloat offset = _mPictureScroll.contentOffset.x;
    CGFloat NextPagePosition = offset + _mPictureScroll.frame.size
    .width ;
    
    if(NextPagePosition >= (_mPictureScroll.frame.size
                            .width *(mTotalPicture)) ) {
        NextPagePosition = 0;
    }
    [_mPictureScroll scrollRectToVisible:CGRectMake(NextPagePosition, 0, _mPictureScroll.frame.size.width, _mPictureScroll.frame.size.height) animated:YES];
}





#pragma UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
 
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mVendorData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GiftDetailsOtherCell";
    GiftDetailsOtherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell layoutIfNeeded];
    int objIndex = (int)indexPath.row ;
    NSLog(@"%d",objIndex);
    NSDictionary *data = [mVendorData objectAtIndex:objIndex];
    NSArray *imageData = data[@"master_variant_images"] ;
    NSString *imageUrl = nil;
    if(imageData.count != 0) {
        imageUrl = [imageData objectAtIndex:0];
    }
    
    [cell.mVendorProductImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DataInstance.mBlankImage];
    
    // return the cell
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(mCellWidth, mCellWidth);
    return size;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"selected");
    NSDictionary *data = [mVendorData objectAtIndex:indexPath.row];
    [self getProductDetails:data[@"product_url"]];
    
    
    // StoreVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreVC"];
    //[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)backToPreviousController:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
    
}

- (IBAction)openVariantsOptionSelection:(EditableResponderBtn *)sender {
    [sender becomeFirstResponder];
 
}


- (void) setUpPicker:(EditableResponderBtn *) sender {
    mPickerVu = [[UIPickerView alloc] init];
    mPickerVu.backgroundColor = [UIColor whiteColor];
    mPickerVu.delegate = self;
    mPickerVu.dataSource = self;
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar sizeToFit];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showPickedDone)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPicker)];
    doneBtn.tintColor = [UIColor whiteColor];
    cancelBtn.tintColor = [UIColor whiteColor];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil action:nil];
    toolbar.translucent = NO;
    toolbar.barTintColor = [UIColor HexColorWithAlpha:APP_GREEN_COLOR];
    [toolbar setItems:[NSArray arrayWithObjects:cancelBtn,flexibleSpaceLeft, doneBtn , nil]];
    [sender setInputAccessoryView:toolbar];
    sender.inputView = mPickerVu;
    
}

- (void) showPickedDone {
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:YES];
    
}


- (void) cancelPicker {
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - PickeRViewDelegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        return mVariantOptions.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return mVariantOptions[row][@"name"];
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        mSelectedOption = mVariantOptions[row];
    
}

- (IBAction)shareItemLink:(id)sender {
    NSString *stringUrl = @"www.google.com";
    NSArray *links = @[stringUrl];
    [self shareText:links];

}

- (void)shareText:(NSArray *) links {
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:links applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
@end
