# Bash_script_for_merging_branches

This script determine current release branch ( For example: release/v0.1 ), then increase release version one count 
and determine new release branch ( For example: release/v0.2 ). Checkout to current release branch, pull all news and 
checkout to master branch, then pull all news from remote master branch and merge current release branch to master and 
push all news to remote master branch. Then checkout to develop branch , pull all news from remote develop branch and then 
merge master branch to develop and push to remote develop branch. Then create new release branch from develop branch and push 
all data to remote branch and create remote new release branch.
