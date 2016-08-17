//
//  ViewController.m
//  DropBoxAPI
//
//  Created by Thabresh on 8/16/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"

@interface ViewController ()<DBRestClientDelegate>
@property (nonatomic, strong) DBRestClient *restClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    [_btnFolderfile setHidden:YES];
    [_btnLogin setTag:0];
    if ([[DBSession sharedSession] isLinked]) {
        [_btnFolderfile setHidden:NO];
        [_btnLogin setTitle:@"Logout to DropBox" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view, typically from a nib.
}
- (void) receiveTestNotification:(NSNotification *) notification
{
    [_btnFolderfile setHidden:NO];
    [_btnLogin setTitle:@"Logout to DropBox" forState:UIControlStateNormal];
}
- (IBAction)ClickOnDropBoxLogin:(id)sender {
     UIButton *button = (UIButton*)sender;
    if ([button.titleLabel.text isEqualToString:@"Logout to DropBox"]) {
         [_btnFolderfile setHidden:YES];
        [[DBSession sharedSession]unlinkAll];
        [_btnLogin setTitle:@"Login to DropBox" forState:UIControlStateNormal];
    }else{
        [[DBSession sharedSession] linkFromController:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
