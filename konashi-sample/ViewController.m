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

- (NSString *) sendMail;
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

- (IBAction)io4Change:(id)sender {
    BOOL flag = _io4Switch.on;
    if (flag) {
        [Konashi pinMode:PIO4 mode:OUTPUT];
        [Konashi digitalWrite:PIO4 value:HIGH];
    }else{
        [Konashi pinMode:PIO4 mode:OUTPUT];
        [Konashi digitalWrite:PIO4 value:LOW];
    }
}

- (IBAction)io5Change:(id)sender {
    BOOL flag = _io5Switch.on;
    if (flag) {
        [Konashi pinMode:PIO5 mode:OUTPUT];
        [Konashi digitalWrite:PIO5 value:HIGH];
    }else{
        [Konashi pinMode:PIO5 mode:OUTPUT];
        [Konashi digitalWrite:PIO5 value:LOW];
    }
}

- (void)ready
{
    [Konashi pinMode:LED2 mode:OUTPUT];
    [Konashi digitalWrite:LED2 value:HIGH];
    [Konashi pinMode:PIO3 mode:INPUT];
    
    [Konashi uartBaudrate:KONASHI_UART_RATE_9K6];
    [Konashi uartMode:KONASHI_UART_ENABLE];
    
}
- (void)input{
    [Konashi pinMode:PIO3 mode:INPUT];
    NSLog(@"[Konashi digitalRead:PIO3]:%d", [Konashi digitalRead:PIO3]);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self sendMail];
}

- (void)receiveUart {
    NSLog(@"UartRx :%c", [Konashi uartRead]);
    _recieveSelialLabel.text =  [NSString stringWithFormat:@"%c", [Konashi uartRead]];
}

- (NSString *) sendMail{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:@"http://ec2-46-51-238-190.ap-northeast-1.compute.amazonaws.com:3000/mail"]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
//        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

@end
