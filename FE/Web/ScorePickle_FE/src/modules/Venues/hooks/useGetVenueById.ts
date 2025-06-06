import { useQuery } from '@tanstack/react-query';
import { GET_VENUE_BY_ID } from '../constants';
import { Venue } from '../models';
import Api from '@src/api/api';

export const fetchVenueById = async (id: number): Promise<Venue> => {
  try {
    const response = await Api.get(`/Venues/GetVenues/${id}`);
    return response.data as Venue;
  } catch (error) {
    throw new Error('No tournament matches found');
  }
};

export function useVenueById(id: number) {
  return useQuery<Venue>({
    queryKey: [GET_VENUE_BY_ID, id],
    queryFn: () => fetchVenueById(id),
  });
}
