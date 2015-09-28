//
//  AppDelegate.swift
//  SplitViewShortcut
//
//  Created by rajington on 9/28/15.
//
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var customShortcutView: MASShortcutView!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.level = Int(CGWindowLevelKey.MaximumWindowLevelKey.rawValue)
        
        let icon = NSImage(named: "StatusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        customShortcutView.setAssociatedUserDefaultsKey("shortcut", withTransformerName: NSKeyedUnarchiveFromDataTransformerName)
        MASShortcutBinder.sharedBinder().bindShortcutWithDefaultsKey("shortcut", toAction: splitView)

        let previousLaunched = NSUserDefaults.standardUserDefaults().boolForKey("previousLaunched")
        if !previousLaunched  {
            window.makeKeyAndOrderFront(nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "previousLaunched")
        }
    }
    
    @IBAction func startSplitView(sender: NSMenuItem) {
        splitView()
    }
    
    
    @IBAction func changeShortcut(sender: NSMenuItem) {
        window.makeKeyAndOrderFront(sender)
    }
    
    func splitView(){
        // get app
        let appRef:AXUIElement! = AXUIElementCreateApplication((NSWorkspace.sharedWorkspace().frontmostApplication?.processIdentifier)!).takeRetainedValue()

        // get app's window
        var winRef:AnyObject?
        if AXUIElementCopyAttributeValue(appRef, kAXFocusedWindowAttribute, &winRef) != AXError.Success {return}

        // get window's zoom button
        var zoomRef:AnyObject?
        if AXUIElementCopyAttributeValue(winRef as! AXUIElementRef, kAXZoomButtonAttribute, &zoomRef) != AXError.Success {return}

        // get zoom button's position
        var position:AnyObject?
        if AXUIElementCopyAttributeValue(zoomRef as! AXUIElementRef, kAXPositionAttribute, &position) != AXError.Success {return}

        // get zoom button's position value
        var p = CGPoint()
        if !AXValueGetValue(position as! AXValue, AXValueType(rawValue: kAXValueCGPointType)!, &p) {return}

        // get zoom button's size
        var size:AnyObject?
        if AXUIElementCopyAttributeValue(zoomRef as! AXUIElementRef, kAXSizeAttribute, &size) != AXError.Success {return}

        // get zoom button's size value
        var s = CGPoint()
        if !AXValueGetValue(size as! AXValue, AXValueType(rawValue: kAXValueCGSizeType)!, &s) {return}

        // get zoom button's center
        let bounds:CGRect = CGRectMake(p.x, p.y, s.x, s.y)
        let center:CGPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))

        CGEventPost(CGEventTapLocation.CGHIDEventTap, CGEventCreateMouseEvent(nil, CGEventType.LeftMouseDown, center, CGMouseButton.Left));
        usleep(600000)
        CGEventPost(CGEventTapLocation.CGHIDEventTap, CGEventCreateMouseEvent(nil, CGEventType.LeftMouseUp, center, CGMouseButton.Left));
    }
}

