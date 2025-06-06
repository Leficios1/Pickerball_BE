import { useQuery } from '@tanstack/react-query';
import { Sponsor } from '../models';
import Api from '../../../api/api';
import { FETCH_REFEREES } from '../constants';

export const fetchAllSponsors = async (): Promise<Sponsor[]> => {
  const response = await Api.get('/Sponner/GetAll');
  return response.data as Sponsor[];
};

export function useGetAllSponsor() {
  return useQuery<Sponsor[]>({
    queryKey: [FETCH_REFEREES],
    queryFn: fetchAllSponsors,
  });
}
