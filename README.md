# APTargets

If you've ever seen this error...

`-[MyProject.ViewController buttonTapped]: unrecognized selector sent to instance 0x7f9b42d48ae0`

...then congratulations, you're an iOS developer.

We all hate selectors, and now you can eliminate them for good.

## Usage

##### UIControl+Target.swift

After importing `UIControl+Target.swift` into your project, you'll have a new method exposed for adding targets:

`addTarget(forControlEvents: UIControlEvents, action: () -> Void)`
    
This method allows you to add a target to any `UIControl` (such as a `UIButton`), and define the closure in-place. With Xcode's auto formatting, this is what your target might look like:

```
myButton.addTarget(.TouchUpInside) { () -> Void in
    print("This gets called when I tap the button!")
}
```

But of course, this is Swift and we can lose the `() -> Void in` for a much cleaner version:

```
myButton.addTarget(.TouchUpInside) {
    print("This gets called when I tap the button!")
}
```

**Important note:** Just like all closures in Swift, you must be careful not to create [reference cycles](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html).

> How could this create a reference cycle?

Suppose we have a `UIViewController` which owns a `UIButton` (a common scenario). The following code would create a reference cycle, causing the view controller to remain in memory after its dismissal:

```
override func viewDidLoad() {
    myButton.addTarget(.TouchUpInside) {
        print("This gets called when I tap the button!")
        self.counter += 1
    }
}
```

Referencing `self` (the view controller), or *any property or method of `self`*, within the closure will cause a reference cycle to occur.
    
#### How to prevent reference cycles

Luckily, this is very easy to avoid. If you need to access a `UIControl's` parent within the the target, you can simply make the parent `unowned`:

```
myButton.addTarget(.TouchUpInside) {[unowned self]() in
    print("This gets called when I tap the button!")
    self.counter += 1
}
```

That's not so bad, right? But there's an even better way:

```
myButton.addTarget(.TouchUpInside) {[unowned self] in self.buttonTapped()}
```

Where somewhere you've defined the function:

```
func buttonTapped() {
    print("This gets called when I tap the button!")
    self.counter += 1
}
```

This method is preferable because it avoids defining large blocks of code within the `viewDidLoad` method in your view controller.

#### Useful code snippet

Sometimes we get lazy, so here's a code snippet that you can install in Xcode for perfect autocompletion every time:

`addTarget(<#UIControlEvents#>) {[unowned self] in self.<#method#>}`

#### Returning `sender`

With `UIControls`, you often need the control itself to be returned as `sender` to your target method. Just like with standard selectors, this is also supported with APTargets:

```
myButton.addTarget(.TouchUpInside) {[unowned self] in self.printTitle(self.myButton)}
```

Where your method accepts the button as a parameter:

```
func printTitle(sender: UIButton) {
    print(sender.titleLabel?.title)
}
```

The caveat is that you must explicitly define `sender` (in this case, the button) while adding the target. Still a lot better than the old-fashioned way!


#### Advantages

Using APTargets, you no longer need to pass strings as selectors to `UIControl` targets.

> Why is that so great?

No more uncaught typos, no more mismatched function names, and *finally* proper compiler checks! You'll never see this error ever again:

`unrecognized selector sent to instance...`

Give it a shot - you'll never go back!
