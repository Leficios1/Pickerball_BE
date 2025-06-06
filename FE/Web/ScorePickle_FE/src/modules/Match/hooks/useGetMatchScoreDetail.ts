import { useQuery } from '@tanstack/react-query';
import { GET_MATCH_SCORE_BY_ID } from '../constants';
import { MatchAndScore } from '../models';
import Api from '@src/api/api';

const fetchMatchtScoreDetailById = async (
  matchId: number
): Promise<MatchAndScore> => {
  try {
    const response = await Api.get<MatchAndScore>(
      `/Match/GetMatchDetails/${matchId}`
    );
    return response.data;
  } catch (error) {
    throw new Error('Not found match score detail');
  }
};

export function useGetMatchDetail(id: number) {
  return useQuery<MatchAndScore>({
    queryKey: [GET_MATCH_SCORE_BY_ID, id],
    queryFn: () => fetchMatchtScoreDetailById(id),
  });
}
