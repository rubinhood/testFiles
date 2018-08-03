//
//  ContactsManager.m
//  GiftInTime
//
//  Created on 17/01/18.
//
//

#import "ContactsManager.h"
#import "ContactsData.h"





@implementation PhoneBookEntry



@end



@implementation ContactsManager



+ (ContactsManager *)sharedInstance {
    
    static ContactsManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.mPhoneBook =[[NSMutableArray alloc] init];
        
    });
    
    return _sharedInstance;
}



- (BOOL )initPhoneBook {
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        
        // permission issue
        return NO;
    
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        // init phone book
        [self fillandSortPhonebook:addressBook];


    } else{
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    // cant add in phonebook
                    return;
                }
                [self fillandSortPhonebook:addressBook];
            });
        });
    }
    
    return YES;

}
- (void)checkPermissionForCNContacts
{
    switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts])
    {
        case CNAuthorizationStatusNotDetermined:
        {
            [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted == YES)
                    [self getAllContact];
            }];
        }
            break;
        case CNAuthorizationStatusRestricted:
        case CNAuthorizationStatusDenied:
            // Show custom alert
            break;
        case CNAuthorizationStatusAuthorized:
            [self getAllContact];
            break;
    }
}

- (void) contactScan
{
    if ([CNContactStore class]) {
        //ios9 or later
        CNEntityType entityType = CNEntityTypeContacts;
        if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined)
        {
            CNContactStore * contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if(granted){
                    [self getAllContact];
                }
            }];
        }
        else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized)
        {
            [self getAllContact];
        }
    }
}

-(void)getAllContact
{
    if([CNContactStore class])
    {
        [_mPhoneBook removeAllObjects];
        NSError* contactError;
        CNContactStore* addressBook = [[CNContactStore alloc]init];
        [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
        NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPostalAddressesKey, CNContactImageDataKey, CNContactImageDataAvailableKey, CNContactIdentifierKey, CNContactThumbnailImageDataKey];
        CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        [request setSortOrder:CNContactSortOrderGivenName];
        BOOL success = [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
            [self parseContactWithContact:contact];
        }];
    }
}

- (void)parseContactWithContact :(CNContact* )contact
{
    ContactsData *person = [[ContactsData alloc] init];
    
    person.mFirstname =  contact.givenName;
    person.mLastname =  contact.familyName;
    NSArray *phoneArray  = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    if(phoneArray.count > 0) {
        person.mPhone = [phoneArray objectAtIndex:0];
    }else {
        person.mPhone = @"Phone Number not stored";
    }
    
    NSArray *emailArray  = [contact.emailAddresses valueForKey:@"value"] ;
    if(emailArray.count > 0) {
        person.mEmail = [emailArray objectAtIndex:0];
    }else {
        person.mEmail = @"Email not found in Address book";
    }

    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if(addresses.count > 0) {
        CNPostalAddress* labeledValue = [addresses objectAtIndex:0];
        NSLog(@"%@",labeledValue.street);
        NSLog(@"%@",labeledValue.state);
        NSLog(@"%@",labeledValue.postalCode);
        NSLog(@"%@",labeledValue.ISOCountryCode);
    }
    if (contact.imageDataAvailable) {
        person.mImage = contact.thumbnailImageData;
    
    }
    
    if(contact.identifier != nil) {
        person.mID = contact.identifier;
    }
    
    if([person.mFirstname isEqualToString:@"" ]) {
        return;
    }
    
    
    NSString *firstChar = (NSString *)[[person.mFirstname uppercaseString] substringToIndex:1];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"title contains[c] %@ ",firstChar];
    NSArray *filteredContacts = [_mPhoneBook filteredArrayUsingPredicate:filter];
    if(filteredContacts.count > 0) {
        NSDictionary *dic = [filteredContacts objectAtIndex:0];
        NSMutableArray *contacts = dic [@"contact"];
        [contacts addObject:person];
        
    }else {
        
        NSMutableArray *contacts = [[NSMutableArray alloc] init];
        [contacts addObject:person];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:firstChar,@"title",contacts, @"contact" ,nil];
        [_mPhoneBook addObject:dic];
        
    }

    
    
}

