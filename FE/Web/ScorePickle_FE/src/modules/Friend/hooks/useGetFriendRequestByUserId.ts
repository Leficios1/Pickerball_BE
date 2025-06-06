import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_FRIEND_BY_ID } from '../constants';
import { GetFriendByUserIdResponse } from '../models';

const getFriendRequestById = async (userId: number) => {
  try {
    const response = await api.getByQueryParams(
      `/Friend/GetFriendRequest/${userId}`
    );
    return response.data as GetFriendByUserIdResponse[];
  } catch (error) {
    throw new Error('Error fetching friend request by ID');
  }
};

export function useGetFriendRequestByUserId(id: number) {
  return useQuery<GetFriendByUserIdResponse[]>({
    queryKey: [GET_FRIEND_BY_ID, id],
    queryFn: () => getFriendRequestById(id),
    refetchInterval: 3000,
  });
}
