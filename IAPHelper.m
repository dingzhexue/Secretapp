//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "IAPHelper.h"
#import "AppDelegate.h"

@implementation IAPHelper
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;

AppDelegate *app;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        // Check for previously purchased products
        NSMutableSet * purchasedProducts = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased)
            {
                [purchasedProducts addObject:productIdentifier];
                //[app.Purchase_array addObject:productIdentifier];
                //  NSLog(@"Previously purchased: %@", productIdentifier);
                //NSLog(@"Purchase_array %@", app.Purchase_array);
            }
            else {
                //  NSLog(@"Previously not purchased: %@", productIdentifier);
                
                
            }
            //            NSLog(@"Previously purchased: %@", productIdentifier);
            //  [app.ProductListArray addObject:productIdentifier];
            //            NSLog(@"app.ProductListArray>>>>%@",app.ProductListArray);
        }
        self.purchasedProducts = purchasedProducts;
        
    }
    return self;
}

- (void)requestProducts {
    
    self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
    _request.delegate = self;
    [_request start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Received products results...");
    self.products = response.products;
    self.request = nil;
    NSLog(@"%@",response.products);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
    // TODO: Record the transaction on the server side...
}

- (void)provideContent:(NSString *)productIdentifier {
    
    NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction...");
    if([app.buyProduct isEqualToString:@"Buy Remove Ads In-App Purchase"])
    {
        [GlobalFunctions setStringValueToUserDefaults:@"YES" ForKey:@"AdPackagePurchased"];
        NSLog(@"%@",[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"]);

    }
    else if([app.buyProduct isEqualToString:@"Buy Break-In Attempts In-App Purchase"])
    {
        [GlobalFunctions setStringValueToUserDefaults:@"YES" ForKey:@"BreakInPackagePurchased"];
        NSLog(@"%@",[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"BreakInPackagePurchased"]);
        
        [GlobalFunctions setStringValueToUserDefaults:@"YES" ForKey:@"AdPackagePurchased"];
        NSLog(@"%@",[GlobalFunctions getStringValueFromUserDefaults_ForKey:@"AdPackagePurchased"]);
    }
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier {
    
    NSLog(@"Buying %@...", productIdentifier);
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)dealloc
{
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}

@end
