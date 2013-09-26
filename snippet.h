//
//  SetLiveViewController.h
//  Mogolive
//
//  Created by Mogolive LLC on 8/15/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>

@interface SetLiveViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSString *username;
}

@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *liveurl;

@end
