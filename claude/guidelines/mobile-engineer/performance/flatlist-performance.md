# ========================

# ⚡ FLATLIST PERFORMANCE RULE (REACT NATIVE)

# ========================

## 🎯 OBJECTIVE

Define performance rules for `FlatList`, `SectionList`, and virtualized lists in React Native to ensure:

* Smooth scrolling
* Low memory usage
* Fewer unnecessary re-renders
* Stable large-list performance
* Good UX for fintech / banking transaction lists

Applied for:

```txt
React Native
FlatList
SectionList
VirtualizedList
Transaction history
Notification list
Search result list
```

---

# ========================

# 🧠 CORE PRINCIPLE

# ========================

```txt
FlatList performance depends on stable props, stable item rendering, and correct virtualization config.
```

Golden rule:

```txt
Do not put heavy logic inside renderItem.
Do not create unstable functions/objects during render.
```

---

# ========================

# 📁 STRUCTURE

# ========================

Recommended structure:

```txt
src/presentation/transaction/
  transaction-history.screen.tsx
  transaction-history.view.tsx
  transaction-history.style.ts
  hook/
    use-transaction-history.ts
    transaction-history.state.ts

src/component/list-item/
  transaction-list-item.tsx
  transaction-list-item.props.ts
```

Rule:

```txt
Screen/hook owns data and events.
List item component owns item rendering only.
```

---

# ========================

# ✅ BASIC FLATLIST RULE

# ========================

A production FlatList MUST define:

```txt
data
renderItem
keyExtractor
ListEmptyComponent
ListFooterComponent when paginating
onEndReached when loading more
refreshControl or onRefresh when pull-to-refresh exists
```

Example:

```tsx
<FlatList
  data={transactions}
  keyExtractor={keyExtractor}
  renderItem={renderItem}
  ListEmptyComponent={EmptyTransactionView}
  ListFooterComponent={isLoadingMore ? <LoadingFooter /> : null}
  onEndReached={handleLoadMore}
  onEndReachedThreshold={0.5}
  refreshing={isRefreshing}
  onRefresh={handleRefresh}
/>
```

---

# ========================

# 🔑 KEY EXTRACTOR RULE

# ========================

Use stable unique key.

### ✅ GOOD

```ts
const keyExtractor = (item: TransactionModel) => item.transactionId;
```

### ❌ BAD

```ts
const keyExtractor = (_item, index) => String(index);
```

Rule:

```txt
Never use index as key unless list is static and never reordered.
```

For fintech:

```txt
Use transactionId / notificationId / requestId.
```

---

# ========================

# 🧩 RENDER ITEM RULE

# ========================

`renderItem` must be stable.

### ✅ GOOD

```tsx
const renderItem = useCallback(
  ({ item }: ListRenderItemInfo<TransactionModel>) => {
    return (
      <TransactionListItem
        transaction={item}
        onPress={handleTransactionPress}
      />
    );
  },
  [handleTransactionPress],
);
```

### ❌ BAD

```tsx
<FlatList
  data={transactions}
  renderItem={({ item }) => (
    <TransactionListItem
      transaction={item}
      onPress={() => navigation.navigate('Detail', item)}
    />
  )}
/>
```

MUST NOT:

* create inline function per item
* do heavy formatting inside renderItem
* perform API call inside renderItem
* perform navigation/business logic directly inside item rendering

---

# ========================

# 🧠 ITEM COMPONENT MEMO RULE

# ========================

List item should be memoized.

### ✅ GOOD

```tsx
export type TransactionListItemProps = {
  transaction: TransactionModel;
  onPress: (transactionId: string) => void;
};

export const TransactionListItem = React.memo(
  ({ transaction, onPress }: TransactionListItemProps) => {
    const handlePress = useCallback(() => {
      onPress(transaction.transactionId);
    }, [onPress, transaction.transactionId]);

    return (
      <Pressable onPress={handlePress}>
        <Text>{transaction.title}</Text>
        <Text>{transaction.formattedAmount}</Text>
      </Pressable>
    );
  },
);
```

Rule:

```txt
Memo item components when list can grow or item UI is non-trivial.
```

---

# ========================

# 🧮 DATA PREPARATION RULE

# ========================

Prepare list data before rendering.

### ✅ GOOD

```ts
const transactionItems = useMemo(
  () => transactions.map(mapTransactionToListItem),
  [transactions],
);
```

### ❌ BAD

```tsx
<Text>{formatCurrency(item.amount)}</Text>
<Text>{formatDate(item.createdAt)}</Text>
```

inside every render if expensive.

Rule:

```txt
Expensive mapping/formatting should happen before render or be memoized.
```

---

# ========================

# 📏 GET ITEM LAYOUT RULE

# ========================

Use `getItemLayout` when item height is fixed.

### ✅ GOOD

```ts
const ITEM_HEIGHT = 72;

const getItemLayout = (_data: unknown, index: number) => ({
  length: ITEM_HEIGHT,
  offset: ITEM_HEIGHT * index,
  index,
});

<FlatList
  data={transactions}
  getItemLayout={getItemLayout}
/>
```

Use when:

```txt
all rows have same height
large list
scrollToIndex is used
```

Do not use incorrectly when height is dynamic.

