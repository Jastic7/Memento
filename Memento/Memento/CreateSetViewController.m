//
//  CreateSetViewController.m
//  Memento
//
//  Created by Andrey Morozov on 04.05.17.
//  Copyright © 2017 Andrey Morozov. All rights reserved.
//

#import "CreateSetViewController.h"
#import "CreationalNewSetDelegate.h"
#import "Set.h"
@interface CreateSetViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *setTitleTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<UITextField *> *termTextFields;
@property (nonatomic, strong) NSMutableArray<UITextField *> *definitionTextFields;

@property (nonatomic, assign) NSUInteger countOfTerms;

@end

@implementation CreateSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    
    self.countOfTerms = 0;
}

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    [self.delegate cancelCreationalNewSet];
    self.delegate = nil;
}

- (IBAction)doneBarButtonTapped:(UIBarButtonItem *)sender {
    NSMutableArray<ItemOfSet *> *items = [NSMutableArray new];
    Set *set = [Set setWithTitle:@"Unit 8. Prepositions without translate translate translate translate translate translate translate" author:@"Jastioc7" items:items];
    
    [self.delegate saveNewSet:set];
    self.delegate = nil;
}

- (IBAction)addNewTermTouchUpInside:(UIButton *)sender {
    CGFloat width = 150;
    CGFloat height = 30;
    CGFloat horizontalOffset = 16;
    CGFloat verticalOffset = 16;
    
    CGRect termRect = CGRectMake(horizontalOffset, (height + verticalOffset) * self.countOfTerms, width, height);
    UITextField *term = [[UITextField alloc] initWithFrame:termRect];
    term.placeholder = @"Some text";
    
    CGRect definitionRect = CGRectMake(horizontalOffset * 2 + width, termRect.origin.y, width, height);
    UITextField *definition = [[UITextField alloc] initWithFrame:definitionRect];
    definition.placeholder = @"Definition";
    
    CGFloat widthScreen = self.view.frame.size.width;
    self.scrollView.contentSize = CGSizeMake(widthScreen, (height + verticalOffset) * self.countOfTerms + height * 2);
    
    [self.scrollView addSubview:term];
    [self.scrollView addSubview:definition];
    
    self.countOfTerms++;
}


@end
