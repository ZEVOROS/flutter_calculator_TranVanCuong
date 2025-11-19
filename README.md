# Flutter Calculator App

A simple and responsive calculator app built with **Flutter**. This app supports basic arithmetic operations, percentage, change sign, and a history display for past calculations.

---

## Features

- Basic arithmetic operations: **Addition (+), Subtraction (-), Multiplication (×), Division (÷)**
- Percentage calculation (%)
- Change sign (±)
- Clear display (`C`) and delete last character (`CE`)
- Continuous calculations without resetting
- Calculation history display
- Responsive UI that scales to different screen sizes
- Error handling for invalid operations (e.g., division by zero)

---

## Screenshots

| Calculator Display | Button Panel |
|-------------------|--------------|
| ![Calculator Display](screenshots/display.png) | ![Button Panel](screenshots/buttons.png) |

*Note: Add your own screenshots in the `screenshots` folder.*

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0
- Dart >= 3.0
- Android Studio or VS Code (recommended)
- Device or emulator to run the app

### Installation

1. Clone the repository:
git clone https://github.com/your-username/flutter_calculator.git
cd flutter_calculator
Get dependencies:

flutter pub get
Run the app:


flutter run
Usage
Tap numeric buttons to input numbers.

Tap operation buttons (+, -, ×, ÷) to perform calculations.

Tap = to get the result.

Use C to clear all, CE to delete the last input.

Tap ± to change the sign of the current number.

Tap % to convert the current number to a percentage.

Past calculations are displayed in the history section.

Folder Structure

flutter_calculator/
│
├─ lib/
│  └─ main.dart          # Main app code
├─ assets/
│  └─ fonts/             # Custom fonts (Roboto)
├─ screenshots/          # Screenshots for README
├─ pubspec.yaml          # Flutter project configuration
└─ README.md
Customization
Theme colors can be changed in main.dart under ThemeData.

Font family can be modified by changing fontFamily in ThemeData.

Button styles and colors are customizable via the buildButton() method.
