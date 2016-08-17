//
//  FolderWithFiles.m
//  DropBoxAPI
//
//  Created by Thabresh on 8/16/16.
//  Copyright © 2016 VividInfotech. All rights reserved.
//

#import "FolderWithFiles.h"

@interface FolderWithFiles ()
{
    NSMutableArray *folderNameList;
    NSMutableArray *folderNames;
    NSMutableArray *fileNames;
    NSString *loadPaths;
}
@end

@implementation FolderWithFiles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadPaths = @"/";
     if (self.currentPath == nil || [self.currentPath isEqualToString:@""]) self.currentPath = @"/";    
  
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"Add Folder Filled-50"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(TappedUser:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow-angle"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
    
   
    [self.folderTbl registerNib:[UINib nibWithNibName:@"FolderCell" bundle:nil] forCellReuseIdentifier:@"FolderCell"];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
   // [self LoadRestPath];
    [self.restClient loadMetadata:loadPaths];
    // Do any additional setup after loading the view.
}
-(void)TappedUser:(UITapGestureRecognizer *)pinchGestureRecognizer
{
    HMPopUpView *hmPopUp = [[HMPopUpView alloc] initWithTitle:@"Folder Name" okButtonTitle:@"Create" cancelButtonTitle:@"Cancel" delegate:self];
    hmPopUp.borderColor = [UIColor whiteColor];
    hmPopUp.titleSeparatorColor = [UIColor whiteColor];
    hmPopUp.cancelButtonBGColor =  [UIColor blueColor];
    hmPopUp.okButtonBGColor = [UIColor blueColor];
    hmPopUp.textFieldBGColor = [UIColor lightGrayColor];
    hmPopUp.borderWidth = 1;
    hmPopUp.transitionType = HMPopUpTransitionTypePopFromBottom;
    hmPopUp.dismissType = HMPopUpDismissTypeFadeOutTop;
    [hmPopUp showInView:self.view];
}
#pragma mark - HMPopUpViewDelegate
-(void)popUpView:(HMPopUpView *)view accepted:(BOOL)accept inputText:(NSString *)text{
    if (accept) {
        [[self restClient] createFolder:[NSString stringWithFormat:@"%@/%@",_currentPath,text]];
        //do stuff
        NSLog(@"User pressed Okay button");
        
    } else {
        NSLog(@"User pressed Cancel button");
        
    }
}
-(void) backButtonAction:(id)sender {
    if (loadPaths.length<=1 || [loadPaths isEqualToString:@"//"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSMutableArray *pathSep = [[loadPaths componentsSeparatedByString:@"/"]mutableCopy];
        [pathSep removeLastObject];
        for (int i=0; i<pathSep.count; i++) {
            if (i==0) {
                [pathSep replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",[pathSep objectAtIndex:i]]];
            }else{
                [pathSep replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"/%@",[pathSep objectAtIndex:i]]];
            }
            
        }
        loadPaths = [pathSep componentsJoinedByString:@""];
        //[self LoadRestPath];
        [self.restClient loadMetadata:loadPaths];
    }

}
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    folderNames = [NSMutableArray new];
    folderNameList = [NSMutableArray new];
    NSMutableArray *dirList = [[NSMutableArray alloc] init];
    if (metadata.isDirectory) {
        for (DBMetadata *file in metadata.contents) {
            if (![file.filename hasSuffix:@".exe"]) {
                if ([file isDirectory]) {
                    [dirList addObject:file];
                }
            }
        }
        for (DBMetadata *file in metadata.contents) {
            if (![file.filename hasSuffix:@".exe"]) {
                if (![file isDirectory]) {
                    [dirList addObject:file];
                }
            }
        }
    }
    folderNames = dirList;
        if (metadata.isDirectory) {
            for (DBMetadata *file in metadata.contents) {
                if ([file isDirectory]) {
                    [folderNameList addObject:[NSString stringWithFormat:@"0,%@",file.filename]];
                }
            }
            for (DBMetadata *file in metadata.contents) {
                if (![file isDirectory]) {
                     [folderNameList addObject:[NSString stringWithFormat:@"1,%@",file.filename]];
                }}
           
        }
     [self.folderTbl reloadData];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}
