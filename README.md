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
 git clone git@github.com/github-explorer.git && \
    cd github-explorer && \
    mkdir App/Secrets && \
    touch touch App/Secrets/Config.xcconfig && \
    echo "GITHUB_API_KEY =" >> App/Secrets/Config.xcconfig
 ```

 :warning: Please note, without the API key you will be limited by 60 requests per hour.


