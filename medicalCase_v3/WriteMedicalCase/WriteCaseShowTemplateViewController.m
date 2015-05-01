//
//  WriteCaseShowTemplateViewController.m
//  WriteMedicalCase
//
//  Created by ihefe-JF on 15/4/30.
//  Copyright (c) 2015年 GK. All rights reserved.
//

#import "WriteCaseShowTemplateViewController.h"
#import "WriteCaseShowTemplateCell.h"
#import "RWLabel.h"

@interface WriteCaseShowTemplateViewController ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSDictionary *testData;

@property (nonatomic,strong) CoreDataStack *coreDataStack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottonConstraints;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultController;
@end

@implementation WriteCaseShowTemplateViewController

-(NSDictionary *)testData
{
    if (!_testData) {
        _testData = @{@"content":@"猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室猪猪书速速手术室",@"soucre":@"源自个人",@"create":@"张盗铃"};
    }
    return _testData;
}

-(NSManagedObjectContext *)managedObjectContext
{
    return self.coreDataStack.managedObjectContext;
}
-(CoreDataStack *)coreDataStack
{
    _coreDataStack = [[CoreDataStack alloc] init];
    return _coreDataStack;
}
-(void)setUpFetchViewController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Template entityName]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"node.nodeName = %@",self.templateName];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
    
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    self.fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchResultController.delegate = self;
    NSError *error = nil;
    if (![self.fetchResultController performFetch:&error]) {
        NSLog(@"error: %@",error.description);
        abort();
    }else {
        [self.tableView reloadData];
    }
}
-(void)setUpTableView
{
    self.tableView.layer.shadowOffset = CGSizeMake(15, 13);
    self.tableView.layer.shadowOpacity = 1;
    self.tableView.layer.shadowRadius = 20;
    self.tableView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    
    self.tableView.layer.borderWidth = 1;
    //self.tableView.estimatedRowHeight = 55;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *titleStr = [self.templateName stringByAppendingString:@"模板"];
    self.title = titleStr;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpFetchViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedCellLabel:) name:@"didSelectedTitleLabel" object:nil];
}
-(void)didSelectedCellLabel:(NSNotification*) notification
{
    id tempID = [notification object];
    if ([tempID isKindOfClass:[NSString class]]) {
        self.templateName = (NSString*)tempID;
    }else if([tempID isKindOfClass:[WLKCaseNode class]]){
        WLKCaseNode *tempNode =(WLKCaseNode*) [notification object];
        self.templateName = tempNode.nodeName;
    }
    [self setUpFetchViewController];
    
    NSString *titleStr = [self.templateName stringByAppendingString:@"模板"];
    self.title = titleStr;    
}

#pragma mask - table view delegate && data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"section count %@", @(self.fetchResultController.sections.count));
//    return self.fetchResultController.sections.count ;
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return self.dataArray.count;
//    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchResultController.sections[section];
//    
//    return [sectionInfo numberOfObjects];
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  WriteCaseShowTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WriteShowTemplate"];
    [self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}
-(void)configureCell:(WriteCaseShowTemplateCell*)cell AtIndexPath:(NSIndexPath*)indexPath
{
    //Template *template = [self.fetchResultController objectAtIndexPath:indexPath];
   // UITextView *textView = (UITextView*)[cell viewWithTag:1002];
    
    //textView.text = template.content;
    //[textView layoutIfNeeded];
    cell.accessoryType  = UITableViewCellAccessoryDetailButton;
    cell.sourcelabel.text = self.testData[@"soucre"];
    cell.createPeopleLabel.text = self.testData[@"create"];
    [self setSubtitleForCell:cell];
    
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ///查看模板的详细内容
    [self performSegueWithIdentifier:@"templateDetail" sender:nil];

}
- (void)setSubtitleForCell:(WriteCaseShowTemplateCell *)cell {
    
    
    NSString *subtitle = self.testData[@"content"];
    
    if (subtitle.length > 100) {
        subtitle = [NSString stringWithFormat:@"%@...", [subtitle substringToIndex:100]];
    }
    
    [cell.contentLabel setText:subtitle];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Template *template = [self.fetchResultController objectAtIndexPath:indexPath];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    template.content = cell.textView.text;
//    [self.showTemplateDelegate didSelectedTemplateWithNode:template];

   // WriteCaseShowTemplateCell *cell =(WriteCaseShowTemplateCell*) [tableView cellForRowAtIndexPath:indexPath];
   ///引用模板
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static WriteCaseShowTemplateCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"WriteShowTemplate"];
    });
    
    [self configureCell:sizingCell AtIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));

    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
#pragma mask - fetch view controller delegate
/// fetch result controller delegate
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:{
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete:{
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate:{
            break;
        }
            
        default:
            break;
    }
}
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
