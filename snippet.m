//
//  SetLiveViewController.m
//  Mogolive
//
//  Created by Mogolive LLC on 8/15/13.
//  Copyright (c) 2013 MacBook Pro. All rights reserved.
//

#import "SetLiveViewController.h"
#import "AFNetworking.h"

#import <FacebookSDK/FacebookSDK.h>

#import <FacebookSDK/FBRequest.h>

@interface SetLiveViewController ()
-(IBAction)closeModal:(id)sender;
-(IBAction)addPic:(id)sender;
-(IBAction)GoLive;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic, strong) IBOutlet UITextField *acttxt;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, strong) IBOutlet UIView *inView;
@property (nonatomic, strong) UIImage * image1;
@property (nonatomic, strong) NSMutableArray *_jsonResults;
@end

@implementation SetLiveViewController

@synthesize inView = _inView;
@synthesize image1;
@synthesize _jsonResults;

- (void)closeModal:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"anotherback.jpg"]];

    [[UIImagePickerController alloc] init];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.delegate = self;
    [_acttxt becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:1];
	// Do any additional setup after loading the view.

    [_acttxt becomeFirstResponder];
    NSLog(@"%@", _uname);
}

- (void)addPic:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    imagePickerController.cameraOverlayView = self.overlayView;
    
    self.imagePicker = imagePickerController;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)GoLive {
    
    NSString *liveString = _acttxt.text;
    
    NSString *key1 = liveString;
    NSString *key2 = _uname;
    
    NSURL *aurl = [[NSURL alloc] initWithString:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:aurl];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/random.php" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        CGImageRef cgref = [image1 CGImage];
        CIImage *cim = [image1 CIImage];
        
        if (cim == nil && cgref == NULL)
        {
            NSLog(@"no underlying data");
        }else
        {
        NSData *dataToUpload = UIImageJPEGRepresentation(image1, 0.5);
        [formData appendPartWithFileData:dataToUpload name:@"files" fileName:@"files.jpg" mimeType:@"image/jpeg"];
        }
        [formData appendPartWithFormData:[key1 dataUsingEncoding:NSUTF8StringEncoding] name:@"key1"];
        [formData appendPartWithFormData:[key2 dataUsingEncoding:NSUTF8StringEncoding] name:@"key2"];
        // etc.
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        [self dismissModalViewControllerAnimated:YES];
        [self postsocial];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    
}


-(void)postsocial
{
    NSString *pq = [NSString stringWithFormat:@"https://mogolive.com/getliveparams.php?q=%@", _uname];
    
    NSURL *url = [[NSURL alloc] initWithString:pq];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self._jsonResults = [JSON objectForKey:@"results"];
        NSDictionary *livedict = [_jsonResults objectAtIndex:0];
        
        NSString *liveurl = [livedict objectForKey:(@"socialu")];
        _liveurl = [livedict objectForKey:(@"url")];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    
    [operation start];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // You have the image. You can use this to present the image in the next view like you require in `#3`.
    UIImageView *myImageView = (UIImageView *)[_inView viewWithTag:500];
    myImageView.image = image1;
    NSLog(@"%@", image);
    NSLog(@"%@", image1);
    NSLog(@"%@",myImageView);
    
    [self dismissModalViewControllerAnimated:YES];
}

/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
*/
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
