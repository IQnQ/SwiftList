# Demo Repository listing iOS App using MVVM

The projects follows most of the architectural design decisions detailed in the following post : <a href="https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3">Medium Post about Clean Architecture + MVVM</a>



<img src="https://github.com/IQnQ/SwiftList/blob/master/readme_assets/IMG_4C8675841725-1.jpeg" width="300"><img src="https://github.com/IQnQ/SwiftList/blob/master/readme_assets/IMG_91120113DBD8-1.jpeg" width="300">
<img src="https://github.com/IQnQ/SwiftList/blob/master/readme_assets/IMG_D30E60F26022-1.jpeg" width="300">
<img src="https://github.com/IQnQ/SwiftList/blob/master/readme_assets/IMG_F1F38DB591C8-1.jpeg" width="300">


## Layers
* **Domain Layer** = Entities + Use Cases + Repositories Interfaces (Some of the class names are horrendous due to the application's main theme : ReposRepository.swift ...)
* **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB - (Not used at the time - after search functionality maybe )
* **Presentation Layer (MVVM)** = ViewModels + Views

## Architecture concepts used here
* All listed in the post mentioned above

## TODO
* Unit Tests 
* UI Tests
* CI Tests
* model/use case Tests
* Proper image loading in the contributor table

## Requirements
* Xcode Version 11.2.1+  Swift 5.0+
