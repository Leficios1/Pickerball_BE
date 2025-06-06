import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_FRIEND_BY_ID } from '../constants';
import { GetFriendByUserIdResponse } from '../models';

const getFriendById = async (
  userId: number,
  Gender?: string,
  MinLevel?: number,
  Maxlevel?: number
) => {
  try {
    const response = await api.getByQueryParams(`/Friend/GetFriend/${userId}`, {
      params: {
        Gender,
        MinLevel,
        Maxlevel,
      },
    });
    const friends = response.data as GetFriendByUserIdResponse[];
    const filteredFriends = friends.filter((friend) => {
      const isGenderValid = !Gender || friend.gender === Gender;
      return isGenderValid;
    });

    return filteredFriends;
  } catch (error) {
    throw new Error('Error fetching friend by ID');
  }
};

export function useGetFriendByUserId(
  id: number,
  Gender?: string,
  MinLevel?: number,
  Maxlevel?: number
) {
  return useQuery<GetFriendByUserIdResponse[]>({
    queryKey: [GET_FRIEND_BY_ID, id],
    //queryFn: () => getFriendById(id),
    queryFn: () => getFriendById(id, Gender, MinLevel, Maxlevel),
  });
}
