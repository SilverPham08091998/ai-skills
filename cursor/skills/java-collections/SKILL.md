---
name: java-collections
description: Java collections standards for choosing, using, and exposing collection types safely. Use when implementing list, set, map, stream, or collection APIs.
---

# Java Collections Guidelines

This Cursor skill adapts `backend-engineer/java/collections.md` into Cursor skill guidance while preserving the source rules for production fintech development.

## When to Use This Skill

- Use when generating backend service code.
- Use when reviewing backend pull requests.
- Use when enforcing fintech-safe production rules.

## Source Guidelines

# Java Collections Guidelines

## Purpose

Define best practices for using Java Collections Framework.

Goals:

- choose correct data structure
- improve readability
- optimize performance
- avoid bugs
- write maintainable code

Applies to:

- backend services
- batch jobs
- caches
- event processing
- domain logic

---

# 1. Prefer Interfaces Over Implementations

Use collection interfaces in declarations.

Good:

List<Customer> customers = new ArrayList<>();
Set<String> ids = new HashSet<>();
Map<String, Payment> payments = new HashMap<>();

Bad:

ArrayList<Customer> customers = new ArrayList<>();

Reason:
Allows easier replacement and cleaner design.

---

# 2. Choose Correct Collection Type

## List

Use when:

- ordered items
- duplicates allowed
- index access needed

Examples:
transactions
customers in order

## Set

Use when:

- uniqueness required
- membership checks

Examples:
processedIds
uniqueEmails

## Map

Use when:

- key/value lookup
- fast access by key

Examples:
customerById
paymentByTxnId

## Queue

Use when:

- FIFO processing

Examples:
job queue
message retry queue

## Deque

Use when:

- stack + queue behavior

---

# 3. ArrayList vs LinkedList

## Prefer ArrayList by Default

Use for most cases.

Benefits:

- fast random access
- lower memory overhead
- cache friendly

## Use LinkedList Rarely

Only when frequent insertion/removal in middle with iterator context.

Most business code should use ArrayList.

---

# 4. HashSet vs TreeSet vs LinkedHashSet

## HashSet

Default set.

Fast lookup.

## LinkedHashSet

Use when insertion order matters.

## TreeSet

Use when sorted set required.

Examples:
sorted timestamps
ranked values

---

# 5. HashMap vs TreeMap vs LinkedHashMap

## HashMap

Default map.

Fast lookup.

## LinkedHashMap

Use when preserving insertion order matters.

Useful:

- LRU style logic
- deterministic iteration

## TreeMap

Use when sorted keys required.

---

# 6. Immutable Collections

Prefer immutable collections when data should not change.

Good:

List<String> roles = List.of("USER", "ADMIN");

Map<String, String> config = Map.of(...);

Benefits:

- safer
- predictable
- thread friendly

---

# 7. Return Empty Collections, Not Null

Bad:

return null;

Good:

return Collections.emptyList();

return List.of();

---

# 8. Avoid Exposing Mutable Internals

Bad:

public List<Item> getItems() {
return items;
}

Good:

public List<Item> getItems() {
return List.copyOf(items);
}

---

# 9. Initial Capacity

Use initial size when known for large collections.

Good:

new ArrayList<>(1000);
new HashMap<>(500);

Useful for performance-sensitive paths.

---

# 10. Contains Performance

Know lookup cost.

Approximate:

ArrayList.contains -> O(n)

HashSet.contains -> O(1)

HashMap.get -> O(1)

Choose structure intentionally.

---

# 11. Iteration Style

Prefer readable iteration.

Good:

for (Customer customer : customers)

Or:

customers.forEach(this::process);

Avoid index loops unless index required.

Bad:

for (int i = 0; i < list.size(); i++)

---

# 12. Remove While Iterating

Use Iterator when removing during traversal.

Good:

Iterator<Item> it = items.iterator();
while (it.hasNext()) {
if (invalid(it.next())) {
it.remove();
}
}

Avoid ConcurrentModificationException.

---

# 13. Streams vs Collections

Use streams when clearer.

Good:

var active =
users.stream()
.filter(User::isActive)
.toList();

Use loop when logic is complex or stateful.

Avoid giant unreadable stream chains.

---

# 14. Sorting

Use Comparator.

Good:

customers.sort(Comparator.comparing(Customer::name));

Multiple fields:

Comparator
.comparing(Customer::status)
.thenComparing(Customer::createdAt)

