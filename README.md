In this repo, the environment.yml file has been included to help with conflicts.  To utilize it:
* Install Anaconda
* Create a environment `conda create -n azure_ragrs_table_demo`
* Activate that environment `conda activate azure_ragrs_table_demo`
* Create a directory for this repository to be cloned to: `New-Item  ~\repos\azure_ragrs_table_demo -ItemType Directory; cd ~\repos\azure_ragrs_table_demo`
* Clone this repo
* Execute environment.yml `conda env update --name azure_ragrs_table_demo --file environment.yml`
* Run `python ./demo.py`
