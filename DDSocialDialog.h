
#import <UIKit/UIKit.h>

typedef enum
{
	DDSocialDialogThemeTwitter = 0,
	DDSocialDialogThemePlurk
} DDSocialDialogTheme;

@protocol DDSocialDialogDelegate;

@interface DDSocialDialog : UIView 
{
@private	
	DDSocialDialogTheme theme_;

	UIButton *closeButton_;
	UIImageView *titleLabel_;
	UIView *contentView_;
	UIControl *touchInterceptingControl_;

	CGSize defaultFrameSize_;
	UIDeviceOrientation orientation_;
	BOOL showingKeyboard_;
	
	id <DDSocialDialogDelegate> dialogDelegate_;
}

@property (nonatomic, readonly) DDSocialDialogTheme theme;
@property (nonatomic, readonly, retain) UIImageView *titleLabel;
@property (nonatomic, readonly, retain) UIView *contentView;
@property (nonatomic, strong) id <DDSocialDialogDelegate> dialogDelegate;

- (id)initWithFrame:(CGRect)frame theme:(DDSocialDialogTheme)theme;
- (void)dismiss:(BOOL)animated;
- (void)show;
- (void)cancel;
@end


@protocol DDSocialDialogDelegate <NSObject>
@optional
- (void)socialDialogDidCancel:(DDSocialDialog *)socialDialog;
@end