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
    int pageNumber;
}
@property UIView *headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 0;
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
    [self loadDataFromServer];
}

#pragma mark- Load Data From Server
-(void) loadDataFromServer {
    [KVNProgress showWithStatus:@"Loading..."];
    [[AMParser new] connectionRequestForJsonWithURL:[NSString stringWithFormat:@"%d",pageNumber] withJsonDictionary:[NSDictionary new] withSuccessCompletionHandler:^(NSData *objectNotation, NSString *urlString) {
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
                    pageNumber += 10;
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
#pragma mark- UICollectionViewDataSorurce
#pragma mark Number of Sections In Collection View
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return arrayUsers.count;
}

#pragma mark View For Supplementry Element(Header/Footer)
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

#pragma mark Number of Items in Collection View
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AMUsers *objUser = (AMUsers *)[arrayUsers objectAtIndex:section];
    return objUser.items.count;
}

#pragma mark Size of Items in Collection View
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

#pragma mark- UIScrollViewDelegate
#pragma Scrollview Did End Dragging
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        NSLog(@"load more rows");
        if (hasmore) {
            [self loadDataFromServer];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"" message:@"No more data is available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
    }
}
@end
