import { configureStore, combineReducers } from '@reduxjs/toolkit';
import themeReducer, { ThemeState } from './theme/themeSlice';
import authReducer, { AuthState } from './authentication/authSlide';
import userReducer, { UserState } from './user/userSlice';
import { persistReducer, persistStore, PersistConfig } from 'redux-persist';
import storage from 'redux-persist/lib/storage';

// Define the state shape
interface RootState {
  theme: ThemeState;
  auth: AuthState;
  user: UserState;
}

// Combine reducers
const rootReducer = combineReducers({
  theme: themeReducer,
  auth: authReducer,
  user: userReducer,
});

// Persist config with RootState
const persistConfig: PersistConfig<RootState> = {
  key: 'root',
  storage,
  version: 1,
  whitelist: ['auth'],
};

const persistedReducer = persistReducer(persistConfig, rootReducer);

// Configure store with persisted reducer
export const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: false,
    }),
});

// Persistor
export const persistor = persistStore(store);

// Type for RootState
export type { RootState };
