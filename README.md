# docker-postgres-decoderbufs

## vi postgresql.conf
``` text
wal_level = logical
max_wal_senders = 4
wal_keep_segments = 64
max_replication_slots = 4
shared_preload_libraries = 'decoderbufs'
#shared_preload_libraries = 'wal2json'
```


## vi pg_hba.conf
``` text
host replication all all trust
```
