# LDBC SNB BI Neo4j/Cypher implementation

[Cypher](http://www.opencypher.org/) implementation of the [LDBC SNB benchmark](https://github.com/ldbc/ldbc_snb_docs).
Note that some BI queries are not expressed (efficiently) in Cypher so they make use of the [APOC](https://neo4j.com/labs/apoc/) and [Graph Data Science](https://neo4j.com/product/graph-data-science-library/) Neo4j libraries.

## Generating the data set

The Neo4j implementation expects the data to be in `composite-projected-fk` CSV layout, without headers and with quoted fields.
To generate data that confirms this requirement, run Datagen with the `--explode-edges` and the `--format-options header=false,quoteAll=true` options.
This implementation also supports compressed data sets, both for the initial load and for batches. To generate compressed data sets, include `compression=gzip` in the Datagen's `--format-options` and set the `${NEO4J_CSV_FLAGS}` accordingly (see later).

(Rationale: Files should not have headers as these are provided separately in the `headers/` directory and quoting the fields in the CSV is required to [preserve trailing spaces](https://neo4j.com/docs/operations-manual/4.3/tools/neo4j-admin-import/#import-tool-header-format).)

In Datagen's directory (`ldbc_snb_datagen_spark`), issue the following commands. We assume that the Datagen project is built and the `${PLATFORM_VERSION}`, `${DATAGEN_VERSION}` environment variables are set correctly.

```bash
export SF=desired_scale_factor
export LDBC_SNB_DATAGEN_MAX_MEM=available_memory
```

```bash
rm -rf out-sf${SF}/
tools/run.py \
    --cores $(nproc) \
    --memory ${LDBC_SNB_DATAGEN_MAX_MEM} \
    ./target/ldbc_snb_datagen_${PLATFORM_VERSION}-${DATAGEN_VERSION}.jar \
    -- \
    --format csv \
    --scale-factor ${SF} \
    --explode-edges \
    --mode bi \
    --output-dir out-sf${SF}/ \
    --generate-factors \
    --format-options header=false,quoteAll=true,compression=gzip
```

## Loading the data

1. Set the `${NEO4J_CSV_DIR}` environment variable.

    * To use a locally generated data set, set the `${LDBC_SNB_DATAGEN_DIR}` and `${SF}` environment variables and run:

        ```bash
        export NEO4J_CSV_DIR=${LDBC_SNB_DATAGEN_DIR}/out-sf${SF}/graphs/csv/bi/composite-projected-fk/
        ```

        If the data is compressed, set the following flag:

        ```bash
        export NEO4J_CSV_FLAGS="--compressed"
        ```

        Or, simply run:

        ```bash
        . scripts/use-datagen-data-set.sh
        ```

    * To download and use the sample data set, run:

        ```bash
        wget -q https://ldbcouncil.org/ldbc_snb_datagen_spark/social-network-sf0.003-bi-composite-projected-fk-neo4j-compressed.zip
        unzip -q social-network-sf0.003-bi-composite-projected-fk-neo4j-compressed.zip
        export NEO4J_CSV_DIR=`pwd`/social-network-sf0.003-bi-composite-projected-fk-neo4j-compressed/graphs/csv/bi/composite-projected-fk/
        export NEO4J_CSV_FLAGS="--compressed"
        ```

        Or, simply run:

        ```bash
        scripts/get-sample-data-set.sh
        . scripts/use-sample-data-set.sh
        ```

1. Load the data:

    ```bash
    scripts/load-in-one-step.sh
    ```

1. The substitution parameters should be generated using the [`paramgen`](../paramgen).

## Microbatches

Test loading the microbatches:

```bash
scripts/batches.sh
```

:warning: Note that this script uses the data sets in the `${NEO4J_CSV_DIR}` directory on the host machine but maps the paths relative to the `/import` directory in the Docker container (Neo4j's dedicated import directory which it uses as the basis of the import paths in the `LOAD CSV` Cypher commands).
For example, the `${NEO4J_CSV_DIR}/deletes/dynamic/Post/batch_id=2012-09-13/part-x.csv` path is translated to the `deletes/dynamic/Post/batch_id=2012-09-13/part-x.csv` relative path.

## Queries

To run the queries, issue:

```bash
scripts/queries.sh ${SF}
```

For a test run, use:

```bash
scripts/queries.sh ${SF} --test
```

## Working with the database

To start a database that has already been loaded, run:

```bash
scripts/start.sh
```
