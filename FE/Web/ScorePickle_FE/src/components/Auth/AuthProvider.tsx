import { createContext, useState, useEffect, ReactNode } from 'react';
import {
  getLocalStorageItem,
  setLocalStorageItem,
  removeLocalStorageItem,
} from '@src/utils/localStorageUtils';
import { refreshAccessToken } from '@src/modules/User/hooks/useRefreshAccessToken'; // Đảm bảo rằng bạn đã có AuthUtils từ đoạn mã của bạn

interface AuthContextType {
  accessToken: string | null;
  refreshToken: string | null;
  refreshAuthToken: () => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [accessToken, setAccessToken] = useState<string | null>(null);
  const [refreshToken, setRefreshToken] = useState<string | null>(null);

  useEffect(() => {
    const storedAccessToken = getLocalStorageItem('token') as string | null;
    const storedRefreshToken = getLocalStorageItem('refreshToken') as
      | string
      | null;

    if (storedAccessToken) {
      setAccessToken(storedAccessToken);
    }

    if (storedRefreshToken) {
      setRefreshToken(storedRefreshToken);
    }
  }, []);

  const refreshAuthToken = async () => {
    if (!refreshToken) return;

    try {
      const response = await refreshAccessToken();
      const newAccessToken = response.tokenString;

      setAccessToken(newAccessToken);
      setLocalStorageItem('token', newAccessToken);
      setLocalStorageItem('refreshToken', response.refreshToken);
    } catch (error) {
      console.error('Error refreshing token:', error);
      logout(); // Nếu refresh thất bại, đăng xuất người dùng
    }
  };

  const logout = () => {
    removeLocalStorageItem('token');
    removeLocalStorageItem('refreshToken');
    setAccessToken(null);
    setRefreshToken(null);
  };

  return (
    <AuthContext.Provider
      value={{ accessToken, refreshToken, refreshAuthToken, logout }}
    >
      {children}
    </AuthContext.Provider>
  );
};
