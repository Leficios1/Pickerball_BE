import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_TOP_PLAYER } from '../constants';
import { TopPlayer } from '../models';

const getTopPlayer = async (): Promise<TopPlayer[]> => {
  try {
    const response = await api.get(`/Ranking/LeaderBoard`);
    return response.data as TopPlayer[];
  } catch (error) {
    throw new Error('Error fetching leader board');
  }
};

export function useGetTopPlayer() {
  return useQuery<TopPlayer[]>({
    queryKey: [GET_TOP_PLAYER],
    queryFn: () => getTopPlayer(),
  });
}
