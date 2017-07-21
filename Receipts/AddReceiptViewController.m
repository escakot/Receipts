//
//  AddReceiptViewController.m
//  Receipts
//
//  Created by Errol Cheong on 2017-07-20.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "AddReceiptViewController.h"
#import "Tag+CoreDataClass.h"
#import "Receipt+CoreDataClass.h"
#import "AppDelegate.h"

@interface AddReceiptViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;

@property (strong, nonatomic) NSArray<Tag*> *tags;

@end

@implementation AddReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.allowsMultipleSelection = YES;
    self.descriptionTextView.delegate = self;
    
    if (self.isEditing)
    {
        self.amountTextField.text = [NSString stringWithFormat:@"%.2f", self.receipt.amount];
        self.descriptionTextView.text = self.receipt.note;
        self.descriptionTextView.textColor = [UIColor blackColor];
        self.pickerView.date = self.receipt.timeStamp;
    }
        self.descriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.descriptionTextView.layer.borderWidth = 1.0;
    
}

# pragma mark - UITableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.allowsMultipleSelection = YES;
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [Tag fetchRequest];
    self.tags = [context executeFetchRequest:request error:nil];
    
    return self.tags.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = self.tags[indexPath.row].tagName;
        NSLog(@"cell Tag:%@",cell.textLabel.text);
    if (self.isEditing)
    {
        NSArray *selectedTags = self.receipt.tags.allObjects;
        for (Tag* tag in selectedTags) {
            NSLog(@"selected tag: %@",tag.tagName);
            if ([cell.textLabel.text isEqualToString:tag.tagName])
            {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    
    return cell;
}

# pragma mark - UITableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}


# pragma mark - UIButton Methods
- (IBAction)addReceipt:(UIButton *)sender {
    Receipt *receipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:[self getContext]];
    receipt.amount = [self.amountTextField.text floatValue];
    receipt.note = self.descriptionTextView.text;
    receipt.timeStamp = self.pickerView.date;
    NSArray<NSIndexPath*>* pathForTags = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath* index in pathForTags) {
        [receipt addTagsObject:self.tags[index.row]];
    }
    
    [[self appDelegate] saveContext];
    [self.delegate addReceipt];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelReceipt:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"\n\n\nDescription"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"\n\n\nDescription";
        textView.textColor = [UIColor lightGrayColor];
    }
}


# pragma mark - Core Data Methods

- (AppDelegate *)appDelegate {
  return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSPersistentContainer *)getContainer{
  return [self appDelegate].persistentContainer;
}

- (NSManagedObjectContext *)getContext {
  return [self getContainer].viewContext;
}

#pragma mark - Touch Events

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
