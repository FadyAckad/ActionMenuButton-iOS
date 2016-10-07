# ActionMenuButton

A Swift UIButton Subclass that shows menu buttons in a radius around it (Objective-C compatible)

Swift 3.0

XCode 8

Compatible with iOS 8+

![ActionMenuButton](https://raw.githubusercontent.com/FadyAckad/ActionMenuButton-iOS/master/Screenshots/ActionMenuButton.gif "ActionMenuButton GIF")

## Installation

Just drag and drop ActionMenuButton.swift file to your XCode project

## Usage

1. In the interface builder drag and drop a UIButton from the Object Library into your nib or storyboard

    ![ActionMenuButton](https://raw.githubusercontent.com/FadyAckad/ActionMenuButton-iOS/master/Screenshots/Screen%20Shot%202016-10-07%20at%204.23.30%20PM.png "Object Library")

2. Change the button's class to ActionMenuButton in identity inspector

    ![ActionMenuButton](https://raw.githubusercontent.com/FadyAckad/ActionMenuButton-iOS/master/Screenshots/Screen%20Shot%202016-10-07%20at%204.23.45%20PM.png "Identity Inspector")

3. In the button's attributes inspector set the following properties
    
    * Radius to Menu Buttons
    
    * Start Angle (in degrees)
    
    * End Angle (in degrees)
    
    * Animation Duration
    
    ![ActionMenuButton](https://raw.githubusercontent.com/FadyAckad/ActionMenuButton-iOS/master/Screenshots/Screen%20Shot%202016-10-07%20at%204.23.58%20PM.png "Attributes Inspector")

4. Connect an outlet of the view in the file owner

5. Create and add menu buttons
    
    ```swift
    let button = MenuButton(withRadius: 25){ () -> (Void) in
        print("Hello")
    }
    button.setTitle("\(i)", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    actionMenuButton.add(menuButton: MenuButton)
    ```

6. Toggle the menu using

    ```swift
    actionMenuButton.toggleMenu()
    ```

## Notes
The buttons will be arranged on the shorter arc between the two angles unless the start angle is larger than the end angle, the they will be arranged on the longer arc.

### Example

#### With start angle 20 and end angle 160

![ActionMenuButton](https://raw.githubusercontent.com/FadyAckad/ActionMenuButton-iOS/master/Screenshots/Simulator%20Screen%20Shot%20Oct%207%2C%202016%2C%205.26.16%20PM.png "20 to 160")

#### With start angle 160 and end angle 20

![ActionMenuButton](https://raw.githubusercontent.com/FadyAckad/ActionMenuButton-iOS/master/Screenshots/Simulator%20Screen%20Shot%20Oct%207%2C%202016%2C%205.26.47%20PM.png "160 to 20")

## License

ActionMenuButton is released under the [MIT License](http://opensource.org/licenses/MIT)
