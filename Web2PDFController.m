//
//  Web2PDFController.m
//  Web2PDF
//
//  Created by Mac-arena the Bored Zo on 2005-03-16.
//  Copyright 2005 Mac-arena the Bored Zo. All rights reserved.
//

#import "Web2PDFController.h"


@implementation Web2PDFController

- (WebPreferences *)webPreferences {
	return [WebPreferences standardPreferences];
}

#pragma mark -
#pragma mark Actions

- (IBAction)takeStringURLFrom:sender {
	[webView takeStringURLFrom:URLField];
}

- (IBAction)saveDocumentAs:sender {
	[[NSSavePanel savePanel] beginSheetForDirectory:nil
											   file:defaultFilename
									 modalForWindow:[webView window]
									  modalDelegate:self
									 didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:)
										contextInfo:NULL];
}
- (void)savePanelDidEnd:(NSSavePanel *)savePanel
			 returnCode:(int)returnCode
			contextInfo:(void *)contextInfo
{
	if(returnCode == NSOKButton) {
		WebFrame     *frame     = [webView   mainFrame];
		WebFrameView *frameView = [frame     frameView];
		NSView       *docView   = [frameView documentView];
		NSData       *data      = [docView   dataWithPDFInsideRect:[docView bounds]];

		[data writeToFile:[savePanel filename] atomically:NO];
	}
}

#pragma mark -
#pragma mark NSApplication delegate conformance

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	[[WebPreferences standardPreferences] setShouldPrintBackgrounds:YES];
	NSLog(@"should print backgrounds: %u", [[WebPreferences standardPreferences] shouldPrintBackgrounds]);

	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setRequiredFileType:@"pdf"];
	[savePanel setCanSelectHiddenExtension:YES];
	if([savePanel respondsToSelector:@selector(setCanCreateDirectories:)])
		[savePanel setCanCreateDirectories:YES];
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
	return YES;
}

- (BOOL)application:(NSApplication *)app openFile:(NSString *)path {
	NSURL *URL = [NSURL fileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	[[webView mainFrame] loadRequest:request];
	return YES;
}

#pragma mark -
#pragma mark WebFrameLoadDelegate conformance

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
	[spinner startAnimation:nil];
}
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	[spinner stopAnimation:nil];
}
- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
	[spinner stopAnimation:nil];
}
- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
	[spinner stopAnimation:nil];
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
	if(sender == webView) {
		frame = [sender mainFrame];
		WebDataSource *dataSource = [frame dataSource];

		NSURLRequest *request = [dataSource initialRequest];
		NSURL *URL = [request URL];
		NSString *path = [URL path];
		defaultFilename = [[[path isEqualToString:@"/"] ? [URL host] : [[path lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@".pdf"] retain];

		[[webView window] setTitle:[dataSource pageTitle]];
	}
}

@end
