//
//  AddressBookVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 16/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "AddressBookVC.h"
#import "AddressCell.h"
#import "ContactsManager.h"
#import "ContactsData.h"
#import "AddContactVC.h"

@interface AddressBookVC () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation AddressBookVC

{
    
    NSMutableArray *mPhoneBook;
    NSMutableArray *mTempPhoneBook;
    NSMutableArray *mResultPhoneBook;
    ContactsManager *mContactsManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mAddNewContact.alpha = 0;
    mResultPhoneBook = [[NSMutableArray alloc] init];
    mContactsManager = [ContactsManager sharedInstance];
    mPhoneBook = mContactsManager.mPhoneBook;
    
    [_mSearchField layoutIfNeeded];
    [_mSearchBGVu layoutIfNeeded];
    _mSearchBGVu.layer.cornerRadius = _mSearchBGVu.layer.frame.size.height/2;
    _mSearchBGVu.layer.masksToBounds = YES;
    
    _mSearchField.delegate = self;
    
    [self checkPermissionAddressBook];
    
}


- (void) checkPermissionAddressBook {
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts])
    {
        case CNAuthorizationStatusNotDetermined:
        {
            
            [self showPermissionAlert];
            
            
        }
            break;
        case CNAuthorizationStatusRestricted:
        case CNAuthorizationStatusDenied:
            // Show custom alert
            [KSToastView ks_showToast:@"Contacts Permission Denied go to setting and change the permission"];
            [self openSettings];
            
            break;
        case CNAuthorizationStatusAuthorized:
            _mAddNewContact.alpha = 1;
            [mContactsManager getAllContact];
            [self setupCustomInit];
            break;
    }

}
- (void) checkPermissionAddressBook8 {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        
        // permission issue
        
        [KSToastView ks_showToast:@"Contacts Permission Denied go to setting and change the permission"];
        
        [self openSettings];
        return ;
        
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        // init phone book
        // [self fillandSortPhonebook:addressBook];
        [mContactsManager reloadPhoneBook];
        [self setupCustomInit];
        return;
        
    } else{
        [self showPermissionAlert];
        
    }
}


- (void)openSettings
{
    //BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if ((&UIApplicationOpenSettingsURLString) != NULL) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void) setupCustomInit {
    
    [_mSearchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    mTempPhoneBook = mPhoneBook;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 24, 24)];
    [imageview setClipsToBounds:YES];
    imageview.image = [UIImage imageNamed:@"search.png"] ;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 36)];
    [leftView addSubview:imageview];
    
    [_mSearchField setLeftViewMode:UITextFieldViewModeAlways];
    _mSearchField.leftView= leftView;
    
    
    // Do any additional setup after loading the view.
    _mAddressTable.delegate = self;
    _mAddressTable.dataSource  = self;
    _mAddressTable.estimatedRowHeight = 298;
    _mAddressTable.rowHeight = UITableViewAutomaticDimension;
    
    _mAddressTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _mAddressTable.estimatedSectionFooterHeight = 30;
    _mAddressTable.sectionFooterHeight = UITableViewAutomaticDimension ;
    
    _mAddressTable.estimatedSectionHeaderHeight = 30;
    _mAddressTable.sectionHeaderHeight = UITableViewAutomaticDimension ;
    
    [_mAddressTable reloadData];
    [_mAddressTable layoutIfNeeded];
    
    [self copyMemoryMap];

    
    
}


- (void) showPermissionAlert {
    [self.view bringSubviewToFront:_mPermissionVu];
    
}

