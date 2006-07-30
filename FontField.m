//
//  FontField.m
//  Web2PDF
//
//  Created by Mac-arena the Bored Zo on 2005-03-17.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FontField.h"


@implementation FontField

- (BOOL)allowsEditingTextAttributes {
	return YES;
}
- (BOOL)canBecomeKeyView {
	return YES;
}
- (BOOL)becomeFirstResponder {
	[[NSFontManager sharedFontManager] setSelectedFont:[self font] isMultiple:NO];
	[self drawRect:[self frame]];
	return YES;
}
- (unsigned int)validModesForFontPanel:(NSFontPanel *)fontPanel {
	return NSFontPanelAllModesMask;
}
- (void)mouseDown:(NSEvent *)theEvent {
	[[self window] makeFirstResponder:self];
}
- (void)mouseUp:(NSEvent *)theEvent {
	//[[self window] makeFirstResponder:self];
}
- (void)drawRect:(NSRect)rect {
	[super drawRect:rect];

	NSWindow *win = [self window];
	NSLog(@"%u - %p", [win isKeyWindow], [win firstResponder]);
	if([win isKeyWindow] && ([win firstResponder] == self)) {
		[self setKeyboardFocusRingNeedsDisplayInRect:rect];
		NSSetFocusRingStyle(NSFocusRingOnly);
		NSLog(@"filling %@", NSStringFromRect(rect));
		NSRectFill(rect);
	}
}

- (IBAction)changeFont:sender {
	NSFont *oldFont = [self font];
	NSFont *newFont = [sender convertFont:oldFont];
	[self setFont:newFont];
	[self setStringValue:[newFont familyName]];
}

@end
