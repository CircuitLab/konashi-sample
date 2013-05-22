//
//  ViewController.m
//  konashi-sample
//
//  Created by Daichi Sato on 2013/04/05.
//  Copyright (c) 2013年 Daichi Sato. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"
#import <AudioToolbox/AudioServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [Konashi initialize];
    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [Konashi addObserver:self selector:@selector(input) name:KONASHI_EVENT_UPDATE_PIO_INPUT];
    [Konashi addObserver:self selector:@selector(receiveUart) name:KONASHI_EVENT_UART_RX_COMPLETE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)find:(id)sender {
    NSLog(@"find");
    [Konashi find];
}

- (IBAction)ioFiveOff:(id)sender {
    [Konashi pinMode:PIO5 mode:OUTPUT];
    [Konashi digitalWrite:PIO5 value:LOW];
}

- (IBAction)ioFiveOn:(id)sender {
    [Konashi pinMode:PIO5 mode:OUTPUT];
    [Konashi digitalWrite:PIO5 value:HIGH];
    NSLog(@"on");
}

- (IBAction)pwmChanged:(id)sender {
    
    int ratio = floorf([_pwmSlider value]*100);
    [Konashi pwmMode:LED3 mode:KONASHI_PWM_ENABLE_LED_MODE];
    [Konashi pwmLedDrive:LED3 dutyRatio:ratio];
    _pwmLabel.text = [NSString stringWithFormat:@"%d",ratio];

    NSLog(@"%d",ratio);
}

- (IBAction)aioOutChanged:(id)sender {
    int ratio = [_aioSlider value]*1000;
    _aioLabel.text = [NSString stringWithFormat:@"%dmV", ratio];
    [Konashi analogWrite:AIO0 milliVolt:ratio];
}

- (IBAction)sendUart:(id)sender {
    NSString *message = @"hoge";
    const char *cString = [message UTF8String];
    [Konashi uartWrite:*cString];
}

- (void)ready
{
    [Konashi pinMode:LED2 mode:OUTPUT];
    [Konashi digitalWrite:LED2 value:HIGH];
    [Konashi pinMode:PIO4 mode:INPUT];
    
    [Konashi uartBaudrate:KONASHI_UART_RATE_9K6];
    [Konashi uartMode:KONASHI_UART_ENABLE];
    
}
- (void)input{
    [Konashi pinMode:PIO4 mode:INPUT];
    NSLog(@"[Konashi digitalRead:PIO4]:%d", [Konashi digitalRead:PIO4]);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)receiveUart {
    NSLog(@"UartRx :%c", [Konashi uartRead]);
    _recieveSelialLabel.text =  [NSString stringWithFormat:@"%c", [Konashi uartRead]];
}
@end
