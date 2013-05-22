//
//  ViewController.h
//  konashi-sample
//
//  Created by Daichi Sato on 2013/04/05.
//  Copyright (c) 2013年 Daichi Sato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ioFiveOffBtn;
@property (weak, nonatomic) IBOutlet UIButton *ioFiveOnBtn;
@property (weak, nonatomic) IBOutlet UILabel *pwmLabel;
@property (weak, nonatomic) IBOutlet UISlider *pwmSlider;
@property (weak, nonatomic) IBOutlet UISlider *aioSlider;
@property (weak, nonatomic) IBOutlet UILabel *aioLabel;
@property (weak, nonatomic) IBOutlet UITextField *uartTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendUartBtn;

@property (weak, nonatomic) IBOutlet UILabel *recieveSelialLabel;
@property (weak, nonatomic) IBOutlet UISwitch *io4Switch;

@property (weak, nonatomic) IBOutlet UISwitch *io5Switch;


- (IBAction)find:(id)sender;
- (IBAction)ioFiveOff:(id)sender;
- (IBAction)ioFiveOn:(id)sender;
- (IBAction)pwmChanged:(id)sender;
- (IBAction)aioOutChanged:(id)sender;
- (IBAction)sendUart:(id)sender;
- (IBAction)io4Change:(id)sender;
- (IBAction)io5Change:(id)sender;



@end
