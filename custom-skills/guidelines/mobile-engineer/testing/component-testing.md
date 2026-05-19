========================

🧪 COMPONENT TESTING RULE (MOBILE)

========================

🎯 OBJECTIVE

Define testing rules for mobile UI components to ensure:

* Component behavior is predictable
* UI is reusable and safe
* No business logic leaks into component
* Fintech-sensitive UI is masked correctly
* Native UI components are mocked safely

Applied for:

React Native
TypeScript
Jest
React Native Testing Library
Reusable components
Native UI wrappers

⸻

========================

🧠 CORE PRINCIPLE

========================

Component test = verify UI contract

A component test should verify:

* render output
* props behavior
* callback events
* disabled/loading states
* accessibility labels
* sensitive data masking

A component test should NOT verify:

* API behavior
* business use case
* repository logic
* Redux saga/epic flow
* navigation stack behavior

Golden rule:

Component receives props and emits callbacks. Test exactly that.

⸻

========================

📁 STRUCTURE

========================

Recommended structure:

src/component/button/
primary-button.tsx
primary-button.test.tsx
src/component/input/
amount-input.tsx
amount-input.test.tsx
src/component/list-item/
transaction-list-item.tsx
transaction-list-item.test.tsx
src/component/native/pdf-view/
native-pdf-view.tsx
native-pdf-view.test.tsx

Rule:

Test file should stay close to the component file.

⸻

========================

🧰 TESTING LIBRARY RULE

========================

Use:

@testing-library/react-native
jest

Preferred queries:

getByText
getByTestId
getByA11yLabel
getByRole when available
queryByText

Avoid testing implementation details.

❌ BAD

expect(wrapper.instance().state).toEqual(...)

✅ GOOD

expect(screen.getByText('Transfer')).toBeTruthy();

⸻

========================

✅ BASIC RENDER TEST

========================

Example:

import { render, screen } from '@testing-library/react-native';
import { PrimaryButton } from './primary-button';
describe('PrimaryButton', () => {
it('renders title', () => {
render(<PrimaryButton title="Transfer" onPress={jest.fn()} />);
expect(screen.getByText('Transfer')).toBeTruthy();
});
});

Rule:

Every reusable component should have at least one render test.

⸻

========================

🖱️ CALLBACK TEST

========================

Test that component emits callback when user interacts.

import { fireEvent, render, screen } from '@testing-library/react-native';
it('calls onPress when pressed', () => {
const onPress = jest.fn();
render(<PrimaryButton title="Continue" onPress={onPress} />);
fireEvent.press(screen.getByText('Continue'));
expect(onPress).toHaveBeenCalledTimes(1);
});

Rule:

Component does not own business result. It only emits event.

⸻

========================

⛔ DISABLED / LOADING STATE TEST

========================

Component must respect disabled/loading state.

it('does not call onPress when disabled', () => {
const onPress = jest.fn();
render(
<PrimaryButton
title="Submit"
disabled
onPress={onPress}
/>,
);
fireEvent.press(screen.getByText('Submit'));
expect(onPress).not.toHaveBeenCalled();
});

For fintech submit buttons:

loading/disabled state prevents duplicate submit

⸻

========================

🧾 INPUT COMPONENT TEST

========================

Example:

import { fireEvent, render, screen } from '@testing-library/react-native';
import { AmountInput } from './amount-input';
it('emits amount change', () => {
const onChange = jest.fn();
render(
<AmountInput
value=""
onChangeText={onChange}
placeholder="Amount"
/>,
);
fireEvent.changeText(screen.getByPlaceholderText('Amount'), '100000');
expect(onChange).toHaveBeenCalledWith('100000');
});

Rule:

Input component validates UI constraints only.
Business validation belongs to domain/application.

⸻

========================

🔐 SENSITIVE DATA MASKING TEST

========================

Fintech components must mask sensitive data.

Example:

