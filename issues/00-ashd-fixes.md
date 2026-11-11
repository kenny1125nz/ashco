## ashd.yml concurrency config
concurrency: parallel
should be change to
parallel : yes/no, true/false, y/n, case insenstive


## ashd.yml config location
ashd as daemon process, and not allowto start multi instance
it should only have one config location : ~/.ashd/ashd.yml

and the workflow paths should all be abosolute path, as ashd's cwd is unknown
