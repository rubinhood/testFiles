//
//  HomeVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 08/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "HomeVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DataStoreClass.h"

@interface HomeVC () <UIScrollViewDelegate, UIWebViewDelegate, ApiServiceDelegate>

@end

@implementation HomeVC

{
    NSMutableArray *mImageData ;
    AVPlayer *mPlayer;
    NSInteger mTotalPicture;
    NSTimer *mTimer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSBundle *bundle = [NSBundle mainBundle];
    //NSString *moviePath = [bundle pathForResource:@"movie" ofType:@"mp4"];
    
    NSString *ytLink = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE][@"git_youtube_url"];
    [_mPlayerVu layoutIfNeeded];
    [MBProgressHUD showHUDAddedTo:_mPlayerVu animated:YES];
    _mYTPlayer.delegate = self;
    [self initYoutubeWithURL:ytLink];
    [self displayUserData];
    [self getUserGiftPoints];
    /*
    
    mPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
    
    [_mPlayerVu layoutIfNeeded];
    AVPlayerLayer *playerLayer = [AVPlayerLayer layer];
    
    playerLayer.player = mPlayer;
    
    playerLayer.frame = _mPlayerVu.bounds;
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_mPlayerVu.layer addSublayer:playerLayer];
    _mPlayerControlBtn.selected = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resertPlayerControl:) name:AVPlayerItemDidPlayToEndTimeNotification object:mPlayer.currentItem];
    
    */
    
    
    mImageData = [[NSMutableArray alloc] init];
    mTotalPicture = 3;
    _mPictureScroller.delegate  = self;
    [_mPictureScroller.superview.superview layoutIfNeeded];
    
    [_mPictureScroller layoutIfNeeded];
    
    [self getDummyData];
    _mPageController.numberOfPages = mTotalPicture;
    _mPageController.currentPage = 0;
    [self setupScroller];
    
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(slideToNextPage) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated) name:kNotificationProfileUpdated object:nil];


}


- (void) profileUpdated {
    [self displayUserData];
}
- (void) displayUserData {
    NSDictionary *userProfile = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PROFILE];
    _mWelcomeMsg.text = [NSString stringWithFormat:@"Hi %@! ",userProfile[@"firstname"]];
    _mUserPoints.text = [NSString stringWithFormat:@"Pts %d", DataInstance.mGiftPoints];
    [_mProfileBtn layoutIfNeeded];
   [_mProfileBtn sd_setImageWithURL:[NSURL URLWithString:userProfile[@"profile_picture"]] forState:UIControlStateNormal];
    
    _mProfileBtn.layer.cornerRadius = _mProfileBtn.layer.frame.size.height/2;
    [_mProfileBtn setClipsToBounds:YES];
    _mProfileBtn.layer.masksToBounds  = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"done youtube laoding");
    [MBProgressHUD hideAllHUDsForView:_mPlayerVu animated:YES];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:_mPlayerVu animated:YES];

    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:_mPlayerVu animated:YES];

}


- (void) setupScroller {
    [_mPictureScroller layoutIfNeeded];
    
    for(int i=0; i< mTotalPicture; i++) {
        UIImageView *ivu = [[UIImageView alloc] initWithFrame:CGRectMake(_mPictureScroller.frame.size.width *i, 0, _mPictureScroller.frame.size.width, _mPictureScroller.frame.size.height)];
        ivu.image = [mImageData objectAtIndex:i];
        [_mPictureScroller addSubview:ivu];
        
    }
    _mPictureScroller.contentSize = CGSizeMake(_mPictureScroller.frame.size.width * mTotalPicture , _mPictureScroller.frame.size.height);
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    _mPageController.currentPage = (int)currentPage;
    
}


- (void) slideToNextPage {
    CGFloat offset = _mPictureScroller.contentOffset.x;
    CGFloat NextPagePosition = offset + _mPictureScroller.frame.size
    .width ;
    
    if(NextPagePosition >= (_mPictureScroller.frame.size
                            .width *(mTotalPicture)) ) {
        NextPagePosition = 0;
    }
    [_mPictureScroller scrollRectToVisible:CGRectMake(NextPagePosition, 0, _mPictureScroller.frame.size.width, _mPictureScroller.frame.size.height) animated:YES];
}


