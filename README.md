# SPProfiling

Ready use service with using Firebase. Included interface, manage auth process, recored devices and profile data.

<img src="https://user-images.githubusercontent.com/10995774/153156766-5288e041-1c2d-48cd-b833-dab507f3fbe1.jpeg" height="550"/>

## Installation

Ready for use on iOS 13+.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/ivanvorobei/SPProfiling", .upToNextMajor(from: "1.0.2"))
]
```

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/SPProfiling` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Usage

First call configure services:

```swift
let filePath = Bundle.module.path(forResource: Constants.Firebase.plist_filename, ofType: .empty)!
let options = FirebaseOptions(contentsOfFile: filePath)!
SPProfiling.configure(firebaseOptions: options)
```

All actions doing from `ProfileModel`.

```swift
ProfileModel.isAuthed
ProfileModel.isAnonymous
ProfileModel.currentProfile

ProfileModel.getProfile(userID...)
ProfileModel.getProfile(email...)

ProfileModel.signInApple(...)
ProfileModel.signInAnonymously(...)
ProfileModel.signOut(...)

let profileModel = ProfileModel.currentProfile
profileModel.setName(...)
profileModel.getAvatarURL(...)
profileModel.setAvatar(...)
profileModel.deleteAvatar(...)

// Ready-use interface
ProfileModel.showCurrentProfile(...)
```
