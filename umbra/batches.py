import psycopg2
from datetime import datetime, date
from dateutil.relativedelta import relativedelta
import os

def run_script(cur, filename):
    with open(filename, "r") as f:
        queries_file = f.read()
        queries = queries_file.split(";")
        for query in queries:
            if query.isspace():
                continue
            #print(f"{query}")
            cur.execute(query)

data_dir = sf = os.environ.get("UMBRA_CSV_DIR")
if data_dir is None:
    print("${UMBRA_CSV_DIR} environment variable must be set")
    exit(1)

print("Datagen / apply batches using SQL")
print(f"- Input data directory, ${{UMBRA_CSV_DIR}}: {data_dir}")

insert_nodes = ["Comment", "Forum", "Person", "Post"]
insert_edges = ["Comment_hasTag_Tag", "Forum_hasMember_Person", "Forum_hasTag_Tag", "Person_hasInterest_Tag", "Person_knows_Person", "Person_likes_Comment", "Person_likes_Post", "Person_studyAt_University", "Person_workAt_Company",  "Post_hasTag_Tag"]
insert_entities = insert_nodes + insert_edges

# set the order of deletions to reflect the dependencies between node labels (:Comment)-[:REPLY_OF]->(:Post)<-[:CONTAINER_OF]-(:Forum)-[:HAS_MODERATOR]->(:Person)
delete_nodes = ["Comment", "Post", "Forum", "Person"]
delete_edges = ["Forum_hasMember_Person", "Person_knows_Person", "Person_likes_Comment", "Person_likes_Post"]
delete_entities = delete_nodes + delete_edges


pg_con = psycopg2.connect(database="ldbcsnb", host="localhost", user="postgres", password="mysecretpassword", port=8000)
cur = pg_con.cursor()

run_script(cur, f"ddl/schema-delete-candidates.sql");

network_start_date = date(2012, 11, 29)
network_end_date = date(2013, 1, 11)
# smaller range for testing
#network_end_date = date(2012, 9, 15)
batch_size = relativedelta(days=1)

batch_start_date = network_start_date
while batch_start_date < network_end_date:
    # format date to yyyy-mm-dd
    batch_id = batch_start_date.strftime('%Y-%m-%d')
    batch_dir = f"batch_id={batch_id}"
    print(f"#################### {batch_dir} ####################")

    print("## Inserts")
    for entity in insert_entities:
        batch_path = f"{data_dir}/inserts/dynamic/{entity}/{batch_dir}"
        if not os.path.exists(batch_path):
            continue

        for csv_file in [f for f in os.listdir(batch_path) if f.endswith(".csv")]:
            csv_path = f"{batch_path}/{csv_file}"
            print(f"- {csv_path}")
            cur.execute(f"COPY {entity} FROM '/data/inserts/dynamic/{entity}/{batch_dir}/{csv_file}' (DELIMITER '|', HEADER, FORMAT csv)")
            pg_con.commit()

    print("## Deletes")
    # Deletes are implemented using a SQL script which use auxiliary tables.
    # Entities to be deleted are first put into {entity}_Delete_candidate tables.
    # These are cleaned up before running the delete script.
    for entity in delete_entities:
        cur.execute(f"DELETE FROM {entity}_Delete_candidates")

        batch_path = f"{data_dir}/deletes/dynamic/{entity}/{batch_dir}"
        if not os.path.exists(batch_path):
            continue

        for csv_file in [f for f in os.listdir(batch_path) if f.endswith(".csv")]:
            csv_path = f"{batch_path}/{csv_file}"
            print(f"> {csv_path}")
            cur.execute(f"COPY {entity}_Delete_candidates FROM '/data/deletes/dynamic/{entity}/{batch_dir}/{csv_file}' (DELIMITER '|', HEADER, FORMAT csv)")
            pg_con.commit()

    print()
    print("<running delete script>")
    # Invoke delete script which makes use of the {entity}_Delete_candidates tables
    run_script(cur, "dml/snb-deletes.sql")
    print("<finished delete script>")
    print()

    batch_start_date = batch_start_date + batch_size

cur.close()
pg_con.close()
