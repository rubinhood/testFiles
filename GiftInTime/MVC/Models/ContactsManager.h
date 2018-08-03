//
//  ContactsManager.h
//  GiftInTime
//
//  Created by Telugu Desham  on 17/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@interface PhoneBookEntry : NSObject


@property (strong, nonatomic) NSString *mContactsTitle ;
@property (strong, nonatomic) NSMutableArray *mContacts ;

@end


@interface ContactsManager : NSObject

@property (assign, nonatomic) ABAddressBookRef mAddressBook;
@property (strong, nonatomic) NSMutableArray *mPhoneBook ;

+ (ContactsManager *)sharedInstance;
- (BOOL )initPhoneBook;
- (void) listPeopleInRecents:(ABAddressBookRef)addressBook;
- (NSArray *) lookup:(NSString *)searchString;
- (void) reloadPhoneBook ;
- (void) getAllContact ;
@end
