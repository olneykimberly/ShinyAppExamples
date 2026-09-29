# step 1. load the rconnect library
install.packages("rsconnect")
library(rsconnect)

# step 2. link to account for either shinyapps.io or connect cloud. 
# both have free versions

# for shinyapps.io
rsconnect::setAccountInfo(
  name='your-account-name', 
  token='token-id', 
  secret='secret-key')

# for connect cloud 
rsconnect::connectCloudUser()

# step 3. deploy the app
# If your R session is already inside the folder with app.R
rsconnect::deployApp()

# Or specify the folder path explicitly
rsconnect::deployApp("path/to/your/shiny/app")