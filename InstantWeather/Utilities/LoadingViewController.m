//
//  LoadingViewController.m
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/05/02.
//  Copyright © 2016 OpenCode. All rights reserved.
//

#import "LoadingViewController.h"

static LoadingViewController *__LoadingViewController;
@interface LoadingViewController ()
@end

@implementation LoadingViewController
{
    __weak IBOutlet UIActivityIndicatorView *_loadingIndicator;
    __weak IBOutlet UIView *_backgroundImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_loadingIndicator startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [_loadingIndicator stopAnimating];
}

- (void) setBackgroundImage:(NSString*)backgroundImage
    {
    [_backgroundImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImage]]];
    }

+ (void) displayLoadingView
{
    UIWindow* mainWindow;
    mainWindow = [UIApplication sharedApplication].delegate.window;
    __LoadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    [__LoadingViewController setBackgroundImage: @"backgroundImage"];
    __LoadingViewController.view.frame = mainWindow.bounds;
    [mainWindow addSubview:__LoadingViewController.view];
    __LoadingViewController.view.alpha = 0.5;
}

+ (void) removeLoadingView
{
    [UIView animateWithDuration:0.35 animations:^
        {
        __LoadingViewController.view.alpha = 0;
        }
    completion:^(BOOL finished)
        {
        if(finished)
            {
            [__LoadingViewController.view removeFromSuperview];
            }
        }];
}

@end
