//
//  AddressBookVC.h
//  GiftInTime
//
//  Created by Telugu Desham  on 16/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mAddressTable;
@property (weak, nonatomic) IBOutlet UITextField *mSearchAddressField;
@property (weak, nonatomic) IBOutlet UITextField *mSearchField;
@property (weak, nonatomic) IBOutlet UIView *mPermissionVu;
@property (weak, nonatomic) IBOutlet UIView *mPermissionAlertVu;
@property (weak, nonatomic) IBOutlet UIView *mSearchBGVu;

@property (weak, nonatomic) IBOutlet UIButton *mAddNewContact;


@end
