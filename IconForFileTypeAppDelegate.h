//
//  IconForFileTypeAppDelegate.h
//  IconForFileType
//
//  Created by Ricky Nelson on 8/1/10.
//  Copyright 2010 Lark Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IconForFileTypeAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	IBOutlet NSImageView *iconView;
    IBOutlet NSTextField *fileType;
    IBOutlet NSTextField *fileOnDisk;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)browseForFile:(id)sender;
- (IBAction)saveIcon:(id)sender;

- (void)saveImage:(NSString *)outputPath;

// text field delegate
- (void)controlTextDidEndEditing:(NSNotification *) aNotification;

@end
