import { useQuery } from '@tanstack/react-query';
import { User } from '../models';
import Api from '../../../api/api';
import { FETCH_ALL_PLAYERS } from '../constants';

export const fetchUserNonePlayer = async (userId: number): Promise<User[]> => {
  const response = await Api.get(`/User/GetAllPlayerNotFriend/${userId}`);
  return response.data as User[];
};

export function useGetNoneUserPlayer(userId: number) {
  return useQuery<User[]>({
    queryKey: [FETCH_ALL_PLAYERS, userId],
    queryFn: () => fetchUserNonePlayer(userId),
  });
}
