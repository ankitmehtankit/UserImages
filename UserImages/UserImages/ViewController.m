//
//  ViewController.m
//  UserImages
//
//  Created by Ankit Mehta on 26/09/17.
//  Copyright © 2017 Ankit Mehta. All rights reserved.
//

#import "ViewController.h"
#import "AMParser.h"
#import "UtilityClass.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()
{
    NSMutableArray *arrayUsers;
    BOOL hasmore;
    UIImage *placeHolderImage;
}
@property UIView *headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView removeFromSuperview];
    
    self.basicConfiguration = [KVNProgressConfiguration defaultConfiguration];
    [KVNProgress setConfiguration:self.basicConfiguration];
    self.basicConfiguration.fullScreen = true;

    placeHolderImage = [UIImage imageNamed:@"ImageTest"];

    arrayUsers = [NSMutableArray new];
    hasmore = true;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KVNProgress showWithStatus:@"Loading..."];
    [[AMParser new] connectionRequestForJsonWithURL:@"1" withJsonDictionary:[NSDictionary new] withSuccessCompletionHandler:^(NSData *objectNotation, NSString *urlString) {
        NSError* error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectNotation
                                                             options:NSUTF8StringEncoding
                                                               error:&error];
        if (error == nil && [json isKindOfClass:[NSDictionary class]]) {
            AMModelUsers *objSearchResult = [AMModelUsers modelObjectWithDictionary:json];
            if (objSearchResult != nil) {
                if(objSearchResult.status) {
                    for (AMUsers *objUsers in objSearchResult.data.users) {
                        if (![arrayUsers containsObject:objUsers]) {
                            [arrayUsers addObject:objUsers];
                        }
                    }
                    hasmore = objSearchResult.data.hasMore;
                    [collectionView reloadData];
                }
                else {
                    [UtilityClass showError:error];
                }
            }
            else {
                [UtilityClass showError:error];
            }
        }
        else {
            [UtilityClass showError:error];
        }
        [KVNProgress dismiss];
    } withFailedCompletionHandler:^(NSError *error, NSString *urlString) {
        [KVNProgress dismissWithCompletion:^{
            [UtilityClass showError:error];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return arrayUsers.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader ) {
        AMUsers *objUser = (AMUsers *)[arrayUsers objectAtIndex:indexPath.section];
        UICollectionReusableView *objHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                   UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UIImageView *imageUser = [objHeaderView viewWithTag:10001];
        UILabel *userName = [objHeaderView viewWithTag:10002];
        [imageUser sd_setImageWithURL:[NSURL URLWithString:objUser.image] placeholderImage:placeHolderImage];
        imageUser.layer.cornerRadius = imageUser.frame.size.width/2;
        userName.text = objUser.name;
        return objHeaderView;
    }
    return [UICollectionReusableView new];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AMUsers *objUser = (AMUsers *)[arrayUsers objectAtIndex:section];
    return objUser.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMUsers *objUser = (AMUsers *)[arrayUsers objectAtIndex:indexPath.section];
    if (objUser.items.count % 2 == 1) {
        if (indexPath.row == 0) {
            return CGSizeMake(CGRectGetWidth(self.view.frame)-10, (CGRectGetWidth(self.view.frame)-10));
        }
    }
    return CGSizeMake(((CGRectGetWidth(self.view.frame)-10)/2), (CGRectGetWidth(self.view.frame)-10)/2);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    AMUsers *objUser = (AMUsers *)[arrayUsers objectAtIndex:indexPath.section];

    UIImageView *imageView = (UIImageView *)[cell viewWithTag:10000];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[objUser.items objectAtIndex:indexPath.row]] placeholderImage:placeHolderImage];
    return cell;
}

@end
