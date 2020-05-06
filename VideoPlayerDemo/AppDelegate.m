//
//  AppDelegate.m
//  VideoPlayerDemo
//
//  Created by Водолазкий В.В. on 06.05.2020.
//  Copyright © 2020 Водолазкий В.В. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface AppDelegate ()
{
    AVPlayer *player;
    BOOL loopPlayer;
}
@property (weak) IBOutlet AVPlayerView *playerView;
@property (weak) IBOutlet NSButton *loopCheckbox;
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *stopButton;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    // init buttons state
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    self.loopCheckbox.state = NSControlStateValueOff;
    loopPlayer = NO;

    // set up player
    NSBundle *mb = [NSBundle mainBundle];
    NSURL *demoURL = [mb URLForResource:@"demo" withExtension:@"mp4"];
    if (demoURL) {
        player = [[AVPlayer alloc] initWithURL:demoURL];
        self.playerView.player = player;
    } else {
        NSLog(@"Cannot open demo.mp4!!!");
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(movieEndDetected:)
               name:@"AVPlayerItemDidPlayToEndTimeNotification"
             object:player.currentItem];
 }


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)startButtonClicked:(id)sender
{
    self.startButton.enabled = NO;
    self.stopButton.enabled = YES;
    [player play];
}

- (IBAction)stopButtonClicked:(id)sender
{
    self.startButton.enabled = YES;
    self.stopButton.enabled = NO;
    [player pause];
    [player seekToTime:kCMTimeZero];
}

- (IBAction)loopCheckBoxChanged:(id)sender
{
    loopPlayer = (self.loopCheckbox.state == NSControlStateValueOn);
}

- (void) movieEndDetected:(NSNotification *) note
{
    if (loopPlayer) {
        [player seekToTime:kCMTimeZero];
        [player play];
    } else {
        [self stopButtonClicked:nil];
    }
}

@end
