//
//  TabBarController.m
//  TODO-OBJ-C
//
//  Created by Soha Elgaly on 25/09/2025.
//

#import "TabBarController.h"
#import "EditVC.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addButtonClicked:(UIBarButtonItem *)sender {
    
    EditVC *destVc =  [self.storyboard instantiateViewControllerWithIdentifier:@"EditVC"];
   
    [self.navigationController pushViewController:destVc animated:true];
}

@end
