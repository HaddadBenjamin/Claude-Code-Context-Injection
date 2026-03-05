# State Management – Redux Toolkit

## When to use what

| State type | Solution | Example |
|------------|----------|---------|
| Server / async data | React Query | Products list, user profile |
| Global UI state | Redux Toolkit | Auth session, sidebar open, theme |
| Local component state | `useState` | Modal open, form field value |
| Derived state | Computed in selector or component | `isCartEmpty = cart.items.length === 0` |
| Form state | React Hook Form | Any form |

**Never store server data in Redux.**
**Never store UI-only state in React Query.**
**Never store derived state anywhere — compute it.**

---

## Slice structure

One slice per domain. Lives in `domains/<domain>/state/`.

```typescript
// domains/auth/state/authSlice.ts
import { createSlice, type PayloadAction } from '@reduxjs/toolkit';
import type { AuthState, User } from '../types';

const initialState: AuthState = {
  user: null,
  isAuthenticated: false,
};

export const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setUser: (state, action: PayloadAction<User>) => {
      state.user = action.payload;
      state.isAuthenticated = true;
    },
    clearUser: (state) => {
      state.user = null;
      state.isAuthenticated = false;
    },
  },
});

export const { setUser, clearUser } = authSlice.actions;
export default authSlice.reducer;
```

---

## Selectors

Define typed selectors in `domains/<domain>/state/selectors.ts`.
Never access `state.domain.property` directly in components — always use selectors.

```typescript
// domains/auth/state/selectors.ts
import type { RootState } from '@webapp/store';

export const selectUser = (state: RootState) => state.auth.user;
export const selectIsAuthenticated = (state: RootState) => state.auth.isAuthenticated;

// Derived selector (memoized with createSelector when expensive)
import { createSelector } from '@reduxjs/toolkit';

export const selectUserFullName = createSelector(
  selectUser,
  (user) => user ? `${user.firstName} ${user.lastName}` : null
);
```

### ✅ DO
```typescript
const user = useAppSelector(selectUser);
```

### ❌ DON'T
```typescript
const user = useAppSelector((state) => state.auth.user); // inline selector = not reusable
```

---

## Async actions — createAsyncThunk

Use `createAsyncThunk` only for operations that need to live in Redux (auth flow, global app init).
For most data fetching, use React Query instead.

```typescript
// domains/auth/state/authThunks.ts
import { createAsyncThunk } from '@reduxjs/toolkit';
import { fetchCurrentUser } from '../api/fetchCurrentUser';
import type { User } from '../types';

export const initializeAuth = createAsyncThunk<User>(
  'auth/initialize',
  async (_, { rejectWithValue }) => {
    try {
      const token = await refreshToken(); // exchange cookie for access token
      tokenStore.set(token);
      return await fetchCurrentUser();
    } catch (error) {
      return rejectWithValue('Session expired');
    }
  }
);
```

```typescript
// In slice — handle thunk lifecycle
extraReducers: (builder) => {
  builder
    .addCase(initializeAuth.pending, (state) => {
      state.isLoading = true;
    })
    .addCase(initializeAuth.fulfilled, (state, action) => {
      state.user = action.payload;
      state.isAuthenticated = true;
      state.isLoading = false;
    })
    .addCase(initializeAuth.rejected, (state) => {
      state.isLoading = false;
      state.isAuthenticated = false;
    });
},
```

---

## Store setup

```typescript
// webapp/store/index.ts
import { configureStore } from '@reduxjs/toolkit';
import { useDispatch, useSelector } from 'react-redux';
import authReducer from '@domains/auth/state/authSlice';
import uiReducer from '@domains/ui/state/uiSlice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    ui: uiReducer,
    // add domain reducers here
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

// Typed hooks — always use these, never raw useDispatch/useSelector
export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector = useSelector.withTypes<RootState>();
```

---

## Naming conventions

| What | Convention | Example |
|------|------------|---------|
| Slice file | `<domain>Slice.ts` | `authSlice.ts` |
| Selectors file | `selectors.ts` | in `domains/auth/state/` |
| Thunks file | `<domain>Thunks.ts` | `authThunks.ts` |
| Action names | `'domain/actionName'` | `'auth/setUser'` |
| Boolean state | `is*`, `has*`, `can*` | `isAuthenticated`, `hasError` |

---

## Claude enforcement rules

- Server/fetched data stored in Redux = **Blocker**.
- Inline selector in `useAppSelector` (not extracted) = **Warning**.
- Mutable state update outside `createSlice` reducer = **Blocker**.
- Raw `useDispatch` / `useSelector` instead of typed versions = **Warning**.
- Derived state stored as Redux state = **Blocker**.
- Slice in wrong folder (not `domains/<domain>/state/`) = **Blocker**.