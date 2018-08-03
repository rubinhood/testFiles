//
//  ProfileVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 18/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "ProfileVC.h"
#import "EditProfileVC.h"
#import "MyWishlistCell.h"
#import "FrendzWishlistCell.h"
#import "AddressPendingRequestCell.h"
#import "ChangePassVC.h"

#define WISHLIST_COLUMS  4

@interface ProfileVC () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, ApiServiceDelegate>

@end

@implementation ProfileVC

{
    CGFloat mCellHeight;
    CGFloat mCellWidth ;
    NSMutableArray *mWishList;
    NSMutableArray *mFriendsWishList;
    NSMutableArray *mPendingAddressRequests;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mWishList = [[NSMutableArray alloc] init];
    mFriendsWishList = [[NSMutableArray alloc] init];
    mPendingAddressRequests = [[NSMutableArray alloc] init];

    
    _mAddressRequestTable.delegate = self;
    _mAddressRequestTable.dataSource = self;
    
    _mAddressRequestTable.estimatedRowHeight = 50;
    _mAddressRequestTable.rowHeight = UITableViewAutomaticDimension;
    
    [_mAddressRequestTable reloadData];
    [_mAddressRequestTable layoutIfNeeded];

    _mAddressRequestHeight.constant = _mAddressRequestTable.contentSize.height;

    // UICollectionview
    
    [_mProfileScrollVu layoutIfNeeded];
    [_mMyWishlistCollection layoutIfNeeded];
    //mCellWidth = (_mMyWishlistVu.frame.size.width - ((WISHLIST_COLUMS - 1) *3))/WISHLIST_COLUMS;
    
    mCellWidth = ((_mMyWishlistCollection.frame.size.width-24) /WISHLIST_COLUMS);
    
    mCellHeight = mCellWidth ;
    
    [_mMyWishlistCollection registerNib:[UINib nibWithNibName:@"MyWishlistCell" bundle:nil] forCellWithReuseIdentifier:@"MyWishlistCell"];
    
    _mMyWishlistCollection.delegate = self;
    _mMyWishlistCollection.dataSource = self;
    
    _mMyWishlistCollection.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UICollectionViewFlowLayout *floLayout = [[UICollectionViewFlowLayout alloc] init];
    floLayout.minimumInteritemSpacing = 0;
    floLayout.minimumLineSpacing = 0;
    floLayout.itemSize = CGSizeMake(mCellWidth, mCellHeight);
    [floLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_mMyWishlistCollection setCollectionViewLayout:floLayout];
    
    [_mMyWishlistCollection layoutIfNeeded];
    [_mMyWishlistCollection reloadData];
    
    //[self setUpHeightWishlist];
    _mMywishlistHeight.constant = 20 ;

    // UICollectionview
    
    
    [_mFrendzWishlistCollection registerNib:[UINib nibWithNibName:@"FrendzWishlistCell" bundle:nil] forCellWithReuseIdentifier:@"FrendzWishlistCell"];
    
    _mFrendzWishlistCollection.delegate = self;
    _mFrendzWishlistCollection.dataSource = self;
    
    _mFrendzWishlistCollection.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    
    
    UICollectionViewFlowLayout *floLayout1 = [[UICollectionViewFlowLayout alloc] init];
    floLayout1.minimumInteritemSpacing = 0;
    floLayout1.minimumLineSpacing = 0;
    floLayout1.itemSize = CGSizeMake(mCellWidth, mCellHeight);
    [floLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    [_mFrendzWishlistCollection setCollectionViewLayout:floLayout1];
    
    [_mFrendzWishlistCollection layoutIfNeeded];
    [_mFrendzWishlistCollection reloadData];
    [self setUpHeightFriendsWishlist];
    
    
    [self getUserGiftPoints];
    [self displayUserData];
    [self getMyWishList];
    [self getFriendsWishList];
    [self getPendingAddressList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileData) name:kNotificationProfileUpdated object:nil];
    
}
- (IBAction)backToPreviousController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) updateProfileData {
    [self displayUserData];
    
}

-(void)setUpHeightWishlist {
    CGFloat height = 8;
    if (mWishList.count > 0) {
        
        //int numberOfRow  = 1;
        int numberOfRow  = ((int)mWishList.count / 4 ) + ((mWishList.count%4 > 0 ) ? 1:0);
        height =  (mCellHeight *numberOfRow) + _mMyWishlistCollection.contentInset.top
        + _mMyWishlistCollection.contentInset.bottom;
    }
    
    _mMywishlistHeight.constant = height ;
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_mMyWishlistCollection.superview.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
    
}
-(void)setUpHeightFriendsWishlist {
    CGFloat height = 8;
    if (mFriendsWishList.count > 0) {
        
        //int numberOfRow  = 1;
        int numberOfRow  = ((int)mFriendsWishList.count / 4 ) + ((mFriendsWishList.count%4 > 0 ) ? 1:0);
        height =  (mCellHeight *numberOfRow) + _mFrendzWishlistCollection.contentInset.top
    + _mFrendzWishlistCollection.contentInset.bottom;
    }
    
    _mFrendzWishlistHeight.constant = height;
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_mFrendzWishlistCollection.superview.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}



- (void) displayUserData {
    NSDictionary *userProfile = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE];
    _mProfileName.text = [NSString stringWithFormat:@"%@ %@",userProfile[@"firstname"],userProfile[@"lastname"]];
    [_mGiftingPointsBtn setTitle:[NSString stringWithFormat:@"Gifting Points 00"] forState:UIControlStateNormal]; ;
    [_mProfileImage sd_setImageWithURL:[NSURL URLWithString:userProfile[@"profile_picture"]] placeholderImage:DataInstance.mBlankImage];
    
}



