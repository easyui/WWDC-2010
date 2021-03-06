/*
     File: PaymentPickerViewController.m
 Abstract: Displays a picker containing a list of payment frequencies and a table view showing the resulting number and amount of payments.
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "PaymentPickerViewController.h"

static NSArray * __paymentFrequencies = nil;

@implementation PaymentPickerViewController
@synthesize numberPicker, loan, tableView=_tableView;

+ (void)initialize{
    __paymentFrequencies = [[NSArray arrayWithObjects:@"Daily", @"Every 3 days", @"Weekly", @"Every 2 weeks", @"Monthly", @"Every 3 Months", @"Every 6 Months", @"Yearly", nil] retain];
}

+ (NSArray *)paymentFrequencies {
    return __paymentFrequencies;
}

- (void)viewDidLoad {
    [numberPicker selectRow:[self.loan.paymentFrequency intValue] inComponent:0 animated:NO];
}

- (NSString *) paymentString {
    NSString * paymentString = nil;
    int expectedNumberOfPayments = [self.loan expectedNumberOfPayments];
    NSString * paymentAmount = [self.loan paymentAmountForNumberOfPayments:expectedNumberOfPayments];
    NSString * lastPaymentAmount = [self.loan lastPaymentAmountForNumberOfPayments:expectedNumberOfPayments];
    NSUInteger paymentCount = expectedNumberOfPayments;
    NSString * formatString = (paymentCount == 1) ? @"%@ payment of %@" : @"%@ payments of %@";
    
    
    if (lastPaymentAmount) {
        NSString * formatString1 = @"%@ @ %@";
        formatString = [NSString stringWithFormat:@"%@ and %@", formatString1, formatString1];
        
        NSNumber * numberOfPayments = [NSNumber numberWithInt:paymentCount - 1];
        
        paymentString = [NSString stringWithFormat:formatString, [numberOfPayments stringValue], paymentAmount, @"1", lastPaymentAmount];
    }
    else {
        NSNumber * numberOfPayments = [NSNumber numberWithInt:paymentCount];
        paymentString = [NSString stringWithFormat:formatString, [numberOfPayments stringValue], paymentAmount];
    }
    return paymentString;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self paymentString];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 78.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 78.0;
}

#pragma mark -
#pragma mark UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[[self class] paymentFrequencies] count];
}

#pragma mark -
#pragma mark UIPickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[[self class] paymentFrequencies] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.loan.paymentFrequency = [NSNumber numberWithInt:row];
    [self.tableView reloadData];
}


- (void)dealloc {
    [loan release];
    [super dealloc];
}


@end
