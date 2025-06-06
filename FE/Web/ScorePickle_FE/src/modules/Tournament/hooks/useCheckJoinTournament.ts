import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_TOURNAMENT_BY_USER_ID_AND_TOURNAMENT_ID } from '../constants';
import { PlayerTournament } from '../models';

export const fetchTournamentStatusByPlayerIdAndTournamentId = async (
  playerId: number,
  tournamentId
) => {
  try {
    const response = await api.get(
      `/Tourament/CheckJoinTouramentOrNot/${playerId}/${tournamentId}`
    );
    return response.data as PlayerTournament;
  } catch (error) {
    throw new Error('Error fetching invatations');
  }
};

export function useCheckJoinTournament(playerId: number, tournamentId) {
  return useQuery({
    queryKey: [
      GET_TOURNAMENT_BY_USER_ID_AND_TOURNAMENT_ID,
      playerId,
      tournamentId,
    ],
    queryFn: () =>
      fetchTournamentStatusByPlayerIdAndTournamentId(playerId, tournamentId),
  });
}
