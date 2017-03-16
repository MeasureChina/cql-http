# cql-http

use cql via http  


## scylladb using docker

```sh
docker run --name scylla -p 9042:9042 scylladb/scylla

docker exec scylla ps aux

docker exec -it scylla cqlsh 172.17.0.2 -p 9042
```

## basic cassandra query

```cql
CREATE KEYSPACE goblins WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

CREATE TABLE goblins.sensors (
  id bigint,
  page text,
  count bigint,
  PRIMARY KEY (id, page)
);

SELECT * FROM goblins.sensors;

```

