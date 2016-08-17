//
//  FolderWithFiles.h
//  DropBoxAPI
//
//  Created by Thabresh on 8/16/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@protocol DropboxBrowserDelegate;
@interface FolderWithFiles : UIViewController<DBRestClientDelegate,HMPopUpViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) DBMetadata *selectedFile;
@property (weak, nonatomic) IBOutlet UITableView *folderTbl;
/// Dropbox Delegate Property
@property (nonatomic, strong) NSArray *allowedFileTypes;
@property (nonatomic, weak) id <DropboxBrowserDelegate> rootViewDelegate;
@property (nonatomic, strong) FolderWithFiles *subdirectoryController;
@property (nonatomic, strong, readwrite) NSString *currentPath;
@property (nonatomic, strong, readwrite) NSString *currentFileName;
@end
/// The DropboxBrowser Delegate can be used to recieve download notifications, failures, successes, errors, file conflicts, and even handle the download yourself.
@protocol DropboxBrowserDelegate <NSObject>

@optional

//----------------------------------------------------------------------------------------//
// Available Methods - Use these delegate methods for a variety of operations and events  //
//----------------------------------------------------------------------------------------//

/// Sent to the delegate when there is a successful file download
- (void)dropboxBrowser:(FolderWithFiles *)browser didDownloadFile:(NSString *)fileName didOverwriteFile:(BOOL)isLocalFileOverwritten;

/// Sent to the delegate if DropboxBrowser failed to download file from Dropbox
- (void)dropboxBrowser:(FolderWithFiles *)browser didFailToDownloadFile:(NSString *)fileName;

/// Sent to the delegate if the selected file already exists locally
- (void)dropboxBrowser:(FolderWithFiles *)browser fileConflictWithLocalFile:(NSURL *)localFileURL withDropboxFile:(DBMetadata *)dropboxFile withError:(NSError *)error;

/// Sent to the delegate when the user selects a file. Implementing this method will require you to download or manage the selection on your own. Otherwise, automatically downloads file if not implemented.
- (void)dropboxBrowser:(FolderWithFiles *)browser didSelectFile:(DBMetadata *)file;

/// Sent to the delegate if the share link is successfully loaded
- (void)dropboxBrowser:(FolderWithFiles *)browser didLoadShareLink:(NSString *)link;

/// Sent to the delegate if there was an error creating or loading share link
- (void)dropboxBrowser:(FolderWithFiles *)browser didFailToLoadShareLinkWithError:(NSError *)error;

/// Sent to the delegate when a file download notification is delivered to the user. You can use this method to record the notification ID so you can clear the notification if ncessary.
- (void)dropboxBrowser:(FolderWithFiles *)browser deliveredFileDownloadNotification:(UILocalNotification *)notification;

/// Sent to the delegate after the DropboxBrowserViewController is dismissed by the user - Do \b NOT use this method to dismiss the DropboxBrowser
- (void)dropboxBrowserDismissed:(FolderWithFiles *)browser;

//---------------------------------------------------------------------------------//
// Deprecated Methods - These methods will become unavailable in a future version  //
//---------------------------------------------------------------------------------//

/** DEPRECATED. Called when a file finishes downloading. @deprecated This method is deprecated. Use \p dropboxBrowser:didDownloadFile:didOverwriteFile:  instead */
- (void)dropboxBrowser:(FolderWithFiles *)browser downloadedFile:(NSString *)fileName __deprecated;

/** DEPRECATED. Called when a file finishes downloading. @deprecated This method is deprecated. Use \p dropboxBrowser:didDownloadFile:didOverwriteFile: instead */
- (void)dropboxBrowser:(FolderWithFiles *)browser downloadedFile:(NSString *)file isLocalFileOverwritten:(BOOL)isLocalFileOverwritten __deprecated;

/** DEPRECATED. Called when a file is selected for download. @deprecated This method is deprecated. Use \p dropboxBrowser:didSelectFile: instead */
- (void)dropboxBrowser:(FolderWithFiles *)browser selectedFile:(DBMetadata *)file __deprecated;

/** DEPRECATED. Called when a file download fails. @deprecated This method is deprecated. Use \p dropboxBrowser:didFailToDownloadFile: instead */
- (void)dropboxBrowser:(FolderWithFiles *)browser failedToDownloadFile:(NSString *)fileName __deprecated;

/** DEPRECATED. Called when there is a conflict between a Dropbox file and a local file. @deprecated This method is deprecated. Use \p dropboxBrowser:fileConflictWithLocalFile:withDropboxFile:withError: instead */
- (void)dropboxBrowser:(FolderWithFiles *)browser fileConflictError:(NSDictionary *)error __deprecated;

/** DEPRECATED. Called when a there is an error creating a share link. @deprecated This method is deprecated. Use \p dropboxBrowser:didFailToLoadShareLinkWithError: instead */
- (void)dropboxBrowser:(FolderWithFiles *)browser failedLoadingShareLinkWithError:(NSError *)error __deprecated;

@end
