//
//  SQLIForecastCollectionViewCell.h
//  testTemplate
//
//  Created by cdebortoli on 28/10/2013.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Forecast, Weather;
@interface SQLIForecastCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UILabel *humidity;
@property (nonatomic, weak) IBOutlet UILabel *maxTemp;
@property (nonatomic, weak) IBOutlet UILabel *minTemp;
@property (nonatomic, weak) IBOutlet UILabel *windSpeed;


@property (nonatomic, weak) IBOutlet UILabel *weatherDescription;
@property (nonatomic, weak) IBOutlet UILabel *weatherMain;
//@property (nonatomic, weak) IBOutlet UIImage *weatherIcon;


@property (nonatomic, strong) Forecast *forecastCell;

-(void)configureCellWithForecast:(Forecast *)forecast;

@end
