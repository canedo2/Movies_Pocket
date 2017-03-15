//
//  AboutViewController.m
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 14/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
    @property (weak, nonatomic) IBOutlet UIView *backgroundView;
    @property CAGradientLayer* gradient;
@end

@implementation AboutViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _gradient = [CAGradientLayer layer];
    _gradient.frame = self.view.bounds;
    
    UIColor* color1 = [UIColor colorWithRed:0.5
                                      green:0
                                       blue:0.1
                                      alpha:0.2];
    
    UIColor* color2 = [UIColor colorWithRed:0.53
                                      green:0.06
                                       blue:0.27
                                      alpha:1.0];
    
    NSArray* gradientColors = @[(id)color1.CGColor,(id)color2.CGColor];
    
    _gradient.colors = gradientColors;
    
    [_backgroundView.layer insertSublayer:_gradient atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _gradient.frame = self.view.bounds;
}
    
- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)MIMOTapAction:(id)sender {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.web.upsa.es/mimo/" ];
    [[UIApplication sharedApplication] openURL:url options: [[NSDictionary alloc]init] completionHandler:nil];
}
- (IBAction)tbdbTapAction:(id)sender {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"https://www.themoviedb.org/" ];
    [[UIApplication sharedApplication] openURL:url options: [[NSDictionary alloc]init] completionHandler:nil];
}
- (IBAction)icons8TapAction:(id)sender {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"https://icons8.com/" ];
    [[UIApplication sharedApplication] openURL:url options: [[NSDictionary alloc]init] completionHandler:nil];
}


@end
