# NY Times Bestseller App

The NY Times Bestseller App is a sample iOS application that showcases the implementation of the same functionality using both UIKit and SwiftUI. The UIKit version employs the MVP architecture, while the SwiftUI version uses MVVM. The app integrates with the [New York Times Bestsellers API](https://developer.nytimes.com/docs/books-product/1/overview) to fetch and display book data. The project includes comprehensive test cases for both implementations, utilizing XCTest for unit testing. This project serves as a personal learning endeavor to explore different architectural patterns and their application in iOS development.

## Screenshots

| Categories | Books in Category | Book details |
|---|---|---|
| ![Categories List](https://github.com/user-attachments/assets/8c3f5f7f-a84b-43c5-af1d-e03dfd9803db) | ![Books in a category](https://github.com/user-attachments/assets/fb73ca8d-11d4-41b8-a073-72057e58fc50) | ![Book details](https://github.com/user-attachments/assets/e85419de-4685-48e5-8469-6d5b1df2c6c2) |

## Setup

- Create an account at [New York Times Bestsellers API](https://developer.nytimes.com/docs/books-product/1/overview) to get the API Key
- Add a new file in Xcode called `secrets.config`
- Copy the code for `secrets-sample.config` and replace the values accordingly
    - *NOTE: `secrets-sample.config` is not added to Xcode but is part of the project files*
- Choose a schema and run the project
