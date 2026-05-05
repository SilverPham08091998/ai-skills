# TypeScript — Async Patterns

## 1. `async/await` thay vì `.then()` chains

```typescript
// ❌ — callback pyramid, khó đọc, khó debug
function loadDashboard(userId: string) {
  fetchUser(userId)
    .then(user => fetchUserOrders(user.id)
      .then(orders => fetchOrderDetails(orders[0].id)
        .then(details => ({ user, orders, details }))
      )
    )
    .catch(handleError);
}

// ✅ — linear, dễ đọc, dễ debug, stack trace rõ
async function loadDashboard(userId: string): Promise<DashboardData> {
  const user = await fetchUser(userId);
  const orders = await fetchUserOrders(user.id);
  const details = await fetchOrderDetails(orders[0].id);
  return { user, orders, details };
}
```

---

## 2. Parallel khi operations độc lập nhau

```typescript
// ❌ — sequential dù không phụ thuộc nhau
// Tổng = T(user) + T(config) + T(flags)
const user = await fetchUser(userId);
const config = await fetchAppConfig();
const flags = await fetchFeatureFlags();

// ✅ — parallel
// Tổng = max(T(user), T(config), T(flags))
const [user, config, flags] = await Promise.all([
  fetchUser(userId),
  fetchAppConfig(),
  fetchFeatureFlags(),
]);

// ✅ — Promise.allSettled khi không muốn fail-fast
// Một fail không cancel các cái khác
const results = await Promise.allSettled([fetchA(), fetchB(), fetchC()]);
results.forEach(result => {
  if (result.status === 'fulfilled') process(result.value);
  else logError(result.reason);
});

// ✅ — Promise.race — lấy cái nhanh nhất
const data = await Promise.race([
  fetchFromPrimary(),
  fetchFromFallback(),
]);

// ✅ — Promise.any — lấy cái thành công đầu tiên (ignore failures)
const fastestSuccess = await Promise.any([
  fetchFromRegion('us'),
  fetchFromRegion('asia'),
  fetchFromRegion('eu'),
]);
```

---

## 3. Timeout pattern

```typescript
// Promise với timeout
function withTimeout<T>(promise: Promise<T>, ms: number, label = 'Operation'): Promise<T> {
  const timeout = new Promise<never>((_, reject) =>
    setTimeout(() => reject(new Error(`${label} timed out after ${ms}ms`)), ms),
  );
  return Promise.race([promise, timeout]);
}

// Dùng
const user = await withTimeout(fetchUser(id), 5_000, 'fetchUser');

// Cleanup timeout nếu promise resolve sớm (tránh memory leak)
function withCleanTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
  let timeoutId: ReturnType<typeof setTimeout>;
  const timeout = new Promise<never>((_, reject) => {
    timeoutId = setTimeout(() => reject(new Error(`Timeout after ${ms}ms`)), ms);
  });
  return Promise.race([promise, timeout]).finally(() => clearTimeout(timeoutId));
}
```

---

## 4. Cancellation với AbortController

```typescript
// HTTP request có thể cancel
async function fetchWithCancel(url: string, signal: AbortSignal): Promise<unknown> {
  const response = await fetch(url, { signal });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  return response.json();
}

// React hook — cancel khi unmount hoặc deps thay đổi
function useUserData(userId: string) {
  const [data, setData] = useState<UserEntity | null>(null);

  useEffect(() => {
    const controller = new AbortController();

    fetchWithCancel(`/api/users/${userId}`, controller.signal)
      .then(raw => setData(parseUser(raw)))
      .catch(error => {
        if (error.name !== 'AbortError') {
          console.error('Fetch failed:', error);
        }
        // AbortError là expected khi cleanup — ignore
      });

    return () => controller.abort(); // cleanup khi unmount hoặc userId thay đổi
  }, [userId]);

  return data;
}
```

---

## 5. Retry pattern

