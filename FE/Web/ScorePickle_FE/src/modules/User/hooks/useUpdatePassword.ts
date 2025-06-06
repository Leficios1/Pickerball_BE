import { useMutation } from '@tanstack/react-query';
import api from '@src/api/api';
import { CheckPasswordRequest, UpdatePasswordRequest } from '../models';
import { message } from 'antd';

const updatePassword = async (
  request: UpdatePasswordRequest
): Promise<boolean> => {
  try {
    const response = await api.post(`/Auth/UpdatePassword/`, request);
    return response.data as boolean;
  } catch (error) {
    throw new Error('Error updating password');
  }
};

export function useUpdatePassword() {
  return useMutation<boolean, Error, { userId: number; newPassword: string }>({
    mutationFn: ({ userId, newPassword }) =>
      updatePassword({ userId, newPassword }),
    onSuccess: (data): void => {
      if (data) {
        message.success('Update Password successfully');
      }
    },
    onError: (data): void => {
      if (data) {
        message.error(data.message);
      }
    },
  });
}

const checkPassword = async (
  request: CheckPasswordRequest
): Promise<boolean> => {
  try {
    const response = await api.get(
      `/Auth/CheckPassword/${request.userId}/${request.oldPassword}`
    );
    return response.data as boolean;
  } catch (error) {
    throw new Error('Please check your old password');
  }
};

export function useCheckPassword() {
  return useMutation<boolean, Error, { userId: number; oldPassword: string }>({
    mutationFn: ({ userId, oldPassword }) =>
      checkPassword({ userId, oldPassword }),
    onSuccess: (data): void => {
      if (!data) {
        message.error('Your old password is wrong');
      }
    },
    onError: (data): void => {
      if (data) {
        message.error(data.message);
      }
    },
  });
}
