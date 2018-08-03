//
//  CalendarVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 19/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "CalendarVC.h"
#import <EventKit/EventKit.h>
#import "UIColor+ColorHex.h"
#import "CalEventsCell.h"
#import <Contacts/Contacts.h>

@interface CalendarVC () <JTCalendarDelegate, UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@end

@implementation CalendarVC

{
    NSDate *mCurrentDate;
    NSDateFormatter *mDateFormatter;
    NSDateFormatter *mStringDateFormatter;
    EKEventStore* mEventStore;
    NSMutableArray *mEventList;
    NSMutableArray *mEventTableList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mDateFormatter = [[NSDateFormatter alloc] init];
    mStringDateFormatter = [[NSDateFormatter alloc] init];
    [mStringDateFormatter setDateFormat:@"dd MMM, yyyy"];

    
    mEventList = [[NSMutableArray alloc] init];
    mEventTableList = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    mCurrentDate = [NSDate date];
    if (!mEventStore) {
        mEventStore = [[EKEventStore alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCustomEventDetails:) name:kNotificationEventPicsSelect object:nil];
    
    
    NSArray* cals = [mEventStore calendarsForEntityType:EKEntityTypeEvent];
    NSLog(@"1st time calendars %@", cals);
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized:
        {
            NSLog(@"permission was already granted before");
            mEventStore = [[EKEventStore alloc] init];
            //NSArray* cals = [mEventStore calendarsForEntityType:EKEntityTypeEvent];
            [self initializeAttendanceCal];
            [self initializeEventTable];
            [self currentDisplayMonth_Date:mCurrentDate];
            
            break;
        }
        case EKAuthorizationStatusNotDetermined:
        {
            [mEventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
             {
                 if (granted)
                 {
                     NSLog(@"granted after user confirmation");
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         [mEventStore reset];
                         // refetch calendars
                         mEventStore = [[EKEventStore alloc] init];
                         NSArray* cals = [mEventStore calendarsForEntityType:EKEntityTypeEvent];
                         [self initializeAttendanceCal];
                        [self initializeEventTable];
                         [self showCalenderMonth:mCurrentDate];

                         NSLog(@"calendars %@", cals);
                     });
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }
             }];
        }
            break;
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
    
    
    
    
}



- (int)ifArrayContainesDate:(NSString *) date {
    for(int i=0; i < mEventTableList.count; i++) {
        NSDictionary *dic = [mEventTableList objectAtIndex:i];
        if([ date isEqualToString:   dic[@"date"]]) {
            return i;
        }
        
    }
    return -1;
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


- (void) convertToEventTableList {
    [mEventTableList removeAllObjects];
    for(int i=0; i < mEventList.count; i++){
        EKEvent *event = [mEventList objectAtIndex:i];
        NSComparisonResult res = [[event startDate] compare:[event endDate]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM YY"];
        
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        NSString *d1 = [formatter stringFromDate:[event startDate]];
        NSString *d2 = [formatter stringFromDate:[event endDate]];
        
        
        
        int index = [self ifArrayContainesDate:d1];
        if(index >= 0) {
            NSDictionary *dic = [mEventTableList objectAtIndex:index];
            
            NSMutableArray *array = dic[@"data"];
            [array addObject:event];
            
        }else {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:event];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:d1,@"date",array,@"data", nil];
            
            [mEventTableList addObject:dic];
            
            
        }
/*
        
        if([d1 isEqualToString:d2]) {
            
            
        }else {
           
            
            
        }
            
        
        */
        
    }
    
    
}

-(void) getAllEvents :(NSDate *) startDate {
    
    NSDate* endDate =  [self lastDayOfMonthForDate:startDate];
    
    NSArray *calendarArray  = [mEventStore calendarsForEntityType:EKEntityTypeEvent];
    
    NSPredicate *fetchCalendarEvents = [mEventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendarArray];
    [mEventList removeAllObjects];
    NSArray *eventList = [mEventStore eventsMatchingPredicate:fetchCalendarEvents];
    eventList = [eventList sortedArrayUsingComparator:^NSComparisonResult(EKEvent *event1, EKEvent *event2) {
        return [event1.startDate compare:event2.startDate];
    }];
    
    [mEventList addObjectsFromArray:eventList];
    for(int i=0; i < mEventList.count; i++){
        NSLog(@"Event Title:%@", [[mEventList objectAtIndex:i] title]);
        
    }
}



- (IBAction)backToPreviousVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) initializeEventTable {
    
    [self convertToEventTableList];
    _mEventTableVu.delegate = self;
    _mEventTableVu.dataSource = self;
    
    _mEventTableVu.estimatedRowHeight = 40;
    _mEventTableVu.rowHeight = UITableViewAutomaticDimension;
    
    
    
    _mEventTableVu.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_mEventTableVu reloadData];
    [_mEventTableVu layoutIfNeeded];
    
    //_mAddressRequestHeight.constant = _mAddressRequestTable.contentSize.height;
    
    
    
}

