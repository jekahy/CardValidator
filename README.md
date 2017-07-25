# CardValidator

This project was an assignment in a job application for an iOS developer position. The task was to implement a credit card input
form (number, expriration date and cvv) with generate and validate functionality. The resulting project had to comply
with the following set of requirements:

* no storyboards and xibs;
* only iPhone version;
* card number validation via [bincodes](https://www.bincodes.com/api-creditcard-checker) service;
* no external networking & card number generation libraries;
* tests;
* networking tasks should not block the UI;
* final application should be ready for deployment (no private APIs etc.);
* target iOS9+;
* use Autolayout.

## Demo

<p align="center"> 
<img src="Images/demo.gif">
</p>

## Installation

In order to run the project you need to either download and unpack zip or clone the repository to your computer. The project uses
[CocoaPods](https://cocoapods.org) to manage dependencies and thus you will have to [install](https://guides.cocoapods.org/using/getting-started.html) their tool before proceeding. Then, having
cocoapods installed you need to open the project directory in the console and run `pod install` command. The latter will download all 
dependencies and create a workspace in the same folder. Done. Now you can open the workspace and run the project.