#pragma mark
#pragma mark - FolderCreation
// Folder is the metadata for the newly created folder
- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    //NSLog(@"Created Folder Path %@",folder.path);
    // NSLog(@"Created Folder name %@",folder.filename);
    [[[UIAlertView alloc]initWithTitle:@"Folder Created" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    ///[self LoadRestPath];
    [self.restClient loadMetadata:loadPaths];
}
// [error userInfo] contains the root and path
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    [[[UIAlertView alloc]initWithTitle:error.description message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    NSLog(@"%@",error);
}
#pragma mark
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBMetadata *file = (DBMetadata *)(folderNames)[indexPath.row];
    FolderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell" forIndexPath:indexPath];
    if (![[[folderNameList[indexPath.row]componentsSeparatedByString:@","]objectAtIndex:0] isEqualToString:@"0"]) {
        cell.iconic.image = [UIImage imageNamed:@"File-40"];
    }
    cell.txtTitle.text = [[folderNameList[indexPath.row]componentsSeparatedByString:@","]objectAtIndex:1];
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E MMM d yyyy" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    if ([file isDirectory]) {
        cell.txtDate.text = @"";
        [cell.txtDate setNeedsDisplay];
    } else {
        cell.txtDate.text = [NSString stringWithFormat:NSLocalizedString(@"%@, modified %@", @"DropboxBrowser: File detail label with the file size and modified date."), file.humanReadableSize, [formatter stringFromDate:file.lastModifiedDate]];
        [cell.txtDate setNeedsDisplay];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return folderNameList.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[folderNameList[indexPath.row]componentsSeparatedByString:@","]objectAtIndex:0] isEqualToString:@"0"]) {
        if ([loadPaths isEqualToString:@"/"]||[loadPaths isEqualToString:@"//"]) {
            loadPaths =[NSString stringWithFormat:@"%@%@",loadPaths,[[folderNameList[indexPath.row]componentsSeparatedByString:@","]objectAtIndex:1]];
        }else{
            loadPaths =[NSString stringWithFormat:@"%@/%@",loadPaths,[[folderNameList[indexPath.row]componentsSeparatedByString:@","]objectAtIndex:1]];
        }
       [self.restClient loadMetadata:loadPaths];
    }else{
//        self.selectedFile = (DBMetadata *)(folderNames)[indexPath.row];       
//        if ([self.selectedFile isDirectory]) {
//            if ([loadPaths isEqualToString:@"/"]||[loadPaths isEqualToString:@"//"]) {
//                loadPaths =[NSString stringWithFormat:@"%@%@",loadPaths,[[folderNameList[indexPath.row]componentsSeparatedByString:@","]objectAtIndex:1]];
//            }else{
//                loadPaths =[NSString stringWithFormat:@"%@/%@",loadPaths,[[folderNameList[indexPath.row]componentsSeparatedByString:@","]objectAtIndex:1]];
//            }
//            [self.restClient loadMetadata:loadPaths];
//            
//        } else {
//            self.currentFileName = self.selectedFile.filename;
//            
//            // Check if our delegate handles file selection
//            if ([self.rootViewDelegate respondsToSelector:@selector(dropboxBrowser:didSelectFile:)]) {
//                [self.rootViewDelegate dropboxBrowser:self didSelectFile:self.selectedFile];
//            } else if ([self.rootViewDelegate respondsToSelector:@selector(dropboxBrowser:selectedFile:)]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//                [self.rootViewDelegate dropboxBrowser:self selectedFile:self.selectedFile];
//#pragma clang diagnostic pop
//            } else {
//                // Download file
//                //[self downloadFile:self.selectedFile replaceLocalVersion:NO];
//            }  }
    }
}
-(void)LoadRestPath
{
    [self.restClient loadMetadata:_currentPath];
}
#pragma mark - Dropbox File and Directory Functions

- (BOOL)listDirectoryAtPath:(NSString *)path {
    if ([self isDropboxLinked]) {
        [[self restClient] loadMetadata:path];
        return YES;
    } else return NO;
}
- (BOOL)isDropboxLinked {
    return [[DBSession sharedSession] isLinked];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
