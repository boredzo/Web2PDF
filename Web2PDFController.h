//
//  Web2PDFController.h
//  Web2PDF
//
//  Created by Mac-arena the Bored Zo on 2005-03-16.
//  Copyright 2005 Mac-arena the Bored Zo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface Web2PDFController: NSObject
{
	IBOutlet NSComboBox *URLField;
	IBOutlet WebView *webView;
	IBOutlet NSProgressIndicator *spinner;
	NSString *defaultFilename;
}

- (IBAction)takeStringURLFrom:sender;

- (IBAction)saveDocumentAs:sender;

#pragma mark -
#pragma mark WebFrameLoadDelegate conformance

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame;
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame;

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame;

@end
