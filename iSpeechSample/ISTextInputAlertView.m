//
//  ISTextInputAlertView.m
//  iSpeech
//
//  Created by Grant Butler on 6/30/11.
//  Copyright 2011 iSpeech, Inc. All rights reserved.
//

#import "ISTextInputAlertView.h"

@implementation ISTextInputAlertView {
    UIControl *p_okButton;
    NSInteger p_okIndex;
    
    ISTextInputAlertViewCallback p_callback;
}

@synthesize textView = _textView;

- (instancetype)initWithTitle:(NSString *)title okButtonTitle:(NSString *)okButtonTitle callback:(ISTextInputAlertViewCallback)callback {
    if((self = [super initWithTitle:title message:@"\n\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:nil])) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 85.0)];
        _textView.delegate = self;
        _textView.dataDetectorTypes = UIDataDetectorTypeNone;
        _textView.keyboardAppearance = UIKeyboardAppearanceAlert;
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.layer.cornerRadius = 3.0;
        _textView.alpha = 0.9;
        
        [self addSubview:_textView];
        
        p_callback = Block_copy(callback);
        
        p_okIndex = [self addButtonWithTitle:okButtonTitle];
        
        // This is totally hacky, but it gets the job done.
        // Currently, this is App Store safe, as this is used in Bush and Obama. However, this could change at any time.
        for(UIView *view in self.subviews) {
            if([view isKindOfClass:[UIControl class]]) {
                if(view.tag == p_okIndex + 1) { // Button indices are 0-based, where as the tags are 1-based.
                    p_okButton = (UIControl *)view;
                    
                    break;
                }
            }
        }
        
        p_okButton.enabled = NO;
        
        [self addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (void)textViewDidChange:(UITextView *)tv {
    p_okButton.enabled = (tv.hasText);
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    [self textViewDidChange:_textView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != p_okIndex) {
        return;
    }
    
    if(p_callback) {
        p_callback(_textView.text);
    }
}

- (BOOL)canBecomeFirstResponder {
    return _textView.canBecomeFirstResponder && self.visible;
}

- (BOOL)becomeFirstResponder {
    return [_textView becomeFirstResponder];
}

- (BOOL)canResignFirstResponder {
    return _textView.canResignFirstResponder && self.visible;
}

- (BOOL)resignFirstResponder {
    return [_textView resignFirstResponder];
}

- (BOOL)isFirstResponder {
    return _textView.isFirstResponder;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"alpha"]) {
        if(self.alpha == 1.0 && !_textView.isFirstResponder) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_textView becomeFirstResponder];
            });
        } else if(self.alpha == 0.0 && _textView.isFirstResponder) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_textView resignFirstResponder];
            });
        }
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"alpha"];
    
    [_textView release];
    _textView = nil;
    
    Block_release(p_callback);
    p_callback = NULL;
    
    [super dealloc];
}

@end
