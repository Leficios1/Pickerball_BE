import Api from '../../../api/api';
import { GetNewAccessToken } from '../models';

// Lấy accessToken mới từ refreshToken
export const refreshAccessToken = async (): Promise<GetNewAccessToken> => {
  const refreshToken = localStorage.getItem('refreshToken');

  try {
    const response = await Api.post<GetNewAccessToken>('Auth/refresh-token', {
      refreshToken,
    });
    const data: GetNewAccessToken = response.data as GetNewAccessToken;
    return data;
  } catch (error) {
    console.error('Failed to refresh access token', error);
    return { tokenString: '', refreshToken: '' };
  }
};
