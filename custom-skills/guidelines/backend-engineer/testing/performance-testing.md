# Performance Testing Guidelines

## Objective

Validate that systems meet latency, throughput, stability, and scalability requirements under realistic load before
production release.

---

## Core Principles

* Test realistic workloads
* Measure with clear metrics
* Reproduce production-like conditions
* Identify bottlenecks early
* Compare before vs after changes
* Protect user experience and business SLAs

---

## Types of Performance Tests

## 1. Load Test

Normal expected traffic.

Goal:

* Validate steady-state behavior
* Measure P95/P99 latency
* Check resource usage

## 2. Stress Test

Traffic beyond expected limit.

Goal:

* Find breaking point
* Observe graceful degradation

## 3. Spike Test

Sudden traffic jump.

Goal:

* Check autoscaling
* Queue handling
* Recovery speed

## 4. Soak Test

Long-running stable traffic.

Goal:

* Detect memory leak
* Detect connection leak
* Detect degradation over time

## 5. Capacity Test

Determine max safe throughput.

---

## Key Metrics

### Latency

* Average
* P50
* P95
* P99
* Max

### Throughput

* Requests/sec
* Transactions/sec
* Messages/sec

### Reliability

* Error rate
* Timeout rate
* Retry rate

### Infrastructure

* CPU
* Memory
* GC pause
* Disk IOPS
* Network
* DB connections

---

## SLA / SLO Examples

* P95 < 300ms
* P99 < 800ms
* Error rate < 0.5%
* 500 TPS sustained
* Zero data loss

---

## Test Environment Rules

### Must Be Close to Production

* Same runtime version
* Similar DB engine
* Similar cache/message broker
* Similar network rules
* Realistic data volume

### Avoid

* Laptop-only benchmark conclusions
* Empty database tests
* Tiny dataset tests

---

## Scenario Design

### Cover Real User Flows

Examples:

* Login + wallet balance check
* Transfer money
* Bill payment
* Payment callback handling
* Kafka consumer processing
* Daily reconciliation batch

### Mix Ratios Example

* 70% reads
* 20% writes
* 10% admin/reporting

---

## Test Data Strategy

* Use large enough dataset
* Include hot accounts / cold accounts
* Include skewed traffic patterns
* Reset reusable test data safely
* Avoid duplicate key conflicts

---

## Fintech / Banking Scenarios

### Must Test

* Peak salary day traffic
* Flash sale payment spike
* Duplicate callback storms
* Retry storms from partner timeout
* Ledger posting burst load
* End-of-day settlement batch

### Golden Rule

Performance must not break money correctness.

---

## Common Bottlenecks

## Application

* Blocking I/O
* Thread pool exhaustion
* Serialization overhead
* Excessive logging

## Database

* Slow query
* Missing index
* Lock contention
* Connection pool starvation

## Messaging

* Consumer lag
* Small partition count
* Large message payload

## Infrastructure

* CPU saturation
* Memory pressure
* Network bottleneck

---

## Tools (Common)

* JMeter
* k6
  n- Gatling
* Locust
* wrk
* Artillery

For Java profiling:

* JFR
* VisualVM
* Async Profiler

---

## Execution Process

## Step 1: Baseline

Run current stable version.

## Step 2: Apply Change

Run same scenario.

## Step 3: Compare

* Latency
* Throughput
* Errors
* Resource usage

## Step 4: Investigate Regression

---

## Reporting Template

## Summary

* Test date
* Build version
* Environment
* Scenario

## Results

* Peak TPS
* P95/P99 latency
* Error rate
* CPU/memory

## Findings

* Bottlenecks
* Risks
* Recommendations

---

## Pass / Fail Criteria

### Pass

* Meets SLA
* Stable under expected load
* No critical leaks
* No data inconsistency

### Fail

* High timeout rate
* Unacceptable latency
* Crash/restart loops
* Duplicate financial transactions

---

## Anti Patterns

* Only average latency reported
* No percentile metrics
* Testing empty DB
* Ignoring errors under load
* No warmup phase
* Comparing different environments unfairly

---

## CI / Release Usage

* Run smoke performance test on PRs for critical services
* Run full benchmark before major release
* Run regression test after infra/runtime upgrades

---

## Review Checklist

* [ ] Realistic scenario used
* [ ] Metrics captured fully
* [ ] Bottlenecks identified
* [ ] SLA clear
* [ ] Repeatable test script exists
* [ ] Financial correctness verified
* [ ] Report shared

---

## Golden Rule

If it was not measured under realistic load, performance is only an assumption.
