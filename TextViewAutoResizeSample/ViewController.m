//
//  ViewController.m
//  TextViewAutoResizeSample
//
//  Created by MORITA NAOKI on 2014/08/23.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import "ViewController.h"

static const CGFloat ViewControllerTextViewBottomConstraintDefault = 200.0;
static const CGFloat ViewControllerKeyboardUpperMargin = 10.0;
static NSString *const ViewControllerTextViewAccessoryFrame = @"{{0, 0}, {320, 44}}";

@interface ViewController ()
<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(fitKeyboardSize:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(fitKeyboardSize:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [center addObserver:self selector:@selector(fitKeyboardSize:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void)doneButtonTapped:(UIBarButtonItem *)item
{
    [self.textView resignFirstResponder];
}

- (void)fitKeyboardSize:(NSNotification *)notification
{
    NSString *name = notification.name;
    NSDictionary *userInfo = notification.userInfo;
    
    if ([name isEqualToString:UIKeyboardWillHideNotification]) {
        self.textViewBottomConstraint.constant = ViewControllerTextViewBottomConstraintDefault;
        return;
    }
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSUInteger curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.textViewBottomConstraint.constant = CGRectGetHeight(rect) + ViewControllerKeyboardUpperMargin;
    
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *flexibleSpaceItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectFromString(ViewControllerTextViewAccessoryFrame)];
    toolbar.items = @[flexibleSpaceItem, doneButtonItem];
    
    textView.inputAccessoryView = toolbar;
    return YES;
}

@end
