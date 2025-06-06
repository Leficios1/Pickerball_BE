import { useMutation } from '@tanstack/react-query';
import api from '@src/api/api';
import { AddFriendRequest } from '../models';
import { message } from 'antd';

export const removeFriend = async (
  data: AddFriendRequest
): Promise<boolean> => {
  try {
    const response = await api.delete(`/Friend/RemoveFriend`, data);
    message.info(response.message);
    return response.data as boolean;
  } catch (error) {
    throw new Error('Error unfriend');
  }
};

export function useRemoveFriend() {
  return useMutation<boolean, Error, { data: AddFriendRequest }>({
    mutationFn: ({ data }) => removeFriend(data),
    onSuccess: () => {},
    onError: () => {
      message.error('Failed to unfriend');
    },
  });
}