---

# ========================

# 🪟 VIRTUALIZATION CONFIG RULE

# ========================

Tune virtualization carefully.

Common props:

```tsx
<FlatList
  initialNumToRender={10}
  maxToRenderPerBatch={10}
  updateCellsBatchingPeriod={50}
  windowSize={7}
  removeClippedSubviews={true}
/>
```

Guideline:

```txt
initialNumToRender       → enough to fill first screen
maxToRenderPerBatch      → lower = smoother, higher = faster fill
updateCellsBatchingPeriod → delay between batches
windowSize               → memory vs scroll blank risk
removeClippedSubviews    → reduce memory, test carefully on iOS
```

MUST:

* test on low-end Android device
* test fast scrolling
* tune based on item complexity

---

# ========================

# 🔄 PAGINATION RULE

# ========================

Pagination must prevent duplicate load.

### ✅ GOOD

```ts
const handleLoadMore = useCallback(() => {
  if (isLoadingMore || !hasNextPage) return;
  loadMore();
}, [isLoadingMore, hasNextPage, loadMore]);
```

MUST:

* guard `isLoadingMore`
* guard `hasNextPage`
* debounce/throttle if needed
* show footer loading
* handle retry for failed page

MUST NOT:

* trigger multiple page loads at once
* rely only on `onEndReached` without guard
* replace full list when appending page unless intended

---

# ========================

# 🔃 PULL TO REFRESH RULE

# ========================

Refresh must be explicit.

```tsx
<FlatList
  refreshing={isRefreshing}
  onRefresh={handleRefresh}
/>
```

MUST:

* reset pagination cursor/page
* avoid duplicate refresh while loading
* keep UX clear

MUST NOT:

* refresh and load more at same time without coordination

---

# ========================

# 🖼️ IMAGE RULE

# ========================

For list items with images:

MUST:

* use optimized image size
* use caching image library when needed
* avoid large remote images
* use placeholder
* avoid base64 images in list

MUST NOT:

* load full-size images in every row
* perform image transformation inside renderItem

---

# ========================

# 🧭 NAVIGATION FROM ITEM RULE

# ========================

Item press should pass minimal identifier.

### ✅ GOOD

```ts
const handleTransactionPress = useCallback((transactionId: string) => {
  navigation.navigate(RouteName.TransactionDetail, { transactionId });
}, [navigation]);
```

### ❌ BAD

```ts
navigation.navigate(RouteName.TransactionDetail, { transaction: item });
```

Rule:

```txt
Pass transactionId, not full item/raw response.
```

---

# ========================

# 💸 FINTECH LIST RULE

# ========================

For transaction/payment lists:

MUST:

* use stable transactionId as key
* show clear transaction status
* avoid showing cached balance/history as live without label
* avoid leaking sensitive account/card data
* mask account/card/phone values
* support pending/processing status

MUST NOT:

* pass full sensitive transaction payload to detail screen
* show raw backend error/status code directly
* render unmasked full card/account data

---

# ========================

# 🚫 ANTI-PATTERNS

# ========================

## 1. Inline renderItem

```tsx
renderItem={({ item }) => <Item onPress={() => onPress(item)} />}
```

## 2. Index as key

```ts
keyExtractor={(_, index) => String(index)}
```

## 3. Heavy work in renderItem

```tsx
<Text>{expensiveFormat(item)}</Text>
```

## 4. API call in item

```tsx
useEffect(() => {
  api.get(`/item/${id}`);
}, []);
```

## 5. Nested ScrollView + FlatList

```tsx
<ScrollView>
  <FlatList />
</ScrollView>
```

Use `ListHeaderComponent` / `ListFooterComponent` instead.

---

# ========================

# 🧪 TESTING CHECKLIST

# ========================

Test:

```txt
large list: 1k+ rows
low-end Android device
fast scroll
pull to refresh
load more spam
empty state
error state
image-heavy rows
navigation item press
cached data display
```

Performance checks:

```txt
JS FPS stable
UI FPS stable
no repeated unnecessary item renders
memory does not grow endlessly
no blank rows during scroll
```

---

# ========================

# 🧪 AI GENERATION RULE

# ========================

AI MUST:

* Use stable `keyExtractor`
* Use stable `renderItem` with `useCallback`
* Use `React.memo` for list item components
* Keep heavy formatting outside renderItem
* Add pagination guards
* Add empty/loading/error/footer states
* Pass only IDs through navigation
* Mask sensitive fintech data
* Avoid nested ScrollView + FlatList

AI MUST NOT:

* Use index as key for dynamic list
* Create inline functions/objects per row unnecessarily
* Call API inside renderItem/list item
* Pass raw API item through navigation
* Render full sensitive account/card data
* Put business logic in list item component
* Create `modules/<feature>` folder

---

# ========================

# 📌 SUMMARY

# ========================

Correct FlatList pattern:

```txt
Hook prepares data/events
View renders FlatList
FlatList uses stable keyExtractor/renderItem
Item is memoized
Pagination is guarded
Sensitive data is masked
```

Golden rule:

```txt
FlatList must render fast, update predictably, and never leak fintech-sensitive data.
```

This rule is mandatory for all FlatList / SectionList implementation.
