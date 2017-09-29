//
//  IntelliSchoolUtilityClass.h
//  IntelliSchool
//
//  Created by macmini1 on 03/12/15.
//  Copyright © 2015 intellinet. All rights reserved.
//

typedef void (^ButtonCompletionBlock)(int buttonIndex);
typedef void(^assignedSuccessfully)();


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AMParser.h"
#import "DataModels.h"
#import "AppDelegate.h"


@interface UtilityClass : NSObject


+(void)showError:(NSError *)error ;
+ (void) getDataFromServerAtIndex:(NSString *)indexValue inCollection:(UICollectionView *)collectionView ;


@end
