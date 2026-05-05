# Master-Slave Pattern Guidelines

## Objective

Describe how to apply the Master-Slave pattern in distributed systems and microservices for workload distribution, read
scaling, failover, and controlled task execution.

---

## Overview

Master-Slave is a pattern where one primary node coordinates or owns write/control responsibilities, while one or more
secondary nodes replicate state or execute delegated tasks.

### Common Modern Terms

* Primary / Replica
* Leader / Follower
* Active / Standby

---

## When to Use

### Suitable Cases

* Database replication
* Read scaling
* Scheduled job ownership
* Single-writer systems
* Leader election workloads
* High availability failover
* Centralized coordination tasks

### Avoid If

* Need multi-writer global consistency
* Extreme low-latency peer-to-peer mesh needed
* Single master becomes bottleneck without mitigation

---

## Core Responsibilities

## Master Node

* Accept writes / commands
* Coordinate state changes
* Replicate data to slaves
* Manage locks / leadership
* Trigger scheduled jobs
* Decide failover rules

## Slave Nodes

* Serve read traffic (optional)
* Maintain replicated state
* Execute delegated tasks
* Standby for failover
* Report health/status

---

## Architecture Models

## 1. Database Primary-Replica

App -> Primary (write)
App -> Replicas (read)

Use for:

* Reporting queries
* Search/list endpoints
* Heavy read systems

## 2. Service Leader Election

Many instances deployed.
One elected leader runs cron/reconciliation.
Others standby.

## 3. Active-Passive Processing

One active node handles stream.
Secondary waits for takeover.

---

## Microservice Use Cases

## Scheduled Jobs

Examples:

* End-of-day settlement
* Reconciliation batch
* FX rate sync
* Cache warmup
* Statement generation

Only leader/master executes.

## Read Scaling

Use read replicas for:

* transaction history
* dashboard analytics
* reporting APIs

## Failover

Standby node promoted when master fails.

---

## Database Pattern Rules

### Write Routing

All writes go to primary.

### Read Routing

Reads may go to replica if eventual consistency acceptable.

### Beware Replica Lag

Recent write may not appear immediately.

Use primary read for:

* balance inquiry after transfer
* payment final confirmation
* security-sensitive checks

---

## Fintech / Banking Guidance

### Never Use Stale Replica For

* current balance decision
* fraud decision requiring latest state
* duplicate transaction prevention
* ledger final validation

### Safe Replica Use

* transaction history list
* reports
* analytics dashboards
* exports

### Golden Rule

Money-critical decisions require freshest source of truth.

---

## Leader Election Approaches

### Common Tools

* Kubernetes Lease
* Consul sessions
* ZooKeeper
* etcd
* Redis lock (carefully)

### Requirements

* only one active leader
* lease expiration
* automatic re-election
* fencing protection if split brain risk

---

## Split Brain Risk

Two masters active simultaneously.

### Dangerous Outcomes

* duplicate settlement run
* double payouts
* conflicting writes
* duplicate notifications

### Mitigation

* quorum consensus
* lease TTL
* fencing token
* idempotent jobs

---

## Job Execution Pattern

### Example

3 instances of reconciliation-service.
Only elected leader runs 01:00 AM reconciliation.

### Flow

1. acquire leadership lease
2. verify ownership token
3. run job
4. renew lease periodically
5. release on shutdown

---

## Failover Strategy

### Must Define

* health check interval
* fail detection threshold
* promotion procedure
* recovery after old master returns
* data sync process

### Avoid

Manual unclear failover during incidents.

---

## Observability

### Metrics

* current leader node
* replica lag seconds
* replication errors
* leadership changes count
* failover count
* job runtime by leader

### Logs

* leader elected
* leader lost
* failover triggered
* replica behind threshold

---

## Performance Considerations

### Master Bottleneck Risk

Master may saturate CPU/IO.

Mitigate:

* scale reads to replicas
* partition/shard writes
* optimize write path
* queue workloads

---

## Security Considerations

* secure replication channel (TLS)
* restricted promotion access
* audit leadership changes
* protect admin failover endpoints

---

## Testing Strategy

### Must Test

* leader election correctness
* node crash failover
* network partition behavior
* duplicate job prevention
* replica lag tolerance
* recovery after restart

---

## Example in Spring Boot + Kubernetes

Use 3 pods.
Use Lease API.
Only leader pod executes @Scheduled wrapper logic.
Others idle.

---

## Anti Patterns

* All nodes run same cron job
* Reads from stale replica for balances
* No failover runbook
* Manual lock via DB row without timeout
* Hidden second master instance

---

## Review Checklist

* [ ] Single writer responsibilities clear
* [ ] Replica usage safe by use case
* [ ] Leader election reliable
* [ ] Split brain mitigated
* [ ] Failover tested
* [ ] Metrics/alerts ready
* [ ] Money flows use primary truth source

---

## Golden Rule

Master-Slave improves scale and availability only when leadership and data freshness are controlled carefully.
