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


@interface WelcomeViewController () <AuthenticationDelegate, UIScrollViewDelegate>

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
    NSLog(@"CONTENT OFFSET X =  %f", scrollView.contentOffset.x);
}

#pragma mark - Configure

- (void)configureFeatures {
    Feature *feature1 = [Feature featureWithName:@"Cards." detailDescription:@"Create your own cards with any information and learn it!" imageName:@"cards_feature"];
    Feature *feature2 = [Feature featureWithName:@"Learn mode." detailDescription:@"Try our learn mode with special methodic - it is absolutely amazing!" imageName:@"learnmode_feature"];
    Feature *feature3 = [Feature featureWithName:@"Match mode." detailDescription:@"Lets into match mode. You should find pairs of terms and definitions!" imageName:@"matchmode_feature"];
    
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
        CGFloat xPos = width * index;
        NSLog(@"POSITION = %f", xPos);
        CGFloat yPos = featureView.frame.origin.y;
        CGRect featureFrame = CGRectMake(xPos, yPos, width, height);
        
        featureView.frame = featureFrame;
    }
}
@end
