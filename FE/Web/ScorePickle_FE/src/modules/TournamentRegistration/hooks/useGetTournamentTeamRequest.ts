import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_TOURNAMENT_TEAM_REQUEST_BY_ID } from '../constants';
import { TournamentInvitation } from '../models';

const fetchTournamentTeamRequestByPlayerId = async (id: number) => {
  try {
    const response = await api.get(
      `/TournamentTeamRequest/GetTeamRequestByReceiverUser/${id}`
    );
    return response.data as TournamentInvitation[];
  } catch (error) {
    throw new Error('Error fetching invatations');
  }
};

export function useGetTournamentTeamRequestByPlayerId(id: number) {
  return useQuery({
    queryKey: [GET_TOURNAMENT_TEAM_REQUEST_BY_ID, id],
    queryFn: () => fetchTournamentTeamRequestByPlayerId(id),
    refetchInterval: 1000,
  });
}
