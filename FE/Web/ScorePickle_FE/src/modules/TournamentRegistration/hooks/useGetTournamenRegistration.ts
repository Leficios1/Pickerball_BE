import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_TOURNAMENT_REGISTRATION } from '../constants';
import { GetTournamentRegistrationResponse } from '../models';

export const getRegistration = async (playerId: number, tournamentId) => {
  try {
    const response = await api.get(
      `/PlayerRegistration/GetByUserIdAndTournamentId/${playerId}/${tournamentId}`
    );
    return response.data as GetTournamentRegistrationResponse;
  } catch (error) {
    throw new Error('Error fetching invatations');
  }
};

export function useGetRegistration(playerId: number, tournamentId: number) {
  return useQuery({
    queryKey: [GET_TOURNAMENT_REGISTRATION, playerId, tournamentId],
    queryFn: () => getRegistration(playerId, tournamentId),
  });
}
