# Github Explorer


> Github Explorer allows you to browse most popular Github repositories.


 ## Github Explorer will help you

* Browse trending repositories for different periods like Last Month, Week, Day.
* Investigate repos details
* Save repos to Favourites locally


 ## API Secrets Setup
 
 1. Create `Config.xcconfig` file in the `project_dir/App/Secrets/` folder manually or using your CI/CD pipeline
 2. Add the following content to the `Config.xcconfig` file
    * Instructions can be found here [**Authenticating to the REST API**](https://developer.github.com/v3/auth/#basic-authentication)

 ```config
 GITHUB_API_KEY = {YOUR_API_KEY}
 ```

 :warning: Please note, without the API key you will be limited by 60 requests per hour.


