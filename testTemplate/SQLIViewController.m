//
//  SQLIViewController.m
//  testTemplate
//
//  Created by cdebortoli on 18/10/13.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import "SQLIViewController.h"
#import "City.h"
#import "SQLIDatabaseAccess.h"
#import "SQLIForecastService.h"
#import "SQLIForecastCollectionViewCell.h"

@interface SQLIViewController ()

@end

@implementation SQLIViewController
{
    NSMutableArray *forecastDatasource;
    City *selectedCity;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.loadingView setHidden:YES];
    
    // Webservice notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webserviceReceiveCityForecast:) name:@"SQLIWebserviceForecastReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webserviceReceiveError:) name:@"SQLIWebserviceForecastError" object:nil];
    
    // Collectionview
    forecastDatasource = [[NSMutableArray alloc]init];
    selectedCity = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)changeCitySegmentController:(id)sender
{
    if (((UISegmentedControl *)sender).selectedSegmentIndex == 0)
    {
        selectedCity = [[SQLIDatabaseAccess sharedInstance] getCityWithName:@"Paris"];
    }
    else if (((UISegmentedControl *)sender).selectedSegmentIndex == 1)
    {
        selectedCity = [[SQLIDatabaseAccess sharedInstance] getCityWithName:@"London"];
    }
    else if (((UISegmentedControl *)sender).selectedSegmentIndex == 2)
    {
        selectedCity = [[SQLIDatabaseAccess sharedInstance] getCityWithName:@"Moscow"];
    }
    
    [self getCityForecast:selectedCity];
}


#pragma mark - Loading view

- (void)startLoading
{
    [self.loadingView setHidden:NO];
    [self.loadingIndicator startAnimating];
}

- (void)stopLoading
{
    [self.loadingView setHidden:YES];
    [self.loadingIndicator stopAnimating];
}


#pragma mark - Webservice

- (void)getCityForecast:(City *)city
{
    [self performSelectorOnMainThread:@selector(startLoading) withObject:nil waitUntilDone:NO];
    [[SQLIForecastService sharedInstance]getForecastForCity:city];
}

- (void)webserviceReceiveCityForecast:(NSNotification *)notif
{
    [forecastDatasource setArray:[[SQLIDatabaseAccess sharedInstance] getForecastDataForCity:selectedCity]];
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:NO];
    [self.forecastCollectionView reloadData];
}

- (void)webserviceReceiveError:(NSNotification *)notif
{
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:NO];
    UIAlertView *wsError = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Can't download the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [wsError show];
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [forecastDatasource count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SQLIForecastCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SQLIForecastCell" forIndexPath:indexPath];
    
    Forecast *forecast = [forecastDatasource objectAtIndex:indexPath.row];
    [cell configureCellWithForecast:forecast];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate





@end
