//
//  SMREditCostBenefitViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 12/19/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewController.h"
#import "SMRCostBenefitViewController.h"

@interface SMREditCostBenefitViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) SMRCostBenefit *costBenefit;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (nonatomic, readwrite) BOOL keyboardVisible;
@property (nonatomic, readwrite) CGRect keyboardFrameInWindowCoordinates;
@property (nonatomic, readwrite) CGRect keyboardFrameInViewCoordinates;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextFieldLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

- (IBAction)titleTextFieldEditingChanged:(id)sender;

@end

@implementation SMREditCostBenefitViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefitItem:(SMRCostBenefit *)costBenefit isNew:(BOOL)isNew managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMREditCostBenefitView" bundle:nil];

    if (self) {
        _costBenefit = costBenefit;
        _isNew = isNew;
        _managedObjectContext = managedObjectContext;
    }

    return self;
}
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self startListeningForNotifications];
    self.titleTextField.delegate = self;
    if (self.isNew) {
        self.title = @"New CBA";
        self.costBenefit = [SMRCostBenefit createCostBenefitInContext:self.managedObjectContext];
        self.costBenefit.dateCreated = [[NSDate alloc] init];
        self.costBenefit.type = @"substance";
    }
    else {
        self.title = @"Edit CBA";
        self.titleTextField.text = self.costBenefit.title;
        self.navigationController.toolbarHidden = NO;
        UIBarButtonItem *trashBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonTouchUpInside:)];
        NSArray *items = [NSArray arrayWithObjects:trashBarButtonItem, nil];
        self.toolbarItems = items;
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];

    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem  = self.cancelButton;
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonTouchUpInside:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.saveButton.enabled = NO;
    self.titleTextFieldLabel.text = @"to consider is:".uppercaseString;
    self.titleTextFieldLabel.preferredMaxLayoutWidth = 100;
    [self setPlaceholderText];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.isNew) {
        [self.titleTextField becomeFirstResponder];
    }
}

#pragma mark - SMREditCostBenefitItemViewController

- (void)startListeningForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopListeningForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    self.keyboardVisible = YES;
    self.keyboardFrameInWindowCoordinates = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrameInViewCoordinates = [self keyboardFrameInViewCoordinates:self.view];

    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;

    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        // Scrollview scroll area adjusts to fit keyboard
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.view.frame.size.height - self.keyboardFrameInViewCoordinates.origin.y, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    } completion:nil];
}


- (CGRect)keyboardFrameInViewCoordinates:(UIView *)view {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    // Per http://www.cocoanetics.com/2011/07/calculating-area-covered-by-keyboard/
    CGRect keyboardFrame = self.keyboardFrameInWindowCoordinates;

    // convert own frame to window coordinates, frame is in superview's coordinates
    CGRect ownFrame = [window convertRect:view.frame fromView:view];

    // calculate the area of own frame that is covered by keyboard
    CGRect coveredFrame = CGRectIntersection(ownFrame, keyboardFrame);

    // now this might be rotated, so convert it back
    coveredFrame = [window convertRect:coveredFrame toView:view];

    return coveredFrame;
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.keyboardVisible = NO;
    self.keyboardFrameInWindowCoordinates = CGRectZero;
    self.keyboardFrameInViewCoordinates = CGRectZero;

    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;

    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        // Scrollview scroll area goes back to full-size
        self.scrollView.contentInset =  UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    } completion:nil];
}

- (void)setPlaceholderText {
    if ([self.costBenefit.type isEqualToString:@"substance"]) {
        self.titleTextField.placeholder = @"Substance name, e.g. alcohol, nicotine";
    }
    else {
        self.titleTextField.placeholder = @"Activity name, e.g. gambling, procrastinating";
    }
}

- (void)cancelButtonTapped:(id)sender {
    [self.managedObjectContext rollback];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTouchUpInside:(id)sender {
    self.costBenefit.dateUpdated = [[NSDate alloc] init];
    self.costBenefit.title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSError *error;
    [self.managedObjectContext save:&error];

    UINavigationController *navVC = (UINavigationController *)self.presentingViewController;

    if (!self.isNew) {
        SMRCostBenefitViewController *destVC = (SMRCostBenefitViewController *)navVC.topViewController;
        destVC.managedObjectContext = self.managedObjectContext;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.isNew) {
            SMRCostBenefitViewController *destVC = [[SMRCostBenefitViewController alloc] initWithCostBenefit:self.costBenefit managedObjectContext:self.managedObjectContext];
            [navVC pushViewController:destVC animated:YES];
        }
    }];
}

- (IBAction)titleTextFieldEditingChanged:(id)sender {
    if ([self.titleTextField.text length] < 2) {
        self.saveButton.enabled = NO;
    }
    else {
        self.saveButton.enabled = YES;
    }
}

- (IBAction)deleteButtonTouchUpInside:(id)sender {

    UIAlertController *confirmDeleteAlertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete this CBA?" message:@"All items will be deleted as well. This cannot be undone." preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self.managedObjectContext deleteObject:self.costBenefit];
        NSError *error;
        [self.managedObjectContext save:&error];
        UINavigationController *presentingVC = (UINavigationController *)self.presentingViewController;
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            // Pop back to Home VC.
            [presentingVC popToRootViewControllerAnimated:YES];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [confirmDeleteAlertController addAction:deleteAction];
    [confirmDeleteAlertController addAction:cancelAction];
    [self presentViewController:confirmDeleteAlertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0) {
        cell.textLabel.text = @"The substance".uppercaseString;
        if ([self.costBenefit.type isEqualToString:@"substance"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        cell.textLabel.text = @"The activity".uppercaseString;
        if ([self.costBenefit.type isEqualToString:@"activity"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = UIColor.darkGrayColor;

    return cell;
}

#pragma mark = UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.costBenefit.type = @"substance";
    }
    else {
        self.costBenefit.type = @"activity";
    }
    if (self.titleTextField.text.length > 2) {
        self.saveButton.enabled = YES;
    }
    [self setPlaceholderText];
    [self.tableView reloadData];
}

@end
