//
//  UIControl+Target.swift
//  Created by Collin Hundley on 1/16/16
//

// Useful code snippet for Xcode autocompletion:
// addTarget(<#UIControlEvents#>) {[unowned self] in self.<#method#>}


import UIKit

public extension UIControl {
    
    /// The registry contains a weak reference to all UIControl objects that have been given targets, the events to observe, and the closures to execute when the events are triggered.
    private static var actionRegistry = [Action]()
    
    // MARK: Public methods
    
    /// Adds a target to the receiv er for the given event, which triggers the given action.
    public func addTarget(forControlEvents: UIControlEvents, action: () -> Void) {
        self.addTarget(forEvent: forControlEvents, action: action)
    }
    
    // MARK: Private methods
    
    /// A wrapper used to maintain a weak reference to a UIControl, an event to observe, and a function to call.
    private class Action: AnyObject {
        weak var object: UIControl?
        var event: UIControlEvents
        var function: Any
        init(object: UIControl, event: UIControlEvents, function: () -> Void) {
            self.object = object
            self.event = event
            self.function = function
        }
        init(object: UIControl, event: UIControlEvents, function: (sender: UIControl) -> Void) {
            self.object = object
            self.event = event
            self.function = function
        }
    }
    
    /// Adds the target to the actual object and adds the action to the registry.
    private func addTarget(forEvent event: UIControlEvents, action: () -> Void) {
        var actionString: Selector!
        switch event {
            
            // Touch events
            
        case UIControlEvents.TouchDown:
            actionString = "touchDown:"
        case UIControlEvents.TouchDownRepeat:
            actionString = "touchDownRepeat:"
        case UIControlEvents.TouchDragInside:
            actionString = "touchDragInside:"
        case UIControlEvents.TouchDragOutside:
            actionString = "touchDragOutside:"
        case UIControlEvents.TouchDragEnter:
            actionString = "touchDragEnter:"
        case UIControlEvents.TouchDragExit:
            actionString = "touchDragExit:"
        case UIControlEvents.TouchUpInside:
            actionString = "touchUpInside:"
        case UIControlEvents.TouchUpOutside:
            actionString = "touchUpOutside:"
        case UIControlEvents.TouchCancel:
            actionString = "touchCancel:"
            
            // UISlider events
            
        case UIControlEvents.ValueChanged:
            actionString = "valueChanged:"
            
            // tvOS button events
            
        case UIControlEvents.PrimaryActionTriggered:
            actionString = "primaryActionTriggered:"
            
            // UITextField events
            
        case UIControlEvents.EditingDidBegin:
            actionString = "editingDidBegin:"
        case UIControlEvents.EditingChanged:
            actionString = "editingChanged:"
        case UIControlEvents.EditingDidEnd:
            actionString = "editingDidEnd:"
        case UIControlEvents.EditingDidEndOnExit:
            actionString = "editingDidEndOnExit:"
            
            // Other events
            
        case UIControlEvents.AllTouchEvents:
            actionString = "allTouchEvents:"
        case UIControlEvents.AllEditingEvents:
            actionString = "allEditingEvents:"
        case UIControlEvents.ApplicationReserved:
            actionString = "applicationReserved:"
        case UIControlEvents.SystemReserved:
            actionString = "systemReserved:"
        case UIControlEvents.AllEvents:
            actionString = "allEvents:"
            
        default: // Unrecognized event
            break
        }
        
        // Add the Objective-C target
        self.addTarget(self, action: actionString, forControlEvents: event)
        
        // Register action
        UIControl.registerAction(Action(object: self, event: event, function: action))
    }
    
    /// Adds an action to the registry.
    private static func registerAction(action: Action) {
        self.cleanRegistry()
        // Add action to the registry
        self.actionRegistry.append(action)
    }
    
    /// Triggers the actions for the correct control events.
    private func triggerAction(forObject: UIControl, event: UIControlEvents) {
        for action in UIControl.actionRegistry {
            if action.object == forObject && action.event == event {
                if let function = action.function as? () -> Void {
                    function()
                } else if let function = action.function as? (sender: UIControl) -> Void {
                    function(sender: forObject)
                }
            }
        }
        UIControl.cleanRegistry()
    }
    
    /// Cleans the registry, removing any actions whose object has already been released.
    /// This guarantees that no memory leaks will occur over time.
    private static func cleanRegistry() {
        UIControl.actionRegistry = UIControl.actionRegistry.filter({ $0.object != nil })
    }
    
    
    // MARK: Targets given to the Objective-C selectors
    
    @objc private func touchDown(sender: UIControl) {
        triggerAction(sender, event: .TouchDown)
    }
    @objc private func touchDownRepeat(sender: UIControl) {
        triggerAction(sender, event: .TouchDownRepeat)
    }
    @objc private func touchDragInside(sender: UIControl) {
        triggerAction(sender, event: .TouchDragInside)
    }
    @objc private func touchDragOutside(sender: UIControl) {
        triggerAction(sender, event: .TouchDragOutside)
    }
    @objc private func touchDragEnter(sender: UIControl) {
        triggerAction(sender, event: .TouchDragEnter)
    }
    @objc private func touchDragExit(sender: UIControl) {
        triggerAction(sender, event: .TouchDragExit)
    }
    @objc private func touchUpInside(sender: UIControl) {
        triggerAction(sender, event: .TouchUpInside)
    }
    @objc private func touchUpOutside(sender: UIControl) {
        triggerAction(sender, event: .TouchUpOutside)
    }
    @objc private func touchCancel(sender: UIControl) {
        triggerAction(sender, event: .TouchCancel)
    }
    @objc private func valueChanged(sender: UIControl) {
        triggerAction(sender, event: .ValueChanged)
    }
    @objc private func primaryActionTriggered(sender: UIControl) {
        triggerAction(sender, event: .PrimaryActionTriggered)
    }
    @objc private func editingDidBegin(sender: UIControl) {
        triggerAction(sender, event: .EditingDidBegin)
    }
    @objc private func editingChanged(sender: UIControl) {
        triggerAction(sender, event: .EditingChanged)
    }
    @objc private func editingDidEnd(sender: UIControl) {
        triggerAction(sender, event: .EditingDidEnd)
    }
    @objc private func editingDidEndOnExit(sender: UIControl) {
        triggerAction(sender, event: .EditingDidEndOnExit)
    }
    @objc private func allTouchEvents(sender: UIControl) {
        triggerAction(sender, event: .AllTouchEvents)
    }
    @objc private func allEditingEvents(sender: UIControl) {
        triggerAction(sender, event: .AllEditingEvents)
    }
    @objc private func applicationReserved(sender: UIControl) {
        triggerAction(sender, event: .ApplicationReserved)
    }
    @objc private func systemReserved(sender: UIControl) {
        triggerAction(sender, event: .SystemReserved)
    }
    @objc private func allEvents(sender: UIControl) {
        triggerAction(sender, event: .AllEvents)
    }
    
}
