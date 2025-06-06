import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_TOURNAMENT_TEAM_REQUEST_BY_USER_ID_AND_TOURNAMENT_ID } from '../constants';
import { TournamentTeamRequestByTounrnamentAndPlayerId } from '../models';

const fetchTournamentTeamRequestByPlayerIdAndTournamentId = async (
  playerId: number,
  tournamentId
) => {
  try {
    const response = await api.get(
      `/TournamentTeamRequest/GetTeamRequestByUserId/${playerId}/${tournamentId}`
    );
    return response.data as TournamentTeamRequestByTounrnamentAndPlayerId;
  } catch (error) {
    throw new Error('Error fetching invatations');
  }
};

export function useGetTournamentTeamRequestByPlayerIdAndTournamentId(
  playerId: number,
  tournamentId
) {
  return useQuery({
    queryKey: [
      GET_TOURNAMENT_TEAM_REQUEST_BY_USER_ID_AND_TOURNAMENT_ID,
      playerId,
      tournamentId,
    ],
    queryFn: () =>
      fetchTournamentTeamRequestByPlayerIdAndTournamentId(
        playerId,
        tournamentId
      ),
  });
}