- (void) initializeAttendanceCal {
    mCurrentDate = [NSDate date];
    _mCalendarManager = [JTCalendarManager new];
    _mCalendarManager.delegate = self;
    
    [_mCalendarManager setContentView:_mMainCalendar];
    [_mCalendarManager setDate:mCurrentDate];
    
    _mMainCalendar.delegate = self;
    _mMainCalendar.bounces = NO;
    _mMainCalendar.scrollEnabled = NO;
    _mMainCalendar.pagingEnabled = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CalendarManagerDelegate
// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date {
    
   /* NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.month = -2;
    NSDate *currentDateMinus2Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:mCurrentDate options:0];
    
    return [_mCalendarManager.dateHelper date:date isEqualOrAfter:currentDateMinus2Month andEqualOrBefore:mCurrentDate];*/
    
    return YES;
    
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {
    // next month...
    [self currentDisplayMonth_Date:calendar.date];
    

}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {
    // previous month...
    [self currentDisplayMonth_Date:calendar.date];
}

- (void)currentDisplayMonth_Date:(NSDate *)currentDate {
    NSLog(@"Date:::: : %@", currentDate);
    [self showCalenderMonth:currentDate];
    [mEventTableList removeAllObjects];
    [mEventList removeAllObjects];
    NSDate *firstDay = [self firstDayOfMonthForDate:currentDate];
    //NSDate *lastDay = [self lastDayOfMonthForDate:currentDate];
    
    [self getAllEvents:firstDay];
    [self convertToEventTableList];
    [_mEventTableVu reloadData];
    //_mEventTableVu.contentOffset = CGPointMake(0, 0 - _mEventTableVu.contentInset.top);

    if(mEventTableList.count > 0) {
        NSIndexPath* top = [NSIndexPath indexPathForRow:0 inSection:0];
        [_mEventTableVu scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
}



-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == _mMainCalendar) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mCalendarManager reload];
        });
    }
    
    
}


- (NSDate *)firstDayOfMonthForDate:(NSDate *)date
{
    NSCalendar *cal         = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    comps.day               = 1;
    return [cal dateFromComponents:comps];
}

// Return the last day of the month for the month that 'date' falls in:
- (NSDate *)lastDayOfMonthForDate:(NSDate *)date
{
    NSCalendar *cal         = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    comps.month             += 1;
    comps.day               = 0;
    return [cal dateFromComponents:comps];
}


- (void)showCalenderMonth:(NSDate *) currentDate {
    
    [mDateFormatter setDateFormat:@"MMM  yyyy"];
    NSString *dateStr = [mDateFormatter stringFromDate:currentDate];
    NSLog(@"Months : %@", dateStr);
    _mCalanderMonthLabel.text = [NSString stringWithFormat:@"%@", dateStr];
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    

    if(nil == dayView)
        return;
    
    dayView.hidden = NO;
    dayView.circleView.hidden = NO;
    dayView.circleView.backgroundColor = [UIColor clearColor];
    dayView.dotView.backgroundColor = [UIColor clearColor];
    dayView.textLabel.textColor = [UIColor blackColor];
    
    
    // Test if the dayView is from another month than the page
    // Use only in month mode for indicate the day of the previous or next month
    
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
        
    } else if([_mCalendarManager.dateHelper date:mCurrentDate isTheSameDayThan:dayView.date]) {
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor orangeColor];
        dayView.dotView.backgroundColor = [UIColor blueColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        
    }else {
        
        //NSLog(@"Curren calender dateis %@", dayView.date);
        for(int i=0; i < mEventList.count; i++){
            
            //NSLog(@"Event Title:%@", [[mEventList objectAtIndex:i] title]);
            //NSLog(@"calender date day:%@", dayView.date);
            
            
            NSComparisonResult result = [dayView.date compare:[[mEventList objectAtIndex:i] startDate]]; // comparing two dates
            NSComparisonResult result2 = [dayView.date compare:[[mEventList objectAtIndex:i] endDate]]; // comparing two dates
            
            if(result!=NSOrderedAscending && result2!=NSOrderedDescending)
            {
                
                dayView.dotView.hidden = NO;
                dayView.circleView.hidden = YES;
                dayView.circleView.backgroundColor = [UIColor clearColor];
                dayView.dotView.backgroundColor = [UIColor HexColorWithAlpha:APP_GREEN_COLOR];
                dayView.textLabel.textColor = [UIColor HexColorWithAlpha:APP_GREEN_COLOR];

                
            }

            
        }
        
    }
    
}





- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
    
    NSString *dateStr = [mStringDateFormatter stringFromDate:dayView.date];
    NSLog(@"Months : %@", dateStr);
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numOfSections = 0;
    if ([mEventTableList count] > 0)
    {
        _mEventTableVu.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        _mEventTableVu.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mEventTableVu.bounds.size.width, _mEventTableVu.bounds.size.height)];
        noDataLabel.text             = @"No Event for this month ☹";
        noDataLabel.textColor        = [UIColor HexColorWithAlpha:APP_GREEN_COLOR];
        noDataLabel.font = [UIFont fontWithName:@"SF-UI-Display-Bold.otf" size:20.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        _mEventTableVu.backgroundView = noDataLabel;
        _mEventTableVu.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mEventTableList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell creation...
    CalEventsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalEventsCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CalEventsCell" bundle:nil] forCellReuseIdentifier:@"CalEventsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"CalEventsCell"];
    }
    
    if(indexPath.row == 0) {
        cell.mTopLine.alpha = 0;
    }else {
        cell.mTopLine.alpha = 1;
    }
    
    
    if(indexPath.row == mEventTableList.count-1) {
        cell.mBottomLine.alpha = 0;
    }else {
        cell.mBottomLine.alpha = 1;
    }

    NSDictionary *dic = [mEventTableList objectAtIndex:indexPath.row];
    cell.mDateString.text = dic[@"date"];
    
    NSArray *data = dic[@"data"];
    cell.mPics = data;
    
    // display names based on section....
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


#pragma mark - Gift popup helpers


- (IBAction)giftNowToContacts:(id)sender {
}


- (IBAction)closePopupView:(id)sender {
    [self.view sendSubviewToBack:_mGiftPopupVu];
}



- (void) showCustomEventDetails:(NSNotification *) not {
    
    EKEvent *event = [not object];
    
    _mGiftPopupVuImage.image = [UIImage imageNamed:@"event-color.png"];
    _mGiftPopupVuImage.layer.cornerRadius = _mGiftPopupVuImage.layer.frame.size.width/2;
    _mGiftPopupVuImage.layer.cornerRadius = 0;
    _mGiftPopupVuImage.layer.masksToBounds = YES;

    _mGiftPopLabelName.text = event.title;
    _mGiftPopupPhoneNumber.text = @"";
    
    if(event.calendar.type == EKCalendarTypeBirthday) {
        NSLog(@"%@",event.title);
        NSString *search = event.birthdayContactIdentifier ;
        if(search != nil) {
            CNContact *contact = [self getContactFromEvents:search];
            
            if(contact != nil && contact.imageDataAvailable) {
                _mGiftPopupVuImage.image = [UIImage imageWithData:contact.thumbnailImageData];
                _mGiftPopupVuImage.layer.cornerRadius = _mGiftPopupVuImage.layer.frame.size.width/2;
                
                _mGiftPopupVuImage.layer.masksToBounds = YES;
                _mGiftPopLabelName.text = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
                
                NSArray *phoneArray  = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
                if(phoneArray.count > 0) {
                    _mGiftPopupPhoneNumber.text  = [phoneArray objectAtIndex:0];
                }else {
                    _mGiftPopupPhoneNumber.text = @"Phone Number not stored";
                }
            }
            
        }
        
        
    }
    
    [self.view bringSubviewToFront:_mGiftPopupVu];
    _mGiftPopupDialogueVu.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            _mGiftPopupDialogueVu.transform = CGAffineTransformIdentity;
                            
                        } completion:^(BOOL finished) {
                            // cool code here
                            
                        }];
    
}



#pragma mark - Synchronise Events Helpers

- (IBAction)showSyncEventsHelper:(id)sender {
    
    [self.view bringSubviewToFront:_mSyncMainVu];
    _mSyncDialogueVu.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            
                            _mSyncDialogueVu.transform = CGAffineTransformIdentity;
                            
                        } completion:^(BOOL finished) {
                            // cool code here
                            
                        }];

    
    
}

-(void) showSyncView {
    
    
    
    
}



- (IBAction)hideSyncView:(id)sender {
     [self.view sendSubviewToBack:_mSyncMainVu];
}


- (IBAction)showPreviousMonthEvents:(UIButton *)sender {
     [_mMainCalendar loadPreviousPageWithAnimation];
    NSDate *scrollingMonthDate = _mMainCalendar.date ;
    NSLog(@"-------------------------%@",scrollingMonthDate);
    
}


- (IBAction)showNextMonthEvents:(UIButton *)sender {
    [_mMainCalendar loadNextPageWithAnimation];
    NSDate *scrollingMonthDate = _mMainCalendar.date ;
    NSLog(@"-------------------------%@",scrollingMonthDate);
    
}


@end
