import { useMutation } from '@tanstack/react-query';
import api from '@src/api/api';
import { AddFriendRequest, AddFriendResponse } from '../models';
import { message } from 'antd';

export const addFriend = async (
  data: AddFriendRequest
): Promise<AddFriendResponse> => {
  try {
    const response = await api.post(`/Friend/AddFriend/`, data);
    message.info(response.message);
    return response.data as AddFriendResponse;
  } catch (error) {
    throw new Error('Error add friend');
  }
};

export function useAddFriend() {
  return useMutation<AddFriendResponse, Error, { data: AddFriendRequest }>({
    mutationFn: ({ data }) => addFriend(data),
    // onSuccess: (data) => {
    //   if (data.status === FriendStatus.Pending)
    //     message.success('Send friend request successfully');
    //   if (data.status === FriendStatus.Accepted)
    //     message.success('You and ' + data.userFriendName + ' are friends ');
    //   if (data.status === FriendStatus.Blocked)
    //     message.success('You request was rejected');
    // },
  });
}