#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _mMyWishlistCollection) {
        return mWishList.count;
    }else if(collectionView == _mFrendzWishlistCollection) {
        return mFriendsWishList.count;
    }
    
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if(collectionView == _mMyWishlistCollection) {
        static NSString *cellIdentifier = @"MyWishlistCell";
        MyWishlistCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell layoutIfNeeded];
        NSDictionary *data = [mWishList objectAtIndex:indexPath.row];
        NSString *stringImage = data[@"image_url"];
        [cell.mWishImage sd_setImageWithURL:[NSURL URLWithString:stringImage] placeholderImage:DataInstance.mBlankImage];
        // return the cell
        return cell;

        
    }else if(collectionView == _mFrendzWishlistCollection) {
        static NSString *cellIdentifier = @"FrendzWishlistCell";
        FrendzWishlistCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell layoutIfNeeded];
        // return the cell
        
        NSDictionary *data = [mFriendsWishList objectAtIndex:indexPath.row];
        NSString *stringImage = data[@"image_url"];
        cell.mFrendzName.text = data[@"contact_name"];
        [cell.mFrendzWishImage sd_setImageWithURL:[NSURL URLWithString:stringImage] placeholderImage:DataInstance.mBlankImage];

        return cell;

        
    }
    
    return cell;
}






#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"selected");
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mPendingAddressRequests.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell creation...
    AddressPendingRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressPendingRequestCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AddressPendingRequestCell" bundle:nil] forCellReuseIdentifier:@"AddressPendingRequestCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddressPendingRequestCell"];
    }
    NSDictionary *data = [mPendingAddressRequests objectAtIndex:indexPath.row];
    cell.mFrendsName.text = data[@"contact"];
    [cell.mFrendsRequestAgainBtn addTarget:self action:@selector(requestAddressAgain:) forControlEvents:UIControlEventTouchUpInside];
    
    // display names based on section....
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void) requestAddressAgain:(UIButton *) sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_mAddressRequestTable];
    NSIndexPath *indexPath = [_mAddressRequestTable indexPathForRowAtPoint:buttonPosition];
    NSDictionary *data = [mPendingAddressRequests objectAtIndex:indexPath.row];
    [self reRequestPendingAddress:data];
}

- (IBAction)editProfile:(id)sender {
    EditProfileVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)getUserGiftPoints {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSString *url = [NSString stringWithFormat:@"%@%@",FILE_GET_GIFTPOINTS,token];
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:url withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_GIFTPOINTS];
    
    
}

- (void)getMyWishList {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSString *url = [NSString stringWithFormat:@"%@%@",FILE_GET_MY_WISHLIST,token];
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:url withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_MY_WISHLIST];
    
    
}

- (void)getFriendsWishList {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSString *url = [NSString stringWithFormat:@"%@%@",FILE_GET_FRIENDS_WISHLIST,token];
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:url withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_FRIENDS_WISHLIST];
    
    
}

- (void)getPendingAddressList {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSString *url = [NSString stringWithFormat:@"%@%@",FILE_PENDING_ADDRESS_LIST,token];
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:url withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_PENDING_ADDRESS_LIST];
    
    
}

- (void)reRequestPendingAddress:(NSDictionary*) data {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:AUTH_KEY];
    [params setObject:data[@"contact_id"] forKey:@"contact_id"];

    [[HTTPConnection sharedInstance] apiCall_HTTPConnection:params withFile:FILE_REREQUEST_ADDRESS withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_REREQUEST_ADDRESS];
}



- (void) onSuccessApiCall:(NSDictionary *)responseDict withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_GET_GIFTPOINTS) {
        NSDictionary *data = [responseDict copy];
        [_mGiftingPointsBtn setTitle:[NSString stringWithFormat:@"Gifting Points %@", data[@"points"] ] forState:UIControlStateNormal];
    }
    if(serviceNumber == SERVICE_GET_MY_WISHLIST) {
        NSDictionary *data = [responseDict copy];
        [mWishList removeAllObjects];
        [mWishList addObjectsFromArray:data[@"wishlist_products"]];
        [_mMyWishlistCollection reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpHeightWishlist];
            _mMyWishlistCount.text = [NSString stringWithFormat:@"My Wishlist (%lu)",(unsigned long)mWishList.count];
        });
    }
    if(serviceNumber == SERVICE_GET_FRIENDS_WISHLIST) {
        NSDictionary *data = [responseDict copy];
        [mFriendsWishList removeAllObjects];
        [mFriendsWishList addObjectsFromArray:data[@"friends_wish_list"]];
        [_mFrendzWishlistCollection reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpHeightFriendsWishlist];
            _mFrendzWishlistCount.text = [NSString stringWithFormat:@"Friend's Wishlist (%lu)",(unsigned long)mFriendsWishList.count];
        });

    }
    if(serviceNumber == SERVICE_PENDING_ADDRESS_LIST) {
        NSDictionary *data = [responseDict copy];
        [mPendingAddressRequests removeAllObjects];
        [mPendingAddressRequests addObjectsFromArray:data[@"requests"]];
        [_mAddressRequestTable reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _mAddressRequestHeight.constant = _mAddressRequestTable.contentSize.height + 2;
            
        });
        
        
    }if(serviceNumber == SERVICE_REREQUEST_ADDRESS) {
        NSDictionary *data = [responseDict copy];
        [KSToastView ks_showToast:data[@"massage"]];
        
    }

}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_LOGIN) {
        [KSToastView ks_showToast:@"Login Failure"];
        
    }
    
}

@end