- (NSMutableArray *)parseAddressWithContac: (CNContact *)contact
{
    NSMutableArray * addrArr = [[NSMutableArray alloc]init];
    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if (addresses.count > 0) {
        for (CNPostalAddress* address in addresses) {
            [addrArr addObject:[formatter stringFromPostalAddress:address]];
        }
    }
    return addrArr;
}


- (void) reloadPhoneBook {
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    [self fillandSortPhonebook:addressBook];
    
}

- (void) fillandSortPhonebook :(ABAddressBookRef ) addressBook{
    
    
    [_mPhoneBook removeAllObjects];
    //ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    //NSArray *allContacts  = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeopleInSource(addressBook, source));
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, nil, kABPersonSortByFirstName);
    //CFIndex numberOfPeople = CFArrayGetCount(allPeople);
    
    
    
    for (int i = 0; i < CFArrayGetCount(allPeople); i++) {
        
        ContactsData *person = [[ContactsData alloc] init];
        
        ABRecordRef contactPerson = CFArrayGetValueAtIndex(allPeople, i);;
        
        person.mFirstname = (NSString*)(__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
        person.mLastname = (NSString*)(__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
        person.mEmail = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(ABRecordCopyValue(contactPerson, kABPersonEmailProperty) , 0));
        person.mAddress1 = (NSString*)(__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonAddressProperty);
        person.mPhone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(ABRecordCopyValue(contactPerson, kABPersonPhoneProperty), 0));
        
        NSCharacterSet *charactersToRemove = [NSCharacterSet  characterSetWithCharactersInString:@"-()[]" ];
        
        //NSString *phone = [NSString stringWithFormat:@"%@",person.mPhone ];
        //NSArray *temp = [((NSString *)phone) componentsSeparatedByCharactersInSet:charactersToRemove];
        

        NSString *stringTemp =  [[person.mPhone componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
        person.mStrippedPhone = [stringTemp stringByReplacingOccurrencesOfString:@" " withString:@""];

        
        
        person.mBirthday = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonBirthdayProperty);

        ABMultiValueRef addresses = ABRecordCopyValue(contactPerson, kABPersonAddressProperty);
        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addresses, 0);
        
        if(dict != nil) {
        //CFStringRef typeTmp = ABMultiValueCopyLabelAtIndex(addresses, 0);
        //CFStringRef labeltype = ABAddressBookCopyLocalizedLabel(typeTmp);
        person.mAddress1 = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey) ;
        person.mCity = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey);
        person.mProvince = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey) ;
        person.mPostalcode = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey) ;
        person.mCountry = (NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey) ;
        }

        
        //person.mID = ABRecordGetRecordID(contactPerson);
        
        if (ABPersonHasImageData(contactPerson)) {
            person.mHasImage = 1;
            //put this in a dispatch queue
            person.mImage = (__bridge NSData*) ABPersonCopyImageData(contactPerson);
        }

        NSString *firstChar = (NSString *)[[person.mFirstname uppercaseString] substringToIndex:1];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"title contains[c] %@ ",firstChar];
        NSArray *filteredContacts = [_mPhoneBook filteredArrayUsingPredicate:filter];
        if(filteredContacts.count > 0) {
            NSDictionary *dic = [filteredContacts objectAtIndex:0];
            NSMutableArray *contacts = dic [@"contact"];
            [contacts addObject:person];

        }else {
            
            NSMutableArray *contacts = [[NSMutableArray alloc] init];
            [contacts addObject:person];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:firstChar,@"title",contacts, @"contact" ,nil];
            [_mPhoneBook addObject:dic];
            
        }
        
        
    }
    
    
}

@end
