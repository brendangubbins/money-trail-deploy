# Political Contribution Monitoring App

## Deployment Instructions

## 1 - Setting up .env

include a .env file containing 
```
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
DB_HOST=postgres 
HOST=localhost
PORT=5432
```
## 2 - Setting up the data

include a file `contribution_data.txt` as a data source delimited by `|`

include the header 

`cmte_id|amndt_ind|rpt_tp|transaction_pgi|image_num|transaction_tp|entity_tp|name|city|state|zip_code|employer|occupation|transaction_dt|transaction_amt|other_id|tran_id|file_num|memo_cd|memo_text|sub_id`

## 3 - Running the app

run `docker compose up`

it could take about a minute for the data to setup before being able to run any apis

UI `http://localhost:5173/`

Backend DOCs `http://localhost:8000/docs`
