//
//  IconForFileTypeAppDelegate.m
//  IconForFileType
//
// Copyright (c) 2012, Ricky Nelson
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// Neither the name of the Ricky Nelson nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