- (void) hidePermissionAlert {
    [self.view sendSubviewToBack:_mPermissionVu];
    
}
- (void) copyMemoryMap {
    for (int i=0; i< mPhoneBook.count; i++) {
        NSDictionary *dic = [mPhoneBook objectAtIndex:i];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *searchdic= [[NSMutableDictionary alloc] initWithObjectsAndKeys:dic[@"title"],@"title",tempArray,@"contact", nil];
        [mResultPhoneBook addObject:searchdic];
        
    }

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mTempPhoneBook count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dic = [mTempPhoneBook objectAtIndex:section];
    NSMutableArray *contacts = dic[@"contact"];
    return [contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell creation...
    
    
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"AddressCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    }
    NSDictionary *dic = [mTempPhoneBook objectAtIndex:indexPath.section];
    NSMutableArray *contacts = dic[@"contact"];

    ContactsData *person =  [contacts objectAtIndex:indexPath.row];
    cell.mFullName.text = [NSString stringWithFormat:@"%@ %@",person.mFirstname, person.mLastname];
    if(person.mEmail == nil || [person.mEmail isEqualToString:@""])
        cell.mEmail.text = [NSString stringWithFormat:@"No Email Given"];
    else
        cell.mEmail.text = [NSString stringWithFormat:@"%@",person.mEmail];
    // display names based on section....
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString ;
    NSDictionary *dic= [mTempPhoneBook objectAtIndex:section];
    
    NSMutableArray *contacts = dic[@"contact"];
    if(contacts.count == 0)
        return nil;
    
    headerString = dic[@"title"];
    
    return headerString;
}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"AddressSectionHeaderView"
        owner:self
        options:nil];
    
    NSDictionary *dic = [mTempPhoneBook objectAtIndex:section];
    NSMutableArray *contacts = dic[@"contact"];
    
    if(contacts.count == 0)
        return nil;
    
    UIView* myView = [ nibViews objectAtIndex: 0];
    UILabel *lab = [myView viewWithTag:15];
    lab.text = dic[@"title"];
    
    return myView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"AddressSectionFooterView"
        owner:self
        options:nil];
    
    NSDictionary *dic = [mTempPhoneBook objectAtIndex:section];
    NSMutableArray *contacts = dic[@"contact"];
    if(contacts.count == 0)
        return nil;
    
    UIView* myView = [ nibViews objectAtIndex: 0];
    return myView;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = [mTempPhoneBook objectAtIndex:section];
    NSMutableArray *contacts = dic[@"contact"];
    if(contacts.count == 0)
        return 0;
    
    return UITableViewAutomaticDimension;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSDictionary *dic = [mTempPhoneBook objectAtIndex:section];
    NSMutableArray *contacts = dic[@"contact"];
    if(contacts.count == 0)
        return 0;
    
    return UITableViewAutomaticDimension;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    
    
    for (int i=0; i< mPhoneBook.count; i++) {
        NSDictionary *dic = [mPhoneBook objectAtIndex:i];
        NSArray *phoneBookArray = dic[@"contact"];
        NSMutableDictionary *resultdic = [mResultPhoneBook objectAtIndex:i];
        NSMutableArray *tempArray = resultdic[@"contact"];
        [tempArray removeAllObjects];
        
        for(int j = 0; j < phoneBookArray.count; j++) {
            ContactsData *person = [phoneBookArray objectAtIndex:j];
            
            if([person.mFirstname localizedStandardContainsString:_mSearchField.text] || [person.mLastname localizedStandardContainsString:_mSearchField.text]) {
                [tempArray addObject:person];
            }
        }
        
        if(tempArray.count > 0) {
            resultdic[@"title"] = dic [@"title"];
            
        }else {
            resultdic[@"title"] = nil;
        }
        
        
    }
    if([_mSearchField.text isEqualToString:@""]) {
        mTempPhoneBook = mPhoneBook ;
    }else {
        mTempPhoneBook = mResultPhoneBook ;
    }
    
    [_mAddressTable reloadData];

}


- (BOOL)textFieldShouldClear:(UITextField *)textField {

    mTempPhoneBook = mPhoneBook ;
    [_mAddressTable reloadData];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addNewContact:(id)sender {
    
    AddContactVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddContactVC"];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    
}




- (IBAction)doNotAskForPermission:(id)sender {
    [self hidePermissionAlert];
    
    
}


- (IBAction)permissionGranted:(id)sender {
    
    [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        [self hidePermissionAlert];
        if (granted == YES) {
            _mAddNewContact.alpha = 1;
            [mContactsManager getAllContact];
            [self setupCustomInit];
            
        }else {
            [KSToastView ks_showToast:@"Contacts Permission Denied go to setting and change the permission"];
            return;
        
        }
    }];
    /*
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hidePermissionAlert];

            if (!granted){
                [KSToastView ks_showToast:@"Contacts Permission Denied go to setting and change the permission"];
                return;
            }
            
            //ContactsManager *manager = [ContactsManager sharedInstance];
            //mPhoneBook = manager.mPhoneBook;

            //[manager reloadPhoneBook];
            [mContactsManager getAllContact];
            [self setupCustomInit];
        });
    });
    */
    
    
}




@end
