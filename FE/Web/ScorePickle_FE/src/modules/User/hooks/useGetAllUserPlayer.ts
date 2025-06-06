import { useQuery } from '@tanstack/react-query';
import { User } from '../models';
import Api from '../../../api/api';
import { FETCH_ALL_PLAYERS } from '../constants';

export const fetchAllUserPlayer = async (): Promise<User[]> => {
  const response = await Api.get('/User/GetAllPlayer');
  return response.data as User[];
};

export function useGetAllUserPlayer() {
  return useQuery<User[]>({
    queryKey: [FETCH_ALL_PLAYERS],
    queryFn: fetchAllUserPlayer,
  });
}
