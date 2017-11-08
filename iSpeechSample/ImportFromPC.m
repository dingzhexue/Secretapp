//
//  ImportFromPC.m
//  RDRProject
//
//  Created by C31 on 30/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImportFromPC.h"
#import "AppDelegate.h"
@implementation ImportFromPC
@synthesize importableDoc,delegate;

AppDelegate *app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    importableDoc = [NSMutableArray array];
    // Get public docs dir
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *publicDocumentsDir = [paths objectAtIndex:0];   
    
    
   
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:publicDocumentsDir error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
    }
    
    // Add all mp3 files to a list    
    
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"mp3" options:NSCaseInsensitiveSearch] == NSOrderedSame) 
        {        
            NSString *fullPath = [publicDocumentsDir stringByAppendingPathComponent:file];
                    //NSLog(@"fullPath : %@",fullPath);
                    
            [importableDoc addObject:fullPath];
            
           // NSFileManager *fileManager = [NSFileManager defaultManager];
            
           // [fileManager removeItemAtPath:[publicDocumentsDir stringByAppendingPathComponent:fullPath] error:nil];
        }
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc 
{
    [importableDoc release];
    importableDoc = nil;
    [super dealloc];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"Count : %d",importableDoc.count);
    return importableDoc.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString *fullPath = [importableDoc objectAtIndex:indexPath.row];
    NSString *fileName = [fullPath lastPathComponent];
    cell.textLabel.text = fileName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fullPath = [importableDoc objectAtIndex:indexPath.row];
    
        [delegate importableDocTapped:fullPath];
    
    NSLog(@"importable doc::: %@",importableDoc);
    
   /* NSNumber *num=[[NSNumber alloc] initWithInt:indexPath.row];
    [app.AddedSongsArray addObject:num];
    
    NSLog(@"Added song arr=== %@",app.AddedSongsArray);
    
    for (int i=0;i< [app.AddedSongsArray count]; i++) {
    if ([app.AddedSongsArray objectAtIndex:i] == [importableDoc objectAtIndex:i] ){
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[importableDoc objectAtIndex:i] error: &error];
    
    [importableDoc removeObjectAtIndex:i];
    }
*/

    [importableDoc removeObjectAtIndex:indexPath.row];
    
    //[self viewDidLoad];
}

@end