Avoid manual sorting logic when Comparator works.

---

# 15. Duplicates Handling

Need uniqueness?

Use Set.

Bad:

List<String> ids then manual duplicate checks.

Good:

Set<String> ids = new HashSet<>();

---

# 16. Map Access Safety

Use:

getOrDefault()
computeIfAbsent()
putIfAbsent()

Good:

countByType.put(type, countByType.getOrDefault(type, 0) + 1);

---

# 17. computeIfAbsent Example

Good:

grouped.computeIfAbsent(status, k -> new ArrayList<>()).add(payment);

Useful for grouping.

---

# 18. Concurrent Collections

Use thread-safe collections when shared across threads.

Examples:

ConcurrentHashMap
CopyOnWriteArrayList
BlockingQueue

Avoid plain HashMap in concurrent writes.

---

# 19. Synchronization Warning

Collections.synchronizedList() is legacy/simple option.

Prefer java.util.concurrent collections for real concurrent systems.

---

# 20. Equality Matters

For Set / Map keys:

equals() and hashCode() must be correct.

Bad:

mutable key object with broken hashCode.

Can cause lookup failures.

---

# 21. Mutable Keys Are Dangerous

Bad:

Map<Customer, String>

Then mutate customer.id later.

Use immutable keys whenever possible.

Better:

Map<String, String> customerIdMap

---

# 22. Null Handling

Prefer avoiding null elements in collections.

Bad:

List with random null values.

Good:
filter nulls before insertion.

---

# 23. Large Data Processing

Avoid loading huge lists into memory if stream/page/batch possible.

Use:

- pagination
- cursors
- chunk processing

---

# 24. Grouping Examples

Good:

Map<Status, List<Order>> grouped =
orders.stream()
.collect(groupingBy(Order::status));

Use for reporting and aggregation.

---

# 25. Memory Awareness

Collections consume memory.

Watch:

- giant caches
- duplicate copies
- unused maps
- retained references

---

# 26. Defensive Copying

When accepting external collections:

this.items = new ArrayList<>(items);

Protects internal state.

---

# 27. Use EnumMap / EnumSet

When key/type is enum.

Better performance and clarity.

Good:

EnumMap<PaymentStatus, Integer>

EnumSet<Permission>

---

# 28. Queue Use Cases

Use:

ArrayDeque for in-memory queue/stack

PriorityQueue for priority ordering

BlockingQueue for producer-consumer threading

---

# 29. Common Mistakes

Avoid:

- LinkedList by habit
- HashMap in multithreading
- returning null collections
- mutable map keys
- using List for uniqueness checks
- nested loops when Map lookup solves it

---

# 30. Performance Guide

Need random access:
-> ArrayList

Need uniqueness:
-> HashSet

Need key lookup:
-> HashMap

Need sorted:
-> TreeSet / TreeMap

Need concurrency:
-> ConcurrentHashMap

Need queue:
-> ArrayDeque / BlockingQueue

---

# 31. Review Checklist

Before merge ask:

- Correct collection chosen?
- Could Set replace duplicate checks?
- Could Map remove nested loops?
- Returning empty instead of null?
- Mutable internals exposed?
- Concurrent safe if shared?
- Efficient for expected size?
- Readable iteration?

---

# 32. Mandatory For AI Code Generation

When generating Java collection code:

- Prefer interfaces in declarations
- Use ArrayList / HashMap by default
- Return empty collections, not null
- Use Set for uniqueness
- Use Map for lookup
- Use concurrent collections when shared
- Prefer readable loops over complex streams
- Keep memory usage reasonable

## Mandatory For AI Code Generation

- Apply every MUST, MUST NOT, CRITICAL RULE, Golden Rule, and AI generation rule from the source guideline above.
- Keep Clean Architecture dependency direction intact: outer layers may depend inward, inner layers must not depend on frameworks or adapters.
- Preserve layer boundaries, naming conventions, validation, security, observability, and testing expectations from the source guideline.
- Treat fintech safety rules as mandatory: never expose secrets, tokens, credentials, personal data, or sensitive financial data in logs, errors, analytics, or tests.
- Generate production-ready Java/Spring Boot code with explicit error handling, clear names, focused responsibilities, and tests appropriate to the risk of the change.
- Do not bypass security, validation, transaction consistency, idempotency, tracing, or review requirements described above.
- Use BigDecimal for money, java.time for dates/times, and avoid legacy Java APIs unless explicitly required.
