# Red Vožnje - Novi Sad

## About project

Red Vožnje - Novi Sad is an application which was created with intention to allow citizens of Novi Sad easier access to information about bus schedule, urban and suburan for week days, saturday and sunday. User of app can choose most frequently used lines as well as favourite ones, so that he can see schedule for each one of them, in both directions (or just one direction, depending on selected line). User has an option to rearrange selected lines, to change theme of an application (dark, light), and to select preferred language (Serbian, English). Application is also available in offline mode.

## Screenshots

<img src="https://user-images.githubusercontent.com/48206025/76684931-22592980-6610-11ea-8d36-e420d8abb76a.png" alt="drawing" width="200"/>    <img src="https://user-images.githubusercontent.com/48206025/76684932-26854700-6610-11ea-803f-361948d520c1.png" alt="drawing" width="200"/>    <img src="https://user-images.githubusercontent.com/48206025/76684934-27b67400-6610-11ea-983e-d017643aacbb.png" alt="drawing" width="200"/>    <img src="https://user-images.githubusercontent.com/48206025/76684935-284f0a80-6610-11ea-93a6-44466ef9fe02.png" alt="drawing" width="200"/>

## Framework and technology

For the development of the app we used:

* **Xcode 10.2** - but the app can be built and run in newer versions of Xcode as well
* **Swift 5** programming language
* **MVVM** architecture
* **CocoaPods** - for installing the dependencies in project
* **AsyncDisplayKit** - Texture's framwork that allows us to build smooth and responsive asynchronous interface
* **Alamofire** - Swift-based HTTP networking library which among other features provides chainable request/response methods, JSON parameter and response serialization, authentication


## Current Features
* Preview of schedules of favorite lines for the current hour
* Adding new lines to home screen
* Rearrangement of favorite lines
* Change of language in which the content of the app is shown
* Change of theme in which the content of the app is shown

## Requirements
* Xcode 10.2+
* iOS 11.0+

## Building the code
1. Install Xcode
2. Clone the repository 
`$ git clone https://github.com/Crystal-Pigeon/BusNS-iOS.git`
3. Open a terminal window, and `$ cd` into your project directory
4. Run `$ pod install`
5. Build and run on iPhone or Simulator

## Installation
You can find our app at the [App Store](https://apps.apple.com/us/app/red-vo%C5%BEnje-novi-sad/id1492242145)

