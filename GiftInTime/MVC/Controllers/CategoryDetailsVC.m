//
//  CategoryDetailsVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 09/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "CategoryDetailsVC.h"
#import "CategoryDetailsCell.h"
#import "GiftDetailsVC.h"

@interface CategoryDetailsVC () <UICollectionViewDelegate, UICollectionViewDataSource, ApiServiceDelegate>

@end

@implementation CategoryDetailsVC
{
    
    NSMutableArray *mCatgoriesArray;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mCatgoriesArray = [[NSMutableArray alloc] init];
    /*
    mCatgoriesArray = [[NSMutableArray alloc] initWithObjects:
                       [[NSBundle mainBundle] URLForResource:@"8" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"9" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"10" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"11" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"8" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"9" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"10" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"11" withExtension:@"png"],nil];*/
    
    
    
    [_mProductCollection registerNib:[UINib nibWithNibName:@"CategoryDetailsCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryDetailsCell"];
    
    _mProductCollection.delegate = self;
    _mProductCollection.dataSource = self;
    [_mProductCollection layoutIfNeeded];
    [_mProductCollection reloadData];
    _mProductCollection.contentInset = UIEdgeInsetsMake(10, 10, 10, 15);

    _mTitleLabel.text = _mCategoryDetail[@"categoryname"];
    [self getSubCategoriesList];
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mCatgoriesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CategoryDetailsCell";
    CategoryDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell layoutIfNeeded];
        // return the cell
    
    NSDictionary *data = [mCatgoriesArray objectAtIndex:indexPath.row];
    
    [cell.mProductFavBtn addTarget:self action:@selector(favoritedProduct:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mProductGiftBtn addTarget:self action:@selector(giftNowProduct:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.row%2 == 0) {
        cell.mProductFavBtn.selected = YES;
    }else {
        cell.mProductFavBtn.selected = NO;
  
    }
    cell.mProductName.text = data[@"name"];
    
    cell.mProductPrice.text = [NSString stringWithFormat:@"%@ %@",data[@"cost_currency"],data[@"price"]];
    NSArray *array = data[@"master_variant_images"];
    NSString *stringUrl = nil;
    if(array.count > 0)
        stringUrl = data[@"master_variant_images"][0];
    [cell.mProductImage sd_setImageWithURL:[NSURL URLWithString:stringUrl] placeholderImage:DataInstance.mBlankImage];
    
    [self getPrintedLabelTop:cell.mProductCityState withData:data[@"city_or_state"] withPrefix:@" "];
    [self getPrintedLabel:cell.mProductBy withData:data[@"user"][@"company_name"] withPrefix:@"By "];
    
    return cell;
}


- (void) getPrintedLabel:(UILabel *) label withData:(NSString *)stringData withPrefix:(NSString *)prefix {
    label.text = [NSString stringWithFormat:@"Not Specified"];
    if(![stringData isEqualToString:@""])
        label.text = [NSString stringWithFormat:@"%@%@",prefix,stringData];

}

- (void) getPrintedLabelTop:(UILabel *) label withData:(NSString *)stringData withPrefix:(NSString *)prefix {
    label.text = [NSString stringWithFormat:@" Not Specified"];
    if(![stringData isEqualToString:@""])
        label.text = [NSString stringWithFormat:@"%@%@",prefix,stringData];
    
}

- (void) favoritedProduct:(UIButton *) sender {
    sender.selected = !sender.selected;
    [self addTowishlist:sender];
    //CGPoint hitPoint = [sender convertPoint:CGPointZero toView:_mProductCollection];
    //NSIndexPath *hitIndex = [_mProductCollection indexPathForItemAtPoint:hitPoint];
}

- (void)addTowishlist:(UIButton *) sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:_mProductCollection];
    NSIndexPath *hitIndex = [_mProductCollection indexPathForItemAtPoint:hitPoint];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSDictionary *data = [mCatgoriesArray objectAtIndex:hitIndex.row];
    [params setObject:token forKey:AUTH_KEY];
    [params setObject:data[@"master_variant_id"] forKey:@"variant_id"];
    [params setObject:@(1) forKey:@"quantity"];
    
    [[HTTPConnection sharedInstance] apiCall_HTTPConnection:params withFile:FILE_ADDTO_WISHLIST withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_ADDTO_WISHLIST];
}



- (void) giftNowProduct:(UIButton *) sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:_mProductCollection];
    NSIndexPath *hitIndex = [_mProductCollection indexPathForItemAtPoint:hitPoint];
    NSDictionary *data = [mCatgoriesArray objectAtIndex:hitIndex.row];
    NSLog(@"selected");
    [self getProductDetails:data[@"product_url"]];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = (screenWidth-35) / 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth+113);
    
    return size;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backToPreviousController:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
    
}


- (void)getSubCategoriesList {
    NSString *urlString = _mCategoryDetail[@"url"];
    if([urlString hasPrefix:ServerPath]) {
        urlString = [urlString substringFromIndex:[ServerPath length]];
    }
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:urlString withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_SUBCATEGORIES];

}

- (void)getProductDetails:(NSString*) urlString {
    if([urlString hasPrefix:ServerPath]) {
        urlString = [urlString substringFromIndex:[ServerPath length]];
    }
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:urlString withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_PRODUCT_DETAILS];
    
}


- (void) onSuccessApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_GET_SUBCATEGORIES) {
        if([data[@"code"] intValue] != 200) {
            return ;
        }
        //[KSToastView ks_showToast:data[@"message"]];
        [mCatgoriesArray removeAllObjects];
        [mCatgoriesArray addObjectsFromArray:data[@"products"]];
        [_mProductCollection reloadData];
        
    
    } if(serviceNumber == SERVICE_GET_PRODUCT_DETAILS) {
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
    if(serviceNumber == SERVICE_ADDTO_WISHLIST) {
        [KSToastView ks_showToast:data[@"message"]];
        
    }

    
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_GET_GIFTPOINTS) {
        [KSToastView ks_showToast:@"Login Failure"];
        
    }
    
}




@end
