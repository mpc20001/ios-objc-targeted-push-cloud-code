//
//  ViewController.m
//  AddingParseSDKObjc
//
//  Created by Joren Winge on 12/28/17.
//  Copyright © 2017 Back4App. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "LoggedInViewController.h"

@interface ViewController (){
    IBOutlet UITextField * signInUserNameTextField;
    IBOutlet UITextField * signInPasswordTextField;
    IBOutlet UITextField * signUpUserNameTextField;
    IBOutlet UITextField * signUpPasswordTextField;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation ViewController

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

- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = signUpUserNameTextField.text;
    user.password = signUpPasswordTextField.text;
    [activityIndicatorView startAnimating];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self->activityIndicatorView stopAnimating];
        if (!error) {
            [self goToMainPage];
        } else {
            [self displayMessageToUser:error.localizedDescription];
        }
    }];
}

- (IBAction)signIn:(id)sender {
    [activityIndicatorView startAnimating];
    [PFUser logInWithUsernameInBackground:signInUserNameTextField.text password:signInPasswordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        [self->activityIndicatorView stopAnimating];
                                        if (user) {
                                            [self goToMainPage];
                                        } else {
                                            [self displayMessageToUser:error.localizedDescription];
                                        }
                                    }];
}

- (void)goToMainPage {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    LoggedInViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LoggedInViewController"];
    [self presentViewController:vc animated:YES completion:nil];
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

@end
