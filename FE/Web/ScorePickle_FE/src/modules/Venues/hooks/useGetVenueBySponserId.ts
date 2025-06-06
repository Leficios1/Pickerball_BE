import { useQuery } from '@tanstack/react-query';
import Api from '@src/api/api';
import { Venue } from '../models';
import { GET_VENUE_BY_ID } from '../constants';

const fetchVenueBySponserId = async (id: number): Promise<Venue[]> => {
  const response = await Api.get<Venue[]>(`/Venues/GetVenueSponner/${id}`);
  return response.data;
};

export function useGetVenueBySponserId(id: number) {
  return useQuery<Venue[]>({
    queryKey: [GET_VENUE_BY_ID, id],
    queryFn: () => fetchVenueBySponserId(id),
  });
}
