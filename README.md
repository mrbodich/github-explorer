# Github Explorer


> Github Explorer allows you to browse most popular Github repositories.


 ## Github Explorer will help you

* Browse trending repositories for different periods like Last Month, Week, Day.
* Investigate repos details
* Save repos to Favourites locally


 ## API Secrets Setup
 
 1. Create `Config.xcconfig` file in the `project_dir/App/Secrets/` folder manually or using your CI/CD pipeline
 2. Add the following content to the `Config.xcconfig` file
    * Instructions how to get API key can be found here [**Authenticating to the REST API**](https://developer.github.com/v3/auth/#basic-authentication)

 ```config
 GITHUB_API_KEY = {YOUR_API_KEY}
 ```

 Or simply run this command in terminal

 ```
 git clone https://github.com/mrbodich/github-explorer.git && \
    cd github-explorer && \
    mkdir App/Secrets && \
    touch touch App/Secrets/Config.xcconfig && \
    echo "GITHUB_API_KEY =" >> App/Secrets/Config.xcconfig
 ```

 :warning: Please note, without the API key you will be limited by 60 requests per hour.



 ## Used solutions

 ### Architecture

 MVVM+C was chosen as the architecture because of the next reasons:
 1. Reactive nature that perfectly fits with the SwiftUI
 2. Coordinator pattern allows to better stick with SOLID principles, especially single responsibility.
 3. Moreover, it allows to better decompose the project structure and thus much easier maintain whole app.

 Implemented reactive approach with the Core Data storage to minimize potential bugs and keep the better stability.


 ### Image caching

 I've created a custom caching logic that solves the next problems:
 1. Cache github images despite the fact HTTP headers contains `Cache-Control: no-cache`. Caching them forced.
 2. Created Async Semaphore to limit the number of concurrently executing requests (it could be potentially a lot on fast scrolling).
 3. Protection from multiple downloading of the same resource. Each next same request waits for the running one and will reuse the result.


 ### Persistent storage

 I chose the Core Data as the local storagefor Favourites repos.
 1. Lightweight solution because it's a dynamic library and not bundled with the app, thus not increasing it's size.
 2. Stability because it's a very good tested mature solution from Apple, that lead to less bugs in future.


 ### Secret keys

 Stored secrets in Config.xcconfig, not included in the git repo in regards to safety. This file can be included with any CI solution on the build stage.


 ### Tests

 Developed critical unit tests that cover most important logic which hard to test manually.

