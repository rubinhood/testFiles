//
//  CalEventsCell.m
//  GiftInTime
//
//  Created by Telugu Desham  on 19/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "CalEventsCell.h"
#import "CalEventPicturesCell.h"
#import <EventKit/EventKit.h>
#import <Contacts/Contacts.h>

@implementation CalEventsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) initCell {
    
    
    [_mPicCollection registerNib:[UINib nibWithNibName:@"CalEventPicturesCell" bundle:nil] forCellWithReuseIdentifier:@"CalEventPicturesCell"];
    _mPicCollection.delegate = self;
    _mPicCollection.dataSource = self;
    
    [_mPicCollection reloadData];
    [_mPicCollection layoutIfNeeded];
}

- (void) setMPics:(NSArray *)mPics {
    _mPics = mPics;
    [self initCell];
}

- (CNContact *) getContactFromEvents:(NSString *) searchIdentifier {
    NSError* contactError;
    NSPredicate *predicate = [CNContact predicateForContactsWithIdentifiers:@[searchIdentifier]];
    CNContactStore* addressBook = [[CNContactStore alloc]init];
    NSArray *contactsz = [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[searchIdentifier]] error:&contactError];
    NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactImageDataKey, CNContactImageDataAvailableKey, CNContactIdentifierKey, CNContactThumbnailImageDataKey];
    
    NSArray *contacts = [addressBook unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:&contactError];
    
    if(contacts.count != 0) {
        
        return [contacts objectAtIndex:0];
    }
    
    
    return nil;
  
}



#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_mPics count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CalEventPicturesCell";
    CalEventPicturesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell layoutIfNeeded];
    
    EKEvent *event = [_mPics objectAtIndex:indexPath.row];
    cell.mEventPicView.image  = [UIImage imageNamed:@"event-color.png"];
    cell.mEventPicView.layer.cornerRadius = 0;
    cell.mEventPicView.layer.masksToBounds = YES;

    if(event.calendar.type == EKCalendarTypeBirthday) {
        NSLog(@"%@",event.title);
        NSString *search = event.birthdayContactIdentifier ;
        if(search != nil) {
            CNContact *contact = [self getContactFromEvents:search];
            
            if(contact != nil && contact.imageDataAvailable) {
                cell.contacts  = contact;
                cell.mEventPicView.image = [UIImage imageWithData:contact.thumbnailImageData];
                cell.mEventPicView.layer.cornerRadius = cell.mEventPicView.layer.frame.size.width/2;
                
                cell.mEventPicView.layer.masksToBounds = YES;
                
            }
        
        }
        
        
    }
    
    // return the cell
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake(32, 32);
    
    return size;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    CalEventPicturesCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    EKEvent  *event = [_mPics objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationEventPicsSelect object:event userInfo:nil];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
