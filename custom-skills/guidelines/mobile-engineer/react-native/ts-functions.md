# TypeScript — Function & Class Patterns

## FUNCTIONS

### 1. Pure Functions ưu tiên

```typescript
// ❌ — side effects ẩn, khó test, khó predict
let total = 0;
function addToTotal(amount: number): void {
  total += amount;
}

// ✅ — pure: same input → same output, không side effect
function calculateTotal(items: OrderItem[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

// ✅ — transform data, không mutate input
function applyDiscount(order: OrderEntity, rate: number): OrderEntity {
  return { ...order, total: order.total * (1 - rate) };
}
```

---

### 2. Không quá 3 tham số — dùng Options object

```typescript
// ❌ — khó nhớ thứ tự, dễ nhầm khi gọi
function transferMoney(
  fromAccountId: string,
  toAccountId: string,
  amount: number,
  currency: string,
  note: string,
  isScheduled: boolean,
): Promise<void>

// ✅ — named params, tự documenting, optional dễ hơn
interface TransferMoneyParams {
  fromAccountId: string;
  toAccountId: string;
  amount: number;
  currency: string;
  note?: string;
  isScheduled?: boolean;
}
function transferMoney(params: TransferMoneyParams): Promise<void>

// Destructure ngay trong signature
function transferMoney({
  fromAccountId,
  toAccountId,
  amount,
  currency,
  note = '',
  isScheduled = false,
}: TransferMoneyParams): Promise<void> { ... }
```

---

### 3. Default Parameters thay vì overloading đơn giản

```typescript
// ❌ — overload thừa cho default values
function createUser(name: string): User;
function createUser(name: string, role: string): User;
function createUser(name: string, role: string, active: boolean): User;

// ✅
function createUser(
  name: string,
  role: UserRole = UserRole.Member,
  active = true,
): User { ... }
```

---

### 4. Arrow Function vs Function Declaration

```typescript
// Function Declaration — top-level functions, named exports
export function calculateFee(amount: number, rate: number): number {
  return amount * rate;
}

// Arrow Function — callbacks, const assignments
const double = (n: number): number => n * 2;
const handlePress = useCallback(() => { ... }, []);

// Class methods — dùng function syntax (không arrow)
class OrderService {
  // ✅ — prototype method, kế thừa được
  processOrder(order: Order): void { ... }

  // ❌ — instance method, tốn bộ nhớ, không kế thừa được
  processOrder = (order: Order): void => { ... }
}

// Ngoại lệ — arrow trong class khi cần bind this
class EventComponent {
  handleClick = (): void => {
    this.doSomething(); // this binding đảm bảo
  };
}
```

---

### 5. Early Return — tránh deep nesting

```typescript
// ❌ — deeply nested, khó đọc
function processOrder(order: Order | null): string {
  if (order !== null) {
    if (order.status === OrderStatus.Active) {
      if (order.items.length > 0) {
        return 'Valid order';
      } else {
        return 'Empty order';
      }
    } else {
      return 'Inactive order';
    }
  } else {
    return 'No order';
  }
}

// ✅ — guard clauses
function processOrder(order: Order | null): string {
  if (order === null) return 'No order';
  if (order.status !== OrderStatus.Active) return 'Inactive order';
  if (order.items.length === 0) return 'Empty order';
  return 'Valid order';
}
```

---

### 6. Function Overloads — chỉ khi return type phụ thuộc vào input

```typescript
// ✅ — return type thực sự khác nhau theo input type
function parse(value: string): number;
function parse(value: number): string;
function parse(value: string | number): string | number {
  if (typeof value === 'string') return parseInt(value, 10);
  return value.toString();
}

// ✅ — behavior khác nhau
function find(id: string): UserEntity | null;
function find(predicate: (u: UserEntity) => boolean): UserEntity[];
function find(arg: string | ((u: UserEntity) => boolean)): UserEntity | UserEntity[] | null {
  if (typeof arg === 'string') return users.find(u => u.id === arg) ?? null;
  return users.filter(arg);
}
```