- (void) getDummyData {
    for(int i=0; i< mTotalPicture; i++) {
        UIImage *image;
        if(i%2==0)
            image = [UIImage imageNamed:@"bg3.png"];
        else
            image = [UIImage imageNamed:@"banner_shop.jpg"];
        
        [mImageData addObject:image];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playerControlls:(UIButton *)sender {
    
    if(sender.selected) {
        [mPlayer pause];
    }else {
        [mPlayer play];

    }
    sender.selected = !sender.selected;
    
}




- (void) resertPlayerControl:(NSNotification *) notification{
    
    _mPlayerControlBtn.selected = NO;
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero]; // Play it again when video ends
    [mPlayer pause];
    
    
}

- (void)initYoutubeWithURL:(NSString *)urlString  {
    NSString *videoID = [self extractYoutubeVideoID:urlString];
    
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\" align=\"middle\" >\
    <embed id=\"yt\" src=\"http://www.youtube.com/v/%@?playsinline=1\" frameborder=\"0\" type=\"application/x-shockwave-flash\" \
    width=\"%f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, videoID, _mYTPlayer.frame.size.width, _mYTPlayer.frame.size.height];
    
    
    
    /*
    
    NSString* embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <body style='margin:0px;padding:0px;'>\
                           <script type='text/javascript' src='http://www.youtube.com/iframe_api'></script>\
                           <script type='text/javascript'>\
                           function onYouTubeIframeAPIReady()\
                           {\
                           ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})\
                           }\
                           function onPlayerReady(a)\
                           { \
                           a.target.playVideo(); \
                           }\
                           </script>\
                           <iframe id='playerId' type='text/html' width='%f' height='%f' src='http://www.youtube.com/embed/%@?enablejsapi=1&rel=0&fs=0&playsinline=1&allowfullscreen=0&autoplay=1' frameborder='0'>\
                           </body>\
                           </html>", _mYTPlayer.frame.size.width, _mYTPlayer.frame.size.height, videoID];
    
    */
    
    [_mYTPlayer loadHTMLString:html baseURL:nil];

}



/**
 @see https://devforums.apple.com/message/705665#705665
 extractYoutubeVideoID: works for the following URL formats:
 
 www.youtube.com/v/VIDEOID
 www.youtube.com?v=VIDEOID
 www.youtube.com/watch?v=WHsHKzYOV2E&feature=youtu.be
 www.youtube.com/watch?v=WHsHKzYOV2E
 youtu.be/KFPtWedl7wg_U923
 www.youtube.com/watch?feature=player_detailpage&v=WHsHKzYOV2E#t=31s
 youtube.googleapis.com/v/WHsHKzYOV2E
 */

- (NSString *)extractYoutubeVideoID:(NSString *)urlYoutube {
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:urlYoutube options:0 range:NSMakeRange(0, [urlYoutube length])];
    
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        NSString *substringForFirstMatch = [urlYoutube substringWithRange:rangeOfFirstMatch];
        
        return substringForFirstMatch;
    }
    
    return nil;
}
- (void)getUserGiftPoints {
   
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_KEY];
    NSString *url = [NSString stringWithFormat:@"%@%@",FILE_GET_GIFTPOINTS,token];
    
    [[HTTPConnection sharedInstance] apiGetCall_HTTPConnection:nil withFile:url withHUD:self.view withServiceDelegate:self withServiceCall:SERVICE_GET_GIFTPOINTS];
    
    
}

- (void) onSuccessApiCall:(NSDictionary *)responseDict withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_GET_GIFTPOINTS) {
        _mUserPoints.text = [NSString stringWithFormat:@"Pts %@", responseDict[@"points"] ];
    }
}

- (void) onFailureApiCall:(NSDictionary *)data withServiceCall:(int)serviceNumber {
    if(serviceNumber == SERVICE_LOGIN) {
        [KSToastView ks_showToast:@"Login Failure"];
        
    }
    
}
@end
