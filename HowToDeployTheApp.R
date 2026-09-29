# =============================================================================
# Deploying a Shiny App
# =============================================================================
# This script walks through publishing a Shiny app to the web so others can use
# it in a browser without installing R. Two hosting options are covered, both
# with free tiers:
#
#   - shinyapps.io       : Posit's hosted service, quickest to get started.
#   - Posit Connect Cloud: Posit's newer cloud platform; deploys from a Git repo.
#
# The `rsconnect` package handles publishing to both.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Prerequisites
# -----------------------------------------------------------------------------
# 1. Your app lives in its own folder and the entry point is named `app.R`
#    (or a `ui.R` + `server.R` pair). Each example folder in this repo already
#    follows this convention, e.g. SimulatedDataTableExample/app.R.
# 2. Any data files the app reads must live inside that same folder and be
#    referenced with relative paths (e.g. "data/simulated_data.csv"), so they
#    get uploaded alongside the app.
# 3. Every package your app uses must be installed locally. rsconnect scans the
#    code, detects these dependencies, and reconstructs them on the server.

install.packages("rsconnect")
library(rsconnect)


# Option A: shinyapps.io

# --- Step 1. Create a free account -------------------------------------------
# Sign up at https://www.shinyapps.io/. Then open:
#   Account (top-right) > Tokens > Show > Copy to clipboard
# This gives you a ready-made setAccountInfo() call containing your name,
# token, and secret. Paste it below (never commit the secret to Git).

rsconnect::setAccountInfo(
  name   = "your-account-name",
  token  = "your-token",
  secret = "your-secret"
)

# --- Step 2. Deploy -----------------------------------------------------------
# Point deployApp() at the folder containing app.R. The first deploy uploads
# everything and returns a public URL like:
#   https://your-account-name.shinyapps.io/AppName/

rsconnect::deployApp("SimulatedDataTableExample")

# --- Step 3. Redeploy after changes ------------------------------------------
# Re-run the same call to push updates. Passing the app name keeps it deployed
# to the same URL instead of creating a new app.

rsconnect::deployApp("SimulatedDataTableExample", appName = "SimulatedDataTableExample")


# Option B: Posit Connect Cloud
# Connect Cloud (https://connect.posit.cloud/) publishes content directly from
# a public Git repository. The typical flow is:
#
#   1. Push your app folder to a public GitHub repo (this repo qualifies).
#   2. Sign in to Connect Cloud with your GitHub account.
#   3. Click "Publish", pick the repository, branch, and the path to app.R,
#      then confirm. Connect Cloud installs dependencies and serves the app.
#
# You can also authenticate from R to publish programmatically:

rsconnect::connectCloudUser()   # opens a browser to link your account
rsconnect::deployApp("SimulatedDataTableExample", server = "connect.posit.cloud")


# Option C: Posit Connect (self-hosted or enterprise)
# If your organization runs its own Posit Connect server, register it once,
# then deploy to it by name. Ask your admin for the server URL. 
# Note ** TGen does NOT have a posit connect account.

rsconnect::connectApiUser(
  account = "your-username",
  server  = "your-connect-server",
  apiKey  = "your-api-key"
)
rsconnect::deployApp("SimulatedDataTableExample", server = "your-connect-server")


# -----------------------------------------------------------------------------
# Tips & troubleshooting
# -----------------------------------------------------------------------------
# - Test locally first:  shiny::runApp("SimulatedDataTableExample")
# - Keep secrets out of Git. Tokens/keys belong in your local rsconnect config,
#   not in committed scripts. Consider a .gitignore entry for rsconnect/.
# - "Package not found" on the server usually means it wasn't installed locally
#   when you deployed. Install it, then redeploy.
# - Relative paths only. Absolute paths from your machine won't exist on the
#   server; reference data as "data/file.csv", not "/home/you/.../file.csv".
# - Manage running apps (logs, restarts, deletion) from the shinyapps.io or
#   Connect Cloud dashboard.
#
# Docs:
#   shinyapps.io  : https://docs.posit.co/shinyapps.io/
#   Connect Cloud : https://docs.posit.co/connect-cloud/
#   rsconnect     : https://rstudio.github.io/rsconnect/
# =============================================================================
