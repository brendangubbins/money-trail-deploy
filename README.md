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

##

## Design & Write-Up

### Tech Stack

| Area                 | Choice Made                     | Tradeoff                                                                                                                                    |
| -------------------- | ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------|
| **Frontend**         | React using Vite                | Easy to develop rapidly with vanilla React using Vite, but may lack in structure                                                            |
| **Backend**          | FastAPI + SQLModel              | Rapid development with FastAPI due to non complex data model, SQLModel not as feature rich                                                  |
| **Search Logic**     | Basic text filtering + pg\_trgm | Useful for mostly out of the box capabilities on fuzzy results. OTH Customization can improve accuracy                                      |
| **Containerization** | Docker + Docker Compose         | Local development separation of concerns, potential to scale up independently                                                               |
| **Database**         | PostgreSQL                      | Decided for SQL over NoSQL due the database only requiring a one time setup. Strictly a RO application, PostgreSQL chosen for fast querying | 

### Overview

This Poltical Contribution Monitor (or Money Trail) is a full-stack web designed to let users search, filter, and visualize political contribution data. I decided to use React + Vite on the frontend, Python + FastAPI for the querying and aggregating data within the server, and PostgreSQL for the database to store the 300+ million records of political contributions. I also used Docker Compose for local development.

The way the application works is that, on first build, a script `init.sql` is ran which creates a `Contribution` table representing political contributions. It then feeds in records through the `.txt` file provided by [fec.gov](https://www.fec.gov/data/browse-data/?tab=bulk-data). Indexes are created on key search fields such as contribution amount, contributor name (using pg_trgm for the fuzzy matching of names). The backend exposes APIs for the frontend to display on the browser. These APIs are for searching contributions by name and/or location, and also for data visualization such as contributions over time and contribution by bucket value.

### Tradeoffs / Design Decisions / Improvements

The largest tradeoff to consider was how to handle the data. Since the dataset is fairly large (300+ million records), I decided it was important to have this data persisted as a one-time upload rather than operating solely within memory. I chose to use a Postgres database instead of NoSQL i.e MongoDB. Though I originally was considering using NoSQL, because the data structure was loosely structured (only care about a select few attributes), and there wasn't any need for complex relationships or joins, I landed on using Postgres because I expected to have to potentially run complicated queries or create structured data leading to joins (I did not end up needing/wanting to). In retrospect using MongoDB probably had stronger merit (web application heavy on reads, denormalized dataset, relatively simple queries only needing minor aggregation). 

If I had more time and could do things differently, I'd likely use some combination of MongoDB / caching ie Redis. Since the application is almost entirely read-only, there is performance optimizations to be had when loading the data grid or charts. I would also focus more on cleaner design in terms of structuring my code, as this is something I tend to always want to circle back on. But since I was strapped for time, I could only do minor refactoring along the way. Some additions I would like to make is creating more charts such as a heatmap of the USA showing frequency of contributions as well as dollar amounts. I would also make the visualization more customizable and add cool features like pie chart drilldowns to show breakdowns of contributions by various categories.

To scale for production, there would need to be a few key things implemented. Firstly, an API gateway ie NGINX for load balancing and routing. Additionally, caching expensive queries will be valuable as user demand increases, performance becomes more important. For production I'd use Kubernetes for deployment and scaling/management. If traffic is high, having multiple servers (especially geographically spread) can be an option as well.
