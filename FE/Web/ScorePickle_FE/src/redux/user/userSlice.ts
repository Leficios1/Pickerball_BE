// src/store/userSlice.ts
import { createSlice, PayloadAction } from '@reduxjs/toolkit';

export interface UserState {
  userId: number | null;
  email: string;
  otp: any;
  isVerified: boolean;
}

const initialState: UserState = {
  userId: null,
  email: '',
  otp: null,
  isVerified: false,
};

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    setEmail: (state, action: PayloadAction<string>) => {
      state.email = action.payload;
    },
    setOtp: (state, action: PayloadAction<any>) => {
      state.otp = action.payload;
    },
    setVerified: (state, action: PayloadAction<boolean>) => {
      state.isVerified = action.payload;
    },
    setUserId: (state, action: PayloadAction<number>) => {
      state.userId = action.payload;
    },
    clearVerified: (state) => {
      state.userId = initialState.userId;
      state.email = initialState.email;
      state.otp = initialState.otp;
      state.isVerified = initialState.isVerified;
    },
  },
});

export const { setEmail, setOtp, setUserId, setVerified, clearVerified } =
  userSlice.actions;
export default userSlice.reducer;
