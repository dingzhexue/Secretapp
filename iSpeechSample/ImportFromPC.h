//
//  ImportFromPC.h
//  RDRProject
//
//  Created by C31 on 30/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImportFromPCDelegate
    - (void)importableDocTapped:(NSString*)importPath;
@end

@interface ImportFromPC : UITableViewController
{
    NSMutableArray *importableDoc;
    id <ImportFromPCDelegate> _delegate;
    AppDelegate *app;

}
@property (copy) NSMutableArray *importableDoc;
@property (assign) id <ImportFromPCDelegate> delegate;

@end
