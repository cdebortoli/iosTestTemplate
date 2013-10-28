//
//  SQLIForecastCollectionViewCell.m
//  testTemplate
//
//  Created by cdebortoli on 28/10/2013.
//  Copyright (c) 2013 sqli. All rights reserved.
//

#import "SQLIForecastCollectionViewCell.h"
#import "Forecast.h"
#import "Weather.h"

@implementation SQLIForecastCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void)configureCellWithForecast:(Forecast *)forecast;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];

    // Accessibility for view testing
    self.forecastCell = forecast;
    self.accessibilityLabel = [formatter stringFromDate:forecast.date];
    self.isAccessibilityElement = YES;
    
    
    self.date.text = [formatter stringFromDate:forecast.date];
    self.humidity.text = [NSString stringWithFormat:@"%@", forecast.humidity];
    self.minTemp.text = [NSString stringWithFormat:@"%@", forecast.minTemp];
    self.maxTemp.text = [NSString stringWithFormat:@"%@", forecast.maxTemp];
    self.windSpeed.text = [NSString stringWithFormat:@"%@", forecast.windSpeed];
    
    self.weatherMain.text = forecast.weather.main;
    self.weatherDescription.text = forecast.weather.weatherDescription;
}

@end
