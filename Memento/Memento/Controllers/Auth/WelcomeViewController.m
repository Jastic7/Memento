//
//  WelcomeViewController.m
//  Memento
//
//  Created by Andrey Morozov on 31.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignUpTableViewController.h"
#import "LogInTableViewController.h"
#import "AuthenticationDelegate.h"
#import "FeatureView.h"
#import "Feature.h"

static NSString * const kShowSignUpSegue = @"showSignUpSegue";
static NSString * const kShowLogInSegue = @"showLogInSegue";


@interface WelcomeViewController () <AuthenticationDelegate, UIScrollViewDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet UIPageControl *featurePageControl;
@property (nonatomic, weak) IBOutlet UIScrollView *featureScrollView;
@property (nonatomic, strong) NSArray <Feature *> *features;

@end


@implementation WelcomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureFeatures];
    [self configureScrollView];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    UINavigationController *navController = segue.destinationViewController;
    
    if ([identifier isEqualToString:kShowSignUpSegue]) {
        SignUpTableViewController *dvc = (SignUpTableViewController *)navController.topViewController;
        
        dvc.delegate = self;
    } else if ([identifier isEqualToString:kShowLogInSegue]) {
        LogInTableViewController *dvc = (LogInTableViewController *)navController.topViewController;
        
        dvc.delegate = self;
    }
}


#pragma mark - AuthenticationDelegate Implemenation

- (void)authenticationDidCancelled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)authenticationDidComplete {
    [self dismissViewControllerAnimated:YES completion:^{
        self.authenticationCompletion();
    }];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.featurePageControl.currentPage = page;
}


#pragma mark - Configure

- (void)configureFeatures {
    Feature *feature1 = [Feature featureWithName:@"Cards." detailDescription:@"Create your own cards with information and learn it!" imageName:@"cards_feature"];
    Feature *feature2 = [Feature featureWithName:@"Learn mode." detailDescription:@"Learn set with special methodic - it is  amazing!" imageName:@"learnmode_feature"];
    Feature *feature3 = [Feature featureWithName:@"Match mode." detailDescription:@"Find pairs of terms and their definitions!" imageName:@"matchmode_feature"];
    
    self.features = [NSArray arrayWithObjects:feature1, feature2, feature3, nil];
}

- (void)configureScrollView {
    CGFloat x = 0;
    CGFloat y = self.featurePageControl.frame.origin.y - 8;
    CGFloat height = 100;
    CGFloat width = self.view.bounds.size.width;
    CGRect scrollRect = CGRectMake(x, y, width, height);
    
    self.featureScrollView.frame = scrollRect;
    
    [self.featureScrollView setPagingEnabled:YES];
    CGFloat widthOfFeature = self.view.bounds.size.width;
    self.featureScrollView.contentSize = CGSizeMake(widthOfFeature * self.features.count, self.featureScrollView.frame.size.height);
    self.featureScrollView.showsHorizontalScrollIndicator = NO;
    self.featureScrollView.delegate = self;
    
    [self loadFeatures];
}


#pragma mark - Private

- (void)loadFeatures {
    for (NSUInteger index = 0; index < self.features.count; index++) {
        Feature *feature = self.features[index];
        FeatureView *featureView = [[NSBundle mainBundle] loadNibNamed:@"FeatureView" owner:self options:nil].firstObject;
        [featureView configureWithTitle:feature.name detailDescription:feature.detailDescription imageName:feature.imageName];
        
        [self.featureScrollView addSubview:featureView];
        
        CGFloat width = self.featureScrollView.bounds.size.width;
        CGFloat height = self.featureScrollView.bounds.size.height;
        CGFloat x = width * index;
        CGFloat y = featureView.frame.origin.y;
        CGRect featureFrame = CGRectMake(x, y, width, height);
        
        featureView.frame = featureFrame;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end
