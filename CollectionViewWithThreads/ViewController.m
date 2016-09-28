//
//  ViewController.m
//  CollectionViewWithThreads
//
//  Created by Priyanka Naidu on 29/07/16.
//  Copyright © 2016 Priyanka Naidu. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *array1;
    NSMutableArray *arr;
    NSOperationQueue *opQueue;
    dispatch_queue_t theQueue;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    array1=@[@"http://www.gstatic.com/tv/thumb/movieposters/11319046/p11319046_p_v8_af.jpg",
             @"http://t2.gstatic.com/images?q=tbn:ANd9GcQJHE0wTHT_pNRdZlnJj5IkzF49uMF3be1gfIIKw8A8z_3oHVRO",
             @"http://t3.gstatic.com/images?q=tbn:ANd9GcQu6t289OZIOlPWU_AkeaL-3-kb2AywKUACnXSer1g_-pcpi0mi",
             @"http://t1.gstatic.com/images?q=tbn:ANd9GcTPxyoxzLf33_chM3uqooaT3tiyEBbQmqJb0Ndbvpt6qfQ4ybIk",
             @"http://t1.gstatic.com/images?q=tbn:ANd9GcS61fdKkVcQIKtObjNGAELqVwyzhwFoIfNGZVbC-rqta12xBfLa",
             @"http://static1.squarespace.com/static/53323bb4e4b0cebc6a28ffa2/t/573fe299f8baf3f38def74ec/1463804606303/Star+Trek+Beyond+Poster?format=2500w",
             @"http://t1.gstatic.com/images?q=tbn:ANd9GcR-fLY3Z9Vn28UB-A3X_w0vjmkHcXG89HWwul5w6-sg3IonPXA_",
             @"http://t3.gstatic.com/images?q=tbn:ANd9GcTOUtd-BQZW_VT8WrTaVzqfiV6YVC3tFxmKZwl0MFKLnb51xqtl",
             @"http://t3.gstatic.com/images?q=tbn:ANd9GcSzuVQG3TM2qBowu0zpLYhwaHdoNfG-m4Gca11-xx3d8wtSD6A-",
             @"http://t1.gstatic.com/images?q=tbn:ANd9GcSGT7ibrynE3qOCfdU9N4tcyuKoVHE7CR_Xrgse14AbDECJpYFA"];
    
     theQueue = dispatch_queue_create("theQueueName", DISPATCH_QUEUE_CONCURRENT);
    
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return array1.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imgView.image=[UIImage imageWithData:[arr objectAtIndex:indexPath.row]];
    return cell;
}


- (IBAction)btn_Click:(id)sender {
 
  
    /*
     *****************   using threads  **********************
     
    arr=[NSMutableArray arrayWithArray:array1];
     NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:arr];
    [thread start];
    [self performSelectorInBackground:@selector(downloadImage:) withObject:arr];
    
     ***********************************************************/
    
   
    /*
     
     ******************* using ns operations ****************
    
    opQueue = [[NSOperationQueue alloc] init];
    opQueue.maxConcurrentOperationCount = 1;
    arr=[NSMutableArray arrayWithArray:array1];
    
    NSInvocationOperation *iOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageOperation:) object:arr];
    [opQueue addOperation:iOp];
    
    ***********************************************************/
    
    
    /**************** using  dispatch Queue ***************/
    
    arr=[NSMutableArray arrayWithArray:array1];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    dispatch_async(theQueue, ^{
        
        for(NSString *url in arr)
        {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            [array addObject:data];
        }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    arr=[NSMutableArray arrayWithArray:array];
                    [self.collectionView reloadData];
                });
                
            });

}

/*********************  using threads  ***************************

-(void) downloadImage:(NSArray *) arr1 {
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(NSString *urlString in arr1)
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [array addObject:data];
    }
    
    NSThread *mainThread = [[NSThread mainThread] initWithTarget:self selector:@selector(displayImages:) object:array];
    [mainThread start];
    
    [self performSelectorOnMainThread:@selector(displayImages:) withObject:array waitUntilDone:NO];
   
}

-(void) displayImages:(NSArray *) dataArray {
    
    arr=[NSMutableArray arrayWithArray:dataArray];
    [self.collectionView reloadData];
    
}
 
 *****************************************************************/

/************* using nsoperations ************************


-(void) downloadImageOperation:(NSArray *) arr1 {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(NSString *theUrl in arr1)
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:theUrl]];
        [array addObject:data];
    }
    NSInvocationOperation *invo = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(displayOpImage:) object:array];
    
    [[NSOperationQueue mainQueue] addOperation:invo];
}

-(void)displayOpImage:(NSArray *) data{
    arr=[NSMutableArray arrayWithArray:data];
    [self.collectionView reloadData];
}

 *********************************************************/

@end