```typescript
interface RetryOptions {
  maxAttempts?: number;
  delayMs?: number;
  backoffFactor?: number;
  shouldRetry?: (error: unknown, attempt: number) => boolean;
}

async function withRetry<T>(
  fn: () => Promise<T>,
  options: RetryOptions = {},
): Promise<T> {
  const {
    maxAttempts = 3,
    delayMs = 1_000,
    backoffFactor = 2,
    shouldRetry = () => true,
  } = options;

  let lastError: unknown;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error: unknown) {
      lastError = error;
      if (attempt === maxAttempts || !shouldRetry(error, attempt)) break;
      await delay(delayMs * Math.pow(backoffFactor, attempt - 1));
    }
  }

  throw lastError;
}

const delay = (ms: number): Promise<void> =>
  new Promise(resolve => setTimeout(resolve, ms));

// Dùng
const data = await withRetry(
  () => fetchFromApi('/orders'),
  {
    maxAttempts: 3,
    delayMs: 500,
    shouldRetry: (error) => error instanceof NetworkError,
  },
);
```

---

## 6. Queue / Throttle concurrent requests

```typescript
// Giới hạn số request song song
async function processInBatches<T, R>(
  items: T[],
  processor: (item: T) => Promise<R>,
  concurrency = 5,
): Promise<R[]> {
  const results: R[] = [];

  for (let i = 0; i < items.length; i += concurrency) {
    const batch = items.slice(i, i + concurrency);
    const batchResults = await Promise.all(batch.map(processor));
    results.push(...batchResults);
  }

  return results;
}

// Dùng — tải 100 ảnh, mỗi lần 5
const images = await processInBatches(imageUrls, downloadImage, 5);
```

---

## 7. Async initialization pattern

```typescript
// ❌ — async trong constructor
class Service {
  private data: Data;
  constructor() {
    this.data = await loadData(); // Error: không thể await trong constructor
  }
}

// ✅ — lazy initialization
class Service {
  private data: Data | null = null;

  async getData(): Promise<Data> {
    if (!this.data) {
      this.data = await loadData();
    }
    return this.data;
  }
}

// ✅ — static async factory
class Service {
  private constructor(private readonly data: Data) {}

  static async create(): Promise<Service> {
    const data = await loadData();
    return new Service(data);
  }
}

const service = await Service.create();
```

---

## 8. Tránh async không cần thiết

```typescript
// ❌ — async wrapper thừa
async function getConfig(): Promise<AppConfig> {
  return defaultConfig; // không có await
}

async function mapItems(items: string[]): Promise<string[]> {
  return items.map(i => i.toUpperCase()); // không có await
}

// ✅
function getConfig(): AppConfig {
  return defaultConfig;
}

function mapItems(items: string[]): string[] {
  return items.map(i => i.toUpperCase());
}

// ❌ — await không cần thiết (return Promise trực tiếp OK trong try/finally)
async function fetchData(): Promise<Data> {
  return await api.get('/data'); // await thừa khi chỉ return
}

// ✅ — chỉ await khi cần xử lý trước khi return, hoặc trong try/finally
async function fetchData(): Promise<Data> {
  return api.get('/data');
}

// await cần thiết trong try/finally
async function fetchWithLog(): Promise<Data> {
  try {
    return await api.get('/data'); // cần await để catch bắt được
  } finally {
    logger.log('fetch completed');
  }
}
```

---

## 9. Floating Promises — không để lơ lửng

```typescript
// ❌ — promise không được handle
function handlePress() {
  submitOrder(order); // fire and forget — lỗi bị nuốt
  navigation.goBack();
}

// ✅ — xử lý promise
function handlePress() {
  submitOrder(order)
    .then(() => navigation.goBack())
    .catch(error => showError(error));
}

// ✅ — hoặc async function
async function handlePress() {
  try {
    await submitOrder(order);
    navigation.goBack();
  } catch (error: unknown) {
    showError(isAppError(error) ? error.message : 'Submit failed');
  }
}

// ✅ — void operator khi intentionally fire-and-forget
function startBackgroundSync() {
  void syncInBackground(); // explicit về việc không handle
}
```