---

### 7. Không async khi không cần

```typescript
// ❌ — async không cần thiết, tạo Promise wrapper thừa
async function getConfig(): Promise<AppConfig> {
  return defaultConfig;
}

// ✅
function getConfig(): AppConfig {
  return defaultConfig;
}

// ❌ — Promise.resolve thừa
function getData(): Promise<string> {
  return Promise.resolve(cachedValue);
}

// ✅ — chỉ async khi có await
async function fetchData(): Promise<string> {
  const response = await api.get('/data');
  return response.data;
}
```

---

## CLASSES

### 8. Access Modifiers — explicit luôn

```typescript
// ❌ — không rõ visibility
class OrderRepository {
  baseUrl = '/api/orders';
  cache = new Map();
  fetch(id: string) { ... }
  buildUrl(path: string) { ... }
}

// ✅
class OrderRepository {
  private readonly baseUrl = '/api/orders';
  private readonly cache = new Map<string, OrderEntity>();

  public async findById(id: string): Promise<OrderEntity | null> { ... }
  private buildUrl(path: string): string { ... }
  protected parseResponse(raw: unknown): OrderEntity { ... }
}
```

---

### 9. `readonly` cho injected dependencies

```typescript
// ✅ — dependencies không thể bị reassign sau construction
@injectable()
class TransferHandler {
  constructor(
    @inject(TYPES.TransferRepository)
    private readonly transferRepo: ITransferRepository,

    @inject(TYPES.FeeService)
    private readonly feeService: IFeeService,
  ) {}
}
```

---

### 10. Abstract Classes cho shared behavior

```typescript
abstract class BaseRepository<T extends { id: string }> {
  protected abstract readonly endpoint: string;
  protected abstract parseEntity(raw: unknown): T;

  async findById(id: string): Promise<T | null> {
    const response = await this.http.get(`${this.endpoint}/${id}`);
    if (!response.data) return null;
    return this.parseEntity(response.data);
  }

  async findAll(): Promise<T[]> {
    const response = await this.http.get(this.endpoint);
    return (response.data as unknown[]).map(raw => this.parseEntity(raw));
  }
}

class UserRepository extends BaseRepository<UserEntity> {
  protected readonly endpoint = '/api/users';
  protected parseEntity(raw: unknown): UserEntity {
    return mapToUserEntity(raw);
  }
}
```

---

### 11. Không dùng Class khi Function đủ

```typescript
// ❌ — class không cần thiết cho stateless logic
class FeeCalculator {
  calculate(amount: number, rate: number): number {
    return amount * rate;
  }
}
const calc = new FeeCalculator();
calc.calculate(100, 0.02);

// ✅ — pure function
const calculateFee = (amount: number, rate: number): number => amount * rate;
calculateFee(100, 0.02);
```

Dùng Class khi cần: DI decorators, stateful instance, inheritance, implements interface.

---

### 12. Constructor — không có logic phức tạp

```typescript
// ❌ — constructor làm quá nhiều
class UserService {
  private users: UserEntity[];
  constructor(private readonly repo: IUserRepository) {
    // ❌ — async trong constructor không chờ được
    this.users = await this.repo.findAll();
  }
}

// ✅ — lazy load hoặc factory async
class UserService {
  private users: UserEntity[] | null = null;

  constructor(private readonly repo: IUserRepository) {}

  async getUsers(): Promise<UserEntity[]> {
    if (!this.users) {
      this.users = await this.repo.findAll();
    }
    return this.users;
  }
}

// ✅ — static async factory
class UserService {
  private constructor(
    private readonly repo: IUserRepository,
    private readonly users: UserEntity[],
  ) {}

  static async create(repo: IUserRepository): Promise<UserService> {
    const users = await repo.findAll();
    return new UserService(repo, users);
  }
}
```
