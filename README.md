# APButtonExtensions

Useful utilities for UIButtons.

## Contents

##### UIButton+Target.swift

If you've ever seen this error...

`-[MyProject.ViewController buttonTapped]: unrecognized selector sent to instance 0x7f9b42d48ae0`

...then congratulations, you're an iOS developer.

We all hate selectors, and now you can eliminate them for good. Here's how you normally add targets to buttons:

```
myButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
```

And here's how you do it with this `UIButton` extension:

```
myButton.addTarget(.TouchUpInside, action: buttonTapped)
```

**How to use it:**

After importing `UIButton+Target.swift` into your project, you'll have two new methods exposed for adding targets to buttons:

- addTarget(forControlEvents: UIControlEvents, action: () -> Void)
    
    Allows you to add a target to a button, passing only a function name for the `action` parameter. Example:

    ```
    myButton.addTarget(.TouchUpInside, action: buttonTapped)
    ```
    
    Where somewhere you've defined the function:
    
    ```
    func buttonTapped() {
        // Do things here
    }
    ```
    
    Alternatively, you can define the closure in-place using Xcode's autocompletion:
    
    ```
    myButton.addTarget(.TouchUpInside) { () -> Void in
      // Do things here
    }
    ```
    
    Or preferably, the shorthand version:
    
    ```
    myButton.addTarget(.TouchUpInside) {
      // Do things here
    }
    ```

- addTarget(forControlEvents: UIControlEvents, actionWithSender: (sender: UIButton) -> Void)
  
    This works the same way as the above method, but acccepts a closure with the button passed back as a parameter (the equivalent to appending a colon to a selector):
  
    ```
    myButton.addTarget(.TouchUpInside, actionWithSender: buttonTapped)
    ```
    
    Where you've defined the function as:
    
    ```
    func buttonTapped(sender: UIButton) {
      // Do things here
    }
    ```
    
    Or similarly, you can define the closure in-place:
    
    ```
    myButton.addTarget(.TouchUpInside) { (sender) -> Void in
      // Do things here
    }
    ```

