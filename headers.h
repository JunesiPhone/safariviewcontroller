#import <WebKit/WebKit.h>

@interface SFSafariViewControllerConfiguration : NSObject
@end

@interface SFSafariViewController : UIViewController
@property (nonatomic, setter=_setShowingLinkPreviewWithMinimalUI:) BOOL _showingLinkPreviewWithMinimalUI;
-(id)initWithURL:(id)arg0 configuration:(id)arg1 ;
@end

@interface CSMainPageView : UIView
@end