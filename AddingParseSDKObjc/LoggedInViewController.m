//
//  LoggedInViewController.m
//  AddingParseSDKObjc
//
//  Created by Joren Winge on 4/12/18.
//  Copyright © 2018 Back4App. All rights reserved.
//

#import "LoggedInViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface LoggedInViewController (){
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation LoggedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    activityIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:activityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate registerForRemoteNotifications];
}

- (IBAction)sendPushToYourself:(id)sender {
    [activityIndicatorView startAnimating];
    [PFCloud callFunctionInBackground:@"sendPushToYourself"
                       withParameters:@{}
                                block:^(id object, NSError *error) {
                                    [self->activityIndicatorView stopAnimating];
                                    if (!error) {
                                        NSLog(@"PUSH SENT");
                                    }else{
                                        [self displayMessageToUser:error.debugDescription];
                                    }
                                }];
}

- (IBAction)sendPushToGroup:(id)sender {
    [activityIndicatorView startAnimating];
    [PFCloud callFunctionInBackground:@"sendPushToAllUsers"
                       withParameters:@{}
                                block:^(id object, NSError *error) {
                                    [self->activityIndicatorView stopAnimating];
                                    if (!error) {
                                        NSLog(@"PUSH SENT");
                                    }else{
                                        [self displayMessageToUser:error.debugDescription];
                                    }
                                }];
}

- (IBAction)logout:(id)sender {
    [activityIndicatorView startAnimating];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [self->activityIndicatorView stopAnimating];
        if(error == nil){
            [self goToStartPage];
        }else{
            [self displayMessageToUser:error.debugDescription];
        }
    }];
}

- (void)displayMessageToUser:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = self.view;
    UIAlertAction *Okbutton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    }];
    [alert addAction:Okbutton];
    popPresenter.sourceRect = self.view.frame;
    alert.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)goToStartPage {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    ViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
