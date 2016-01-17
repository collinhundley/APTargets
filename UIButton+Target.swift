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
    
    // Note: This method must remain internal, rather than private, in order to be called by its own selector.
    internal func performAction(sender: UIButton) {
        if let action = self.action!.function as? () -> Void {
            action()
        } else if let action = self.action!.function as? (sender: UIButton) -> Void {
            action(sender: self)
        }
    }
    
    public func addTarget(forControlEvents: UIControlEvents, action: () -> Void) {
        self.action = Action(function: action)
        self.addTarget(self, action: "performAction:", forControlEvents: forControlEvents)
    }
    
    public func addTarget(forControlEvents: UIControlEvents, actionWithSender: (sender: UIButton) -> Void) {
        self.action = Action(function: actionWithSender)
        self.addTarget(self, action: "performAction:", forControlEvents: forControlEvents)
    }
    
}
