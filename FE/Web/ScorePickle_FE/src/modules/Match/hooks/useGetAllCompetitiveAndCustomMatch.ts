import { useQuery } from '@tanstack/react-query';
import { GET_ALL_MATCH_COMPE_AND_CUSTOM } from '../constants';
import { Matches } from '../models';
import api from '@src//api/api';

const fetchMatches = async (): Promise<Matches[]> => {
  try {
    const response = await api.get<Matches[]>(
      '/Match/GetAllMatchCompetitiveAndCustom'
    );
    return response.data;
  } catch (error) {
    throw new Error('Error fetching matches');
  }
};

export function useGetAllMatches() {
  return useQuery<Matches[]>({
    queryKey: [GET_ALL_MATCH_COMPE_AND_CUSTOM],
    queryFn: () => fetchMatches(),
    refetchInterval: 3000,
  });
}
