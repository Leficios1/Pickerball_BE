import { useQuery } from '@tanstack/react-query';
import { GET_TOURNAMENT_MATCH_BY_ID } from '../constants';
import { Match, TournamentMatch } from '../models';
import Api from '@src/api/api';

const fetchTournamenMatchtById = async (id: number): Promise<Match[]> => {
  try {
    const response = await Api.get(`/Match/GetMatchByTouramentId/${id}`);
    return response.data as Match[];
  } catch (error) {
    throw new Error('No tournament matches found');
  }
};

export function useGetMatchByTournamentId(id: number) {
  return useQuery<Match[]>({
    queryKey: [GET_TOURNAMENT_MATCH_BY_ID, id],
    queryFn: () => fetchTournamenMatchtById(id),
  });
}

const fetchMatchtByTournamenId = async (
  id: number
): Promise<TournamentMatch[]> => {
  try {
    const response = await Api.get(`/Match/GetMatchByTouramentId/${id}`);
    return response.data as TournamentMatch[];
  } catch (error) {
    throw new Error('No tournament matches found');
  }
};

export function useGetAllMatchByTournamentId(id: number) {
  return useQuery<TournamentMatch[]>({
    queryKey: [GET_TOURNAMENT_MATCH_BY_ID, id],
    queryFn: () => fetchMatchtByTournamenId(id),
  });
}
