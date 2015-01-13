#import "STErrors.h"

void STFatalError(NSString *errorMessage)
{
    NSRunInformationalAlertPanel(NSLocalizedString(@"A fatal error has occurred", "Fatal error"),
                                 @"%@",
                                 NSLocalizedString(@"Quit", @"Quit"),
                                 nil,
                                 nil,
                                 errorMessage);
    exit(EXIT_FAILURE);
}
