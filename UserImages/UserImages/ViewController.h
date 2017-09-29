//
//  ViewController.h
//  UserImages
//
//  Created by Ankit Mehta on 26/09/17.
//  Copyright © 2017 Ankit Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVNProgress.h"

@interface ViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
{
    IBOutlet UICollectionView *collectionView;
}

@property (nonatomic) KVNProgressConfiguration *basicConfiguration;
@end

