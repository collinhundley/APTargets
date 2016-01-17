//
//  UIButton+Target.swift
//  Created by Collin Hundley on 1/16/16
//

import UIKit

public extension UIButton {
    
    private static var actionsAssocKey: UInt8 = 0
    
    private class Action: AnyObject {
        private var function: Any
        init(function: () -> Void) {
            self.function = function
        }
        init(function: (sender: UIButton) -> Void) {
            self.function = function
        }
    }
    
    private var action: Action? {
        get {
            return objc_getAssociatedObject(self, &UIButton.actionsAssocKey) as? Action
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIButton.actionsAssocKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// The actual internal target given to the objective-c selector.
    @objc private func performAction(sender: UIButton) {
        if let action = self.action!.function as? () -> Void {
            action()
        } else if let action = self.action!.function as? (sender: UIButton) -> Void {
            action(sender: self)
        }
    }
    
    /// Adds a target to the receiver for the given event, which triggers the given action.
    public func addTarget(forControlEvents: UIControlEvents, action: () -> Void) {
        self.action = Action(function: action)
        self.addTarget(self, action: "performAction:", forControlEvents: forControlEvents)
    }
    
    /// Adds a target to the receiver for the given event, which triggers the given action.
    /// When the action is triggered, the button is passed back as a parameter.
    public func addTarget(forControlEvents: UIControlEvents, actionWithSender: (sender: UIButton) -> Void) {
        self.action = Action(function: actionWithSender)
        self.addTarget(self, action: "performAction:", forControlEvents: forControlEvents)
    }
    
}
