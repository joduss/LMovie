//
//  SettingTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 09.08.12.
//
//

#import "SettingTVC.h"
#import "MBProgressHUD.h"


@interface SettingTVC ()
@property MBProgressHUD *progressView;
@property (nonatomic, strong) UIView *blackViewPictureLoading;
@end

@implementation SettingTVC
@synthesize appLanguageChooser = _appLanguageChooser;
@synthesize importCell;
@synthesize downloadMoviePosterCell = _downloadMoviePosterCell;
@synthesize exportCell = _exportCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings KEY",@"Titre de la fenêtre settings");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStylePlain target:self action:@selector(okButtonPressed:)];
    self.navigationItem.leftBarButtonItem = okButton;
    [_appLanguageChooser addTarget:self action:@selector(AppLanguageChanged) forControlEvents:UIControlEventValueChanged];
    
    UILabel *appLanguageLabel = (UILabel *)[self.appLanguageCell viewWithTag:100];
    UILabel *downloadMoviePosterLabel = (UILabel *)[self.downloadMoviePosterCell viewWithTag:100];
    UILabel *importLabel = (UILabel *)[self.importCell viewWithTag:100];
    UILabel *exportLabel = (UILabel *)[self.exportCell viewWithTag:100];
    appLanguageLabel.text = NSLocalizedString(@"App Language KEY", @"");
    downloadMoviePosterLabel.text = NSLocalizedString(@"Download Poster KEY", @"");
    importLabel.text = NSLocalizedString(@"import KEY", @"");
    exportLabel.text = NSLocalizedString(@"export KEY", @"");
    
    int langueChoix;
    if([[[SettingsLoader settings] language] isEqualToString:@"en"]){
         langueChoix = 0;
    }
    else{
        langueChoix = 1;
    }
    
    [self.appLanguageChooser setSelectedSegmentIndex:langueChoix];

    
    
}



- (void)viewDidUnload
{
    [self setAppLanguageCell:nil];
    [super viewDidUnload];
    [self setExportCell:nil];
    [self setImportCell:nil];
    [self setDownloadMoviePosterCell:nil];
    [self setAppLanguageChooser:nil];
    [self setBlackViewPictureLoading:nil];
    [self setProgressView:nil];
    [self setAppLanguageChooser:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}





-(IBAction)okButtonPressed:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
}









#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == self.importCell || cell == self.exportCell){
        
        if(cell == self.importCell){
            DLog(@"import cell");
            [[[ImportExport alloc] init] import];
        }
        else if (cell == self.exportCell){
            DLog(@"export cell");
            [[[ImportExport alloc] init] export];
        }
    }
    else if (cell == self.downloadMoviePosterCell){
        DLog(@"downloadMoviePosterCell pressed");
        [DownloadMoviePoster downloadPosters];
    }
    
    
    [cell setSelected:NO animated:YES];
}




-(void)AppLanguageChanged
{
    DLog(@"User a changé de langue en cliquant");
    SettingsLoader *s = [SettingsLoader settings];
    int choix = [self.appLanguageChooser selectedSegmentIndex];
    
    switch (choix) {
        case 0:
            [s setLanguage:@"en"];
            break;
        case 1:
            [s setLanguage:@"fr"];
            break;
        default:
            [s setLanguage:@"en"];
            break;
    }
}















@end
