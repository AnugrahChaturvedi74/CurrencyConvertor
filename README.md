# Currency Converter App

## Overview

The **Currency Converter App** is an iOS application designed to provide users with real-time currency conversion. This app allows users to select a currency, enter an amount, and instantly see the equivalent value in various other currencies. The application is built using Swift and UIKit, featuring a clean, user-friendly interface, with a focus on modular architecture and smooth animations.

## Features

- **Currency Conversion:** Convert any amount from one currency to another using live exchange rates.
- **Lottie Animations:** A Lottie animation is displayed when the collection view is empty, along with a helpful message.
- **Offline Support:** Utilizes `UserDefaults` to store the latest fetched rates, ensuring functionality even when offline.
- **Picker View Integration:** Easily select currencies using a picker view embedded in the text field.

## Technologies Used

- **Swift**: Core programming language.
- **UIKit**: For building the user interface.
- **Lottie**: For rich animations.
- **UserDefaults**: For storing local data.
- **MVVM Architecture**: To maintain a clean separation between business logic and UI code.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/CurrencyConverterApp.git
