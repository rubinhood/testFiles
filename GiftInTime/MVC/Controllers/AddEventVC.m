//
//  AddEventVC.m
//  GiftInTime
//
//  Created by Telugu Desham  on 22/01/18.
//  Copyright © 2018 QuickTechnosoft. All rights reserved.
//

#import "AddEventVC.h"
#import "PECropViewController.h"



@interface AddEventVC () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, PECropViewControllerDelegate>

@end

@implementation AddEventVC

{
    UIImagePickerController *mImagePicker;
    UIPopoverController *mPopover;
    UIImage *mImageProfile;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [_mContactProfile layoutIfNeeded];
    _mContactProfile.layer.cornerRadius = _mContactProfile.layer.frame.size.width/2;
    _mContactProfile.layer.masksToBounds = YES;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToPreviousController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // keyboard notifications ...
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    [super viewWillDisappear:animated];
}


#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)note {
    
    NSDictionary* info = [note userInfo];
    CGRect keyboardInfoFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get the height of the keyboard by taking into account the orientation of the device too
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    // add the keyboard height to the content insets so that the scrollview can be scrolled
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    _mProfileScrollVu.contentInset = contentInsets;
    _mProfileScrollVu.scrollIndicatorInsets = contentInsets;
    
    // make sure the scrollview content size width and height are greater than 0
    [_mProfileScrollVu setContentSize:CGSizeMake (_mProfileScrollVu.contentSize.width, _mProfileScrollVu.contentSize.height)];
    
    
}

- (void)keyboardWillHide:(NSNotification *)note {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _mProfileScrollVu.contentInset = contentInsets;
    _mProfileScrollVu.scrollIndicatorInsets = contentInsets;
    
}

- (IBAction)getUserProfileImage:(UIButton*)sender {
    
    
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Photo Slection" message:@"Please select image of your documents" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cameraSelected:nil];
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self photoGallerySelected:nil];
        
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
    actionSheet.popoverPresentationController.sourceView = self.view;
    actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
    [self presentViewController:actionSheet animated:YES
                     completion:nil];
    
    
    
}

- (void)photoGallerySelected:(id)sender {
    
    
    mImagePicker = [[UIImagePickerController alloc]init];
    mImagePicker.delegate = self;
    mImagePicker.allowsEditing = NO;
    mImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:mImagePicker animated:YES completion:NULL];
    
}

- (void)cameraSelected:(id)sender {
    mImagePicker = [[UIImagePickerController alloc] init];
    mImagePicker.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        mImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:mImagePicker animated:YES completion:NULL];
    } else {
        [KSToastView ks_showToast:@"Camera is not available"];
    }
}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 1;
    controller.rotationEnabled = YES;
    //controller.imageCropRect = CGRectMake((image.size.width  - 200) / 2 ,(image.size.height - 200) / 2,200,200);
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    mImageProfile = [self imageWithImage:croppedImage scaledToSize:CGSizeMake(300, 300)];
    
    [_mContactProfile setImage:mImageProfile forState:UIControlStateNormal];
    _mContactProfile.layer.cornerRadius = _mContactProfile.layer.frame.size.width/2;
    _mContactProfile.layer.masksToBounds = YES;
    
    
}

- (void) cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize; {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}




@end
