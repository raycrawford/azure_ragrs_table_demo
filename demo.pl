# Reference documentation:
# https://www.sentryone.com/blog/azure-table-storage-tips-for-the-rdbms-developer
# Interesting but old: https://github.com/Azure/azure-cosmos-table-python/blob/master/azure-cosmosdb-table/samples/advanced/client.py

import time
import datetime
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
from azure.cosmosdb.table.common.retry import no_retry

key = ''
storage_account = ''
table_name = ''

if not storage_account:
  print("Enter your storage account name: ")
  storage_account = input()

if not key:
  print("Enter your storage account key: ")
  key = input()

table_service = TableService(account_name=storage_account, account_key=key)

# Create a table
if not table_name:
  print("Creating new table and sleeping for five seconds.")
  this_date = datetime.datetime.now().strftime("%Y%m%d%H%M%S%f")
  table_name = "tabledemo" + str(this_date) 
  table_service.create_table(table_name)
  time.sleep(5)
  print("Table created.")

task = {'PartitionKey': 'tasksSeattle', 'RowKey': '001',
        'description': 'Take out the trash', 'priority': 200}
table_service.insert_entity(table_name, task)

print("From primary")
tasks = table_service.query_entities(
    table_name, filter="PartitionKey eq 'tasksSeattle'", select='description')
for task in tasks:
  print(task.description)

tasks = ''
table_service.retry = no_retry
table_service.location_mode = 'secondary'
print("Pulling data from read-access GRS copy...")
counter = 1

task.description = ''
start = time.time()

while task.description == '':
  try:
    task = table_service.get_entity(table_name, 'tasksSeattle', '001')
    if task.description:
      print(task.description)
      print(task)
      end = time.time()
      duration = end - start
      print(str(duration))
  except Exception as e:
   counter += 1
  print("Completed pass " + str(counter))

print("Deleting...")
table_service.delete_entity(table_name, 'tasksSeattle', '001')
