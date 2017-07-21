//
//  ViewController.m
//  Receipts
//
//  Created by Errol Cheong on 2017-07-20.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "ViewController.h"
#import "Tag+CoreDataClass.h"
#import "Receipt+CoreDataClass.h"
#import "AppDelegate.h"
#import "AddReceiptViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate,AddReceiptViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Tag*> *tags;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchTags];
    
    NSArray *tagName = [self.tags valueForKey:@"tagName"];
    if (![tagName containsObject:@"Personal"]) {
        [self createTag:@"Personal"];
    }
    if (![tagName containsObject:@"Family"]) {
        [self createTag:@"Family"];
    }
    if (![tagName containsObject:@"Business"]) {
        [self createTag:@"Business"];
    }
}

# pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailView" sender:indexPath];
}

# pragma mark - UITableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tags.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Tag *tag = self.tags[section];
    NSArray *receipts = tag.receipts.allObjects;
    
    return receipts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                            forIndexPath:indexPath];
    
    Tag *tag = self.tags[indexPath.section];
    NSArray<Receipt*>* receipts = tag.receipts.allObjects;
    cell.textLabel.text = receipts[indexPath.row].note;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.tags[section].tagName;
}

# pragma mark - AddReceipt Delegate Method
- (void)addReceipt
{
    [self fetchTags];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddReceiptViewController* dvc = segue.destinationViewController;
    if ([sender isKindOfClass:[NSIndexPath class]])
    {
        dvc.isEditing = YES;
        NSIndexPath *indexPath = sender;
        Tag *tag = self.tags[indexPath.section];
        NSArray<Receipt*>* receipts = tag.receipts.allObjects;
        dvc.receipt = receipts[indexPath.row];
    }
    dvc.delegate = self;
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

- (void)fetchTags
{
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [Tag fetchRequest];
    self.tags = [context executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

- (void)createTag:(NSString*)tagName
{
    Tag* tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:[self getContext]];
    tag.tagName = tagName;
    [[self appDelegate] saveContext];
    [self fetchTags];
}


@end
