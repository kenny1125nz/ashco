
## wokflow firing working folder
consider workflows are meta data, that in theory can site remotely (in the future), we can't use workflow's folder as ash command's working folder
the message listening folder is also not a good idea, we better keep it single purpose

We need add a config item in config.yaml for each workflow to set working folder to run the ash command.  for example for coding work, it will be the project local repo root

although , workflow could contain logic to clone repo from remote , commit and push when work is done, then it does not matter where is the working folder, while need tidy up after(as part of ) the workflow.


