//
//  AnimatedViewController.m
//  Localize PS
//
//  Created by Luciano Moreira Turrini on 3/8/15.
//  Copyright (c) 2015 Liliane Bezerra Lima. All rights reserved.
//

#import "AnimatedViewController.h"
#import "ViewController.h"

@interface AnimatedViewController ()

@property (weak,nonatomic) NSTimer *timer;

@end

@implementation AnimatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imagemAnimada.transform = CGAffineTransformMakeTranslation(0, self.view.frame.origin.y-150);
    [self setNeedsStatusBarAppearanceUpdate];
     self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.3
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _imagemAnimada.transform = CGAffineTransformMakeTranslation(0, self.view.frame.origin.y+200);;
                     } completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              _imagemAnimada.transform = CGAffineTransformMakeTranslation(0, self.view.frame.origin.y+90);
                                          } completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.5
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   _imagemAnimada.transform = CGAffineTransformMakeTranslation(0, self.view.frame.origin.y+200);
                                                               }
                                                               completion:^(BOOL finished){
                                                                   _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(nextView) userInfo:nil repeats:NO];
                                                               }];
                                              
                                          }];
                     }];
    
    
}

- (void)nextView {
    [self performSegueWithIdentifier:@"showView" sender:self];
    [_timer invalidate];
    _timer = nil;
}


@end
