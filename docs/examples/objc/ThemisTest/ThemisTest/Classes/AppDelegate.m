/*
* Copyright (c) 2015 Cossack Labs Limited
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#import "AppDelegate.h"
#import "smessage.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self testingThemis];

    return YES;
}


- (void)testingThemis {
    NSData * serverPrivateKey = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"server"
                                                                                                               ofType:@"priv"]];
    NSData * serverPublicKey = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"server"
                                                                                                              ofType:@"pub"]];
    NSData * clientPrivateKey = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"client"
                                                                                                               ofType:@"priv"]];
    NSData * clientPublicKey = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:@"client"
                                                                                                              ofType:@"pub"]];

    SMessage * encrypter = [[SMessage alloc] initWithPrivateKey:clientPrivateKey peerPublicKey:serverPublicKey];
    SMessage * decrypter = [[SMessage alloc] initWithPrivateKey:serverPrivateKey peerPublicKey:clientPublicKey];

    NSString * testMessage = @"jgjmg mgjg y gj";

    NSError * themisError;
    NSData * encryptedMessage = [encrypter wrap:[testMessage dataUsingEncoding:NSUTF8StringEncoding]
                                           error:&themisError];
    if (themisError) {
        NSLog(@"Error occured %@", themisError);
        return;
    }
    NSLog(@"%@", encryptedMessage);
    NSData * decryptedMessage = [decrypter unwrap:encryptedMessage error:&themisError];
    if (themisError) {
        NSLog(@"Error occured %@", themisError);
        return;
    }

    NSString * resultString = [[NSString alloc] initWithData:decryptedMessage encoding:NSUTF8StringEncoding];
    NSLog(@"%@", resultString);
}


@end
