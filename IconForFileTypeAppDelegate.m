//
//  IconForFileTypeAppDelegate.m
//  IconForFileType
//
//  Created by Ricky Nelson on 8/1/10.
//  Copyright 2010 Lark Software, LLC. All rights reserved.
//

#import "IconForFileTypeAppDelegate.h"

@implementation IconForFileTypeAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void)controlTextDidEndEditing:(NSNotification *) aNotification
{
	if (fileType == [aNotification object])
	{
		if ([[fileType stringValue] localizedCompare:@""] != NSOrderedSame)
		{
			NSImage *image = [[NSWorkspace sharedWorkspace] iconForFileType:[fileType stringValue]];
			[image setSize:NSMakeSize(128, 128)];
			[iconView setImage:image];
		}
	}
	if (fileOnDisk == [aNotification object])
	{
		if ([[fileOnDisk stringValue] localizedCompare:@""] != NSOrderedSame)
		{
			NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:[fileOnDisk stringValue]];
			[image setSize:NSMakeSize(128, 128)];
			[iconView setImage:image];
		}
	}
}

- (IBAction)browseForFile:(id)sender
{
	// reset the file type field
	[fileType setStringValue:@""];

	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanSelectHiddenExtension:YES];
	
	NSInteger result = [openPanel runModal];
	
	if (NSOKButton == result) {
        NSArray *filesToOpen = [openPanel URLs];
		
        int i, count = [filesToOpen count];
		
        for (i=0; i<count; i++) {			
            NSURL *aFile = [filesToOpen objectAtIndex:i];
			
			[fileOnDisk setStringValue:[aFile path]];
			[fileOnDisk becomeFirstResponder];
			
			// a hack to kick off the controlTextDidEndEditing event
			[fileType becomeFirstResponder];
			[fileOnDisk becomeFirstResponder];
		}		
    }
}

- (IBAction)saveIcon:(id)sender
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"icns"]];
	[savePanel setCanSelectHiddenExtension:YES];
	
	NSInteger result = [savePanel runModal];
	if (NSOKButton == result) {
		[self saveImage:[[savePanel URL] path]];
	}
}

- (void)saveImage:(NSString *)outputPath
{
	NSImage *icon = [iconView image];
	NSData  *iconData = [NSData dataWithData:[icon TIFFRepresentation]];

	BOOL bSuccess = [iconData writeToFile:outputPath atomically:YES];
	
	if (bSuccess) {
		NSLog(@"SUCCESS: %@ written successfully", outputPath);
	}
	else {
		NSString *error = [NSString stringWithFormat:@"Unable to save the icon to the file: %@", outputPath];
		NSLog(@"ERROR: unable to save icon: %@", outputPath);
		NSRunAlertPanel (@"ERROR: unable to save icon",
						 error,
						 nil,nil,nil,nil);
	}
}

@end
