import { useQuery } from '@tanstack/react-query';
import { GET_MATCH_BY_USER_ID } from '../constants';
import { Matches, MatchInfo } from '../models';
import Api from '@src/api/api';
import { fetchVenueById } from '@src/modules/Venues/hooks/useGetVenueById';

const fetchMatchtByUserId = async (id: number): Promise<MatchInfo[]> => {
  try {
    const response = await Api.get<Matches[]>(`/Match/user/room/${id}`);
    const matches = response.data;
    const fullInfo = await Promise.all(
      matches.map(async (item) => {
        const venue =
          item.venueId !== null ? await fetchVenueById(item.venueId) : null;
        return {
          ...item,
          venueName: venue?.name,
          venueAddress: venue?.address,
          venueImage: venue?.urlImage,
        };
      })
    );
    return fullInfo;
  } catch (error) {
    throw new Error('No tournament matches found');
  }
};

export function useGetMatchByUserId(id: number) {
  return useQuery<MatchInfo[]>({
    queryKey: [GET_MATCH_BY_USER_ID, id],
    queryFn: () => fetchMatchtByUserId(id),
  });
}
