ceph:
  version: firefly
  cluster_name: ceph
  global:
    cluster_network: 192.168.100.0/24
    fsid: 59fe8b37-47ed-471a-b03a-a7aa05cdd53a
    public_network: 146.169.2.0/24
  client:
    rbd_cache: "true"
    rbd_cache_writethrough_until_flush: "true"
    rbd_cache_size: 134217728
  osd:
    crush_chooseleaf_type: 1
    crush_update_on_start: "true"
    filestore_merge_threshold: 10
    filestore_split_multiple: 2
    filestore_op_threads: 2
    filestore_max_sync_interval: 5
    filestore_min_sync_interval: "0.01"
    filestore_queue_max_ops: 500
    filestore_queue_max_bytes: 104857600
    filestore_queue_committing_max_ops: 500
    filestore_queue_committing_max_bytes: 104857600
    journal_size: 512
    op_threads: 1
    disk_threads: 1
    scrub_load_threshold: "0.5"
    map_cache_size: 512
    max_backfills: 2
    pool_default_min_size: 2
    pool_default_pg_num: 4096
    pool_default_pgp_num: 4096
    pool_default_size: 3
  mon:
    interface: eth0
