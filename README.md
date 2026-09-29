# Lab 05 SwiftRepos

Open `SwiftRepos.xcodeproj` in Xcode, allow Swift Package Manager to resolve Alamofire, choose an iPhone simulator, and run the SwiftRepos scheme. The app targets iOS 17 or later.

The app fetches the most-starred Swift repositories from the live GitHub search API, shows names, descriptions and formatted star counts, filters names using a system search field, and opens each repository in a WKWebView within a NavigationStack.

Run Product > Test (Command-U) for the four required Swift Testing view model tests and the UI test covering live loading, case-insensitive search and GitHub navigation. GitHub requires internet access and may rate-limit requests. As specified by the lab, networking failures are printed and return an empty list.

Submission screenshots are kept outside this repository and are submitted through Canvas separately.
