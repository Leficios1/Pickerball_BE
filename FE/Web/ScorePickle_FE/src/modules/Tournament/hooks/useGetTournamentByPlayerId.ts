import Api from '@src/api/api';
import { Tournament } from '../models';
import { GET_ALL_TOURNAMENTS_PLAYER } from '../constants';
import { useQuery } from '@tanstack/react-query';

const fetchTournamentsByPlayer = async (
  PlayerId: number
): Promise<Tournament[]> => {
  try {
    const response = await Api.getByQueryParams(
      `/Tourament/GetTouramentByPlayerId/${PlayerId}`
    );
    const tournaments = response.data as Tournament[];

    // Lọc bỏ các tournament có status là 'Pending'
    return tournaments.filter((tournament) => tournament.status !== 'Pending');
  } catch (error) {
    throw new Error('Error fetching tournaments');
  }
};
export function useGetAllTournamentsByPlayerId(playerId: number) {
  return useQuery<Tournament[]>({
    queryKey: [GET_ALL_TOURNAMENTS_PLAYER],
    queryFn: () => fetchTournamentsByPlayer(playerId),
  });
}
