//
//  CategoriesVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 12/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "CategoriesVC.h"
#import "CategoryCell.h"
#import "CategoryDetailsVC.h"
#import "UIImageView+WebCache.h"

@interface CategoriesVC () <UICollectionViewDelegate, UICollectionViewDataSource, ApiServiceDelegate>

@end

@implementation CategoriesVC  {
    
    NSMutableArray *mCatgoriesArray;
    NSMutableArray *mCatgoriesName;
    NSMutableArray *mCatgories;
    float mCellHeight;
    float mCellWidth ;
    
    NSMutableArray *mCatgoriesArrayNew;
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    mCatgoriesArray = [[NSMutableArray alloc] initWithObjects:
                       [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"4" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"5" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"6" withExtension:@"png"],
                       [[NSBundle mainBundle] URLForResource:@"7" withExtension:@"png"],nil];
    
    
    mCatgoriesName = [[NSMutableArray alloc] initWithObjects:
                       @"Gift Her",@"Gift Him",@"Gift Little Ones",@"Gift All",@"Greeting Card",@"Experiences",nil];
    
    
    mCatgories  = [[NSMutableArray alloc] init];
    mCatgoriesArrayNew  = [[NSMutableArray alloc] init];
    
    for(int i = 0; i< 6; i++) {
        NSMutableDictionary *dic= [[NSMutableDictionary alloc] initWithObjectsAndKeys:[mCatgoriesArray objectAtIndex:i],@"image", [mCatgoriesName objectAtIndex:i],@"categoryname", nil];
        
        [mCatgories addObject:dic];
        
    }
    
    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenHeight = screenRect.size.height;
    CGFloat screenWidth = screenRect.size.width;
    mCellWidth = (screenWidth - 36) / 2;
    mCellHeight = (mCellWidth *3)/4.3;
    
    
    
    //**************************************************************
    
    [_mCategoriesCollection registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCell"];
    
    _mCategoriesCollection.delegate = self;
    _mCategoriesCollection.dataSource = self;
    
    _mCategoriesCollection.contentInset = UIEdgeInsetsMake(13, 13, 13, 13);
    
    UICollectionViewFlowLayout *floLayout = [[UICollectionViewFlowLayout alloc] init];
    floLayout.minimumInteritemSpacing = 0;
    floLayout.minimumLineSpacing = 0;
    floLayout.itemSize = CGSizeMake(mCellWidth, mCellHeight);
    [floLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_mCategoriesCollection setCollectionViewLayout:floLayout];
    
    [_mCategoriesCollection layoutIfNeeded];
    [_mCategoriesCollection reloadData];
    
    _mCategoriesCollectionHeight.constant = _mCategoriesCollection.contentSize.height +26 ;
    [self displayUserData];
    
    [self getCategoriesList];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated) name:kNotificationProfileUpdated object:nil];
    
    
}


- (void) profileUpdated {
    [self displayUserData];
}


- (void) displayUserData {
    NSDictionary *userProfile = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE];
    _mWelcomeMsg.text = [NSString stringWithFormat:@"Hi %@! ",userProfile[@"firstname"]];
    _mUserPoints.text = _mUserPoints.text = [NSString stringWithFormat:@"Pts %d", DataInstance.mGiftPoints];
    [_mProfileBtn layoutIfNeeded];
    [_mProfileBtn sd_setImageWithURL:[NSURL URLWithString:userProfile[@"profile_picture"]] forState:UIControlStateNormal];
    
    _mProfileBtn.layer.cornerRadius = _mProfileBtn.layer.frame.size.height/2;
    [_mProfileBtn setClipsToBounds:YES];
    _mProfileBtn.layer.masksToBounds  = YES;
}


#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [mCatgories count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CategoryCell";
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell layoutIfNeeded];
    
    NSDictionary *dic = [mCatgories objectAtIndex:indexPath.row];
    
    cell.mCategoryName.text = dic[@"categoryname"];
    cell.mBrowseText.alpha =  0;
    if([cell.mCategoryName.text isEqualToString:@"Greeting Card"] || [cell.mCategoryName.text isEqualToString:@"Last Minute Gifts"]) {
        cell.mBrowseText.alpha =  1;
    }
    
    //[cell.mCategoryImage sd_setImageWithURL:nil placeholderImage:nil];
    
    [cell.mCategoryImage sd_setImageWithURL:dic[@"image"] placeholderImage:DataInstance.mBlankImage];
    
    // return the cell
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(mCellWidth, mCellHeight);
    return size;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [mCatgories objectAtIndex:indexPath.row];
    NSLog(@"selected");
    CategoryDetailsVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailsVC"];
    controller.mCategoryDetail = dic;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCategoriesList {
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:FILE_GET_CATEGORIES withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_CATEGORIES];
    
    
}


- (void) onSuccessApiCall:(NSDictionary *)responseDict withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_GET_CATEGORIES) {
        NSDictionary *data = [responseDict copy];
        //[mCatgoriesArray removeAllObjects];
        NSArray *array = responseDict[@"categories"];
        if(array.count != mCatgories.count) {
            [KSToastView ks_showToast:@"category mismatch error"];
            return;
        }
        for(int i = 0; i< array.count; i++) {
            NSDictionary *dicData1 = array[i];
            NSMutableDictionary *dicData = mCatgories[i];
            [dicData addEntriesFromDictionary:dicData1];
            [mCatgories replaceObjectAtIndex:i withObject:dicData];
        }
        
        [_mCategoriesCollection reloadData];
    }
    
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_GET_GIFTPOINTS) {
        [KSToastView ks_showToast:@"Login Failure"];
        
    }
    
}



@end
