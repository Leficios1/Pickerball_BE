import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { RefereeResponse } from '../models';
import { GET_REFEREE_BY_SPONSOR_ID } from '../constants';

const fetchRefereeByCode = async (code: string): Promise<RefereeResponse[]> => {
  try {
    const response = await api.getNoData(`/Refree/code/${code}`);
    return response as RefereeResponse[];
  } catch (error) {
    throw new Error('Error fetching referee data');
  }
};

export function useGetRefereeBySponsorId(code: string) {
  return useQuery<RefereeResponse[]>({
    queryKey: [GET_REFEREE_BY_SPONSOR_ID, code],
    queryFn: () => fetchRefereeByCode(code),
    refetchInterval: 3000,
  });
}
