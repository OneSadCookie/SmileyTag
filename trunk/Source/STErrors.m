#import "STErrors.h"

void STFatalError(NSString *errorMessage)
{
    NSRunInformationalAlertPanel(NSLocalizedString(@"A fatal error has occurred", "Fatal error"),
                                 errorMessage,
                                 NSLocalizedString(@"Quit", @"Quit"),
                                 nil,
                                 nil);
    exit(EXIT_FAILURE);
}
