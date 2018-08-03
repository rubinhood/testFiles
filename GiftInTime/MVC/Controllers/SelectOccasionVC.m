//
//  SelectOccasionVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 10/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "SelectOccasionVC.h"
#import "OccasionsCell.h"
#import "CardCollectionsCell.h"
#import "UIColor+ColorHex.h"
#import "UIImageView+WebCache.h"


@interface SelectOccasionVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation SelectOccasionVC

{
    float mCellWidth;
    float mCellHeight;

    NSArray *mOccasions;
    NSArray *mCards;
    NSString *mSelectedOccasionString;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mOccasions = @[@"Wedding", @"Happy Birthday",@"Baby Shower",@"Anniversary",@"Fight",@"Love",@"Friendship"];
    
    
    mCards = @[
                   @"http://imagespng.com/Data/DownloadLogo/Fence-PNG-Picture.png",
                   @"http://images4.fanpop.com/image/photos/21700000/Colourful-beautiful-pictures-21759835-400-200.png",
                   @"http://dp.profilepics.in/profile_pictures/independence-day/independence-day-profile-pictures-dp-for-whatsapp-facebook-162.jpg",
                   @"http://images4.fanpop.com/image/photos/21700000/Colourful-beautiful-pictures-21759836-400-200.png"];
    
    // Do any additional setup after loading the view.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    mCellHeight = screenHeight *0.12;
    mCellWidth =  (mCellHeight *4 )/3;
    
   
    
    //**************************************************************
    
    [_mCardCollection registerNib:[UINib nibWithNibName:@"CardCollectionsCell" bundle:nil] forCellWithReuseIdentifier:@"CardCollectionsCell"];
    
    _mCardCollection.delegate = self;
    _mCardCollection.dataSource = self;
    
    
    
    UICollectionViewFlowLayout *floLayout = [[UICollectionViewFlowLayout alloc] init];
    floLayout.minimumInteritemSpacing = 0;
    floLayout.minimumLineSpacing = 0;
    floLayout.itemSize = CGSizeMake(mCellWidth, mCellHeight);
    [floLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_mCardCollection setCollectionViewLayout:floLayout];
    
    [_mCardCollection layoutIfNeeded];
    [_mCardCollection reloadData];
    
    _mCardCollectionHeight.constant = mCellHeight +15 ;
    //_mCardCollection.contentInset = UIEdgeInsetsMake(0, 10, 00, 0);

    
    //*********************************************************
    
    [_mOccasionCollection registerNib:[UINib nibWithNibName:@"OccasionsCell" bundle:nil] forCellWithReuseIdentifier:@"OccasionsCell"];
    
    _mOccasionCollection.delegate = self;
    _mOccasionCollection.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [_mOccasionCollection setCollectionViewLayout:flowLayout];

    [_mOccasionCollection layoutIfNeeded];
    [_mOccasionCollection reloadData];
    
    _mOccasionCollectionHeight.constant = 55;
    //_mOccasionCollection.contentInset = UIEdgeInsetsMake(10, 10, 10, 15);
    ////////////////////////////////////////////////
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _mOccasionCollection) {
        return [mOccasions count];
    }else if (collectionView == _mCardCollection) {
        
        return [mCards count];
        //return 5;

    }

    return 12;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell ;
    
    if(collectionView == _mOccasionCollection) {
        static NSString *cellIdentifier = @"OccasionsCell";
        OccasionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        NSString *string = [mOccasions objectAtIndex:indexPath.row];
        cell.mOccasionText.text = string;
        cell.mOccasionText.textColor = [UIColor darkGrayColor] ;
        cell.mBgVu.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell layoutIfNeeded];
        if([string isEqualToString:mSelectedOccasionString]) {
            cell.mOccasionText.textColor = [UIColor HexColorWithAlpha:0xff86D2C1] ;
            cell.mBgVu.layer.borderColor = [UIColor HexColorWithAlpha:0xff86D2C1].CGColor;

        }
        
        return cell;

    }else if(collectionView == _mCardCollection){
        static NSString *cellIdentifier = @"CardCollectionsCell";
        CardCollectionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
        
        NSString *cardImage = [mCards objectAtIndex:indexPath.row];
        
        //[cell.mImageVu sd_setImageWithURL:[NSURL URLWithString:cardImage] placeholderImage:[UIImage imageNamed:@"banner_shop.jpg"]];

        [cell.mImageVu sd_setImageWithURL:[NSURL URLWithString:cardImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"Completed");
        }];
        
        return cell;

        
        
    }
    // return the cell
    return cell;
}

/*

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if(collectionView == _mCardCollection) {
        
        NSString *string = [mOccasions objectAtIndex:indexPath.row];
        CGSize calCulateSizze =[string sizeWithAttributes:NULL];
        size = CGSizeMake(calCulateSizze.width+16, 50);
        return size;

    }
    return size;

}*/

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == _mOccasionCollection) {
        
        OccasionsCell *cell  = (OccasionsCell*)[_mOccasionCollection cellForItemAtIndexPath:indexPath];
        mSelectedOccasionString = cell.mOccasionText.text;
        [_mOccasionCollection reloadData];
        
    } else if(collectionView == _mCardCollection) {
        
        NSString *cardImage = [mCards objectAtIndex:indexPath.row];
        
        [_mPreviewCard sd_setImageWithURL:[NSURL URLWithString:cardImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"Completed");
        }];
        
    }
}



- (IBAction)backToPreviousController:(id)sender {
    
    [self.navigationController  popViewControllerAnimated:YES];
    
}
- (IBAction)mHideInformationView:(id)sender {
    
    [self.view sendSubviewToBack:_mCameraInformationBGVu ];
    
}

- (IBAction)showCameraInformationVu:(id)sender {
    
    
    [self.view bringSubviewToFront:_mCameraInformationBGVu ];

    
    CGAffineTransform transform = CGAffineTransformMakeScale(0.5, 0.5);
    _mCameraInformation.transform = transform;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            _mCameraInformation.transform = CGAffineTransformIdentity;
                            
                        } completion:^(BOOL finished) {
                            // cool code here
                            
                        }];

    
}


@end