it('renders masked account number', () => {
render(
<TransactionListItem
transaction={{
transactionId: 'txn-1',
maskedAccountNo: '9704********1234',
amount: '100,000 VND',
status: 'SUCCESS',
}}
onPress={jest.fn()}
/>,
);
expect(screen.getByText('9704********1234')).toBeTruthy();
expect(screen.queryByText('9704123412341234')).toBeNull();
});

MUST test masking for:

account number
card number
phone number
identity number
email when required

⸻

========================

♿ ACCESSIBILITY TEST

========================

Components should expose accessibility labels when needed.

Example:

it('has accessibility label', () => {
render(
<PrimaryButton
title="Transfer"
accessibilityLabel="Transfer button"
onPress={jest.fn()}
/>,
);
expect(screen.getByLabelText('Transfer button')).toBeTruthy();
});

MUST:

* provide accessible labels for interactive components
* avoid relying only on icon without label
* support disabled state semantics when possible

⸻

========================

🧩 LIST ITEM TEST

========================

List item should:

* render item data
* call onPress with identifier
* not expose raw sensitive data

Example:

it('calls onPress with transactionId', () => {
const onPress = jest.fn();
render(
<TransactionListItem
transaction={{
transactionId: 'txn-123',
title: 'Transfer',
formattedAmount: '100,000 VND',
status: 'SUCCESS',
}}
onPress={onPress}
/>,
);
fireEvent.press(screen.getByText('Transfer'));
expect(onPress).toHaveBeenCalledWith('txn-123');
});

Rule:

List item emits ID, not full raw API item.

⸻

========================

🧱 NATIVE UI MOCK RULE

========================

Native UI components under component/native must be mocked in Jest.

Example:

jest.mock('./native-pdf-view', () => ({
NativePdfView: ({ filePath }: { filePath: string }) => {
return <Text testID="native-pdf-view">{filePath}</Text>;
},
}));

Rule:

Component tests should not require real native UI rendering.

⸻

========================

📸 SNAPSHOT TEST RULE

========================

Snapshot tests are allowed but limited.

Use snapshot for:

small stable design-system components
simple visual structure

Avoid snapshot for:

large screens
dynamic lists
frequently changing UI
native views

Rule:

Snapshot is support, not replacement for behavior test.

⸻

========================

🚫 WHAT NOT TO MOCK

========================

Do not mock the component under test.

Mock only dependencies:

theme provider
translation provider
native view wrapper
icon library when needed

Do not mock:

component behavior being tested
callback assertion
actual text rendering

⸻

========================

💸 FINTECH COMPONENT TEST RULE

========================

Fintech components MUST test:

masked sensitive data
status display
disabled submit state
loading state
error message rendering
pending/processing state
no raw token/OTP/PIN displayed

MUST NOT:

display full account/card data
render OTP/PIN after submission
expose sensitive value in testID/text

⸻

========================

🚫 ANTI-PATTERNS

========================

1. Testing implementation detail

❌ BAD

expect(component.state().isLoading).toBe(true);

2. API call in component test

❌ BAD

await waitFor(() => expect(apiClient.get).toHaveBeenCalled());

If API is involved, it is not a pure component test.

3. Only snapshot test

❌ BAD

expect(rendered).toMatchSnapshot();

without behavior assertions.

4. Raw sensitive value in test fixture

❌ BAD

cardNo: '9704123412341234'

Use masked or fake-safe values.

⸻

========================

🧪 AI GENERATION RULE

========================

AI MUST:

* Use React Native Testing Library
* Test render output
* Test callbacks
* Test disabled/loading states
* Test accessibility for interactive components
* Test sensitive data masking for fintech components
* Mock Native UI components
* Keep component tests free from API/business logic

AI MUST NOT:

* Test implementation details
* Call real API in component test
* Depend on real native module/native UI
* Use only snapshot tests
* Put business flow assertions in component test
* Use raw OTP/PIN/token/card number in fixtures
* Create modules/<feature> folder

⸻

========================

📌 SUMMARY

========================

Correct component testing model:

Props in
UI rendered
User event
Callback out

Golden rule:

Component test verifies UI contract, not business flow.

This rule is mandatory for all component test generation.
