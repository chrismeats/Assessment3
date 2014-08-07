//
//  MMViewController.m
//  Assessment3_ObjectiveC
//
//  Created by Kevin McQuown on 8/5/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MMViewController.h"
#import "MMDivvyStation.h"
#import "MMMapViewController.h"

#define urlToRetrieveDivvyData @"http://www.divvybikes.com/stations/json/"

@interface MMViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MMViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.divvyStationsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"divvyCell"];

    NSDictionary *divvyStation = self.divvyStationsList[indexPath.row];

    cell.textLabel.text = divvyStation[@"stationName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Address: %@ #Bikes: %@", divvyStation[@"stAddress1"], divvyStation[@"availableBikes"]];

    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
    MMMapViewController *dvc = segue.destinationViewController;
    MMDivvyStation *station = [[MMDivvyStation alloc] initWithDictionary:self.divvyStationsList[indexPath.row]];
    dvc.station = station;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Divvy Bike Locator";
    [self doApi];
}

-(void)doApi
{
    NSURL *url = [NSURL URLWithString:@"http://www.divvybikes.com/stations/json/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.divvyStationsList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"stationBeanList"];

        [self.myTableView reloadData];
    }];
}


@end
