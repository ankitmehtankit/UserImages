//
//  IntelliSchoolUtilityClass.m
//  IntelliSchool
//
//  Created by macmini1 on 03/12/15.
//  Copyright © 2015 intellinet. All rights reserved.
//

#import "UtilityClass.h"
#import "DataModels.h"
#import "KVNProgress.h"



@implementation UtilityClass

#define  myAppdelegateObj (((AppDelegate *)[[UIApplication sharedApplication] delegate]))

/**
 This method is used to show alertView With Error Message.
 @param error NSError Object
 */
+(void)showError:(NSError *)error {
    if (error != nil) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to find on server, Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

+ (void) getDataFromServerAtIndex:(NSString *)indexValue inCollection:(UICollectionView *)collectionView {
    
}

@end
