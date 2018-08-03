//
//  MyCartVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 11/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "MyCartVC.h"
#import "CartProductDetailCell.h"
#import "CartSavedCardsCell.h"
#import "CartPaymentOptionCell.h"

@interface MyCartVC () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyCartVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _mProductDetailsTable.delegate = self;
    _mProductDetailsTable.dataSource  = self;
    _mProductDetailsTable.estimatedRowHeight = 298;
    _mProductDetailsTable.rowHeight = UITableViewAutomaticDimension;
    
    [_mProductDetailsTable reloadData];
    [_mProductDetailsTable layoutIfNeeded];
    
    _mProductDetailsHeight.constant = _mProductDetailsTable.contentSize.height;

    // Saved card Table
    
    _mSavedCardTable.delegate = self;
    _mSavedCardTable.dataSource  = self;
    _mSavedCardTable.estimatedRowHeight = 60;
    _mSavedCardTable.rowHeight = UITableViewAutomaticDimension;
    
    [_mSavedCardTable reloadData];
    [_mSavedCardTable layoutIfNeeded];
    
    _mSavedCardTableHeight.constant = _mSavedCardTable.contentSize.height;
    
    // Payment Option Height
    
    _mPaymentOptionTable.delegate = self;
    _mPaymentOptionTable.dataSource  = self;
    _mPaymentOptionTable.estimatedRowHeight = 40;
    _mPaymentOptionTable.rowHeight = UITableViewAutomaticDimension;
    
    [_mPaymentOptionTable reloadData];
    [_mPaymentOptionTable layoutIfNeeded];
    
    _mPaymentOptionHeight.constant = _mPaymentOptionTable.contentSize.height;


    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == _mProductDetailsTable) {
        return 3;
    }else if (tableView == _mSavedCardTable) {
        return 2;

    }else if (tableView == _mPaymentOptionTable) {
        return 2;
        
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell creation...
    UITableViewCell *cell;
    
    if(tableView == _mProductDetailsTable) {
        CartProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartProductDetailCell"];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CartProductDetailCell" bundle:nil] forCellReuseIdentifier:@"CartProductDetailCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartProductDetailCell"];
        }
        
        cell.mShowAddressBtn.tag = indexPath.row;
        
        
        [cell.mShowAddressBtn addTarget:self action:@selector(showHideAddressDetails:) forControlEvents:UIControlEventTouchDown];
        
        // display names based on section....
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(tableView == _mSavedCardTable) {
        
        CartSavedCardsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartSavedCardsCell"];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CartSavedCardsCell" bundle:nil] forCellReuseIdentifier:@"CartSavedCardsCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartSavedCardsCell"];
        }
        
        // display names based on section....
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if(tableView == _mPaymentOptionTable) {
        
        CartPaymentOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartPaymentOptionCell"];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"CartPaymentOptionCell" bundle:nil] forCellReuseIdentifier:@"CartPaymentOptionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartPaymentOptionCell"];
        }
        
        // display names based on section....
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    return cell;
}



- (void)showHideAddressDetails:(UIButton*) sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_mProductDetailsTable];
    NSIndexPath *indexPath = [_mProductDetailsTable indexPathForRowAtPoint:buttonPosition];
    
    CartProductDetailCell *cell = [_mProductDetailsTable cellForRowAtIndexPath:indexPath];
    
    if(cell.mAddressView.alpha == 0) {
        
        cell.mAddressView.alpha = 1;
        cell.mAddressHeight.constant =  475;
        
    }else {
        cell.mAddressView.alpha = 0;
        cell.mAddressHeight.constant =  0;
    }
    
    
    [UIView transitionWithView: _mProductDetailsTable
                      duration: 0.35f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void)
     {
         [_mProductDetailsTable reloadData];
         
         [_mProductDetailsTable layoutIfNeeded];
         _mProductDetailsHeight.constant = _mProductDetailsTable.contentSize.height;

     }
                    completion: nil];
   
    //[_mProductDetailsTable beginUpdates];
    //NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
    //[_mProductDetailsTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
    //[_mProductDetailsTable endUpdates];
    /*[UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
    } completion:nil];*/
    
        
    

    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToPreviousController:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
