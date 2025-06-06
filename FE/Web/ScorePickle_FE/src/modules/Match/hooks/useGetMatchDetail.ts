import { useQuery } from '@tanstack/react-query';
import { GET_MATCH_BY_ID, GET_MATCH_DETAILS } from '../constants';
import { ExtendMatchDetail, MatchAndScore, Matches } from '../models';
import Api from '@src/api/api';
import { fetchUserById } from '@src/modules/User/hooks/useGetUserById';

// const fetchMatchtById = async (matchId: number): Promise<Matches> => {
//   try {
//     const response = await Api.get(`/Match/${matchId}`);
//     return response.data as Matches;
//   } catch (error) {
//     throw new Error('No matches found');
//   }
// };

const fetchMatchtDetailById = async (
  matchId: number
): Promise<ExtendMatchDetail> => {
  try {
    const response = await Api.get<Matches>(`/Match/${matchId}`);
    const matches = response.data;
    const matchDetail: ExtendMatchDetail = {
      ...matches,
      player1: null,
      player2: null,
      player3: null,
      player4: null,
    };
    if (matches.teams[0].members[0]) {
      const player1 = matches.teams[0].members[0].playerId
        ? await fetchUserById(matches.teams[0].members[0].playerId)
        : null;
      matchDetail.player1 = player1 ?? null;
    }
    if (matches.teams[0].members[1]) {
      const player2 = matches.teams[0].members[1].playerId
        ? await fetchUserById(matches.teams[0].members[1].playerId)
        : null;
      matchDetail.player2 = player2 ?? null;
    }
    if (matches.teams[1].members[0]) {
      const player3 = matches.teams[1].members[0].playerId
        ? await fetchUserById(matches.teams[1].members[0].playerId)
        : null;
      matchDetail.player3 = player3 ?? null;
    }
    if (matches.teams[1].members[1]) {
      const player4 = matches.teams[1].members[1].playerId
        ? await fetchUserById(matches.teams[1].members[1].playerId)
        : null;
      matchDetail.player4 = player4 ?? null;
    }

    // matches.map(async (item) => {

    //   const player1 = item.teams[0].members[0].playerId
    //     ? await fetchUserById(item.teams[0].members[0].playerId)
    //     : null;
    //   const player2 = item.teams[0].members[1]
    //     ? await fetchUserById(item.teams[0].members[1].playerId)
    //     : null;
    //   const player3 = item.teams[1].members[0]
    //     ? await fetchUserById(item.teams[1].members[0].playerId)
    //     : null;
    //   const player4 = item.teams[1].members[1]
    //     ? await fetchUserById(item.teams[1].members[1].playerId)
    //     : null;
    //   return {
    //     ...item,
    //     player1: player1 ?? undefined,
    //     player2: player2 ?? undefined,
    //     player3: player3 ?? undefined,
    //     player4: player4 ?? undefined,
    //   };
    // })
    //);
    return matchDetail;
  } catch (error) {
    throw new Error('No matches found');
  }
};

export function useGetMatchDetail(id: number) {
  return useQuery<ExtendMatchDetail>({
    queryKey: [GET_MATCH_BY_ID, id],
    queryFn: () => fetchMatchtDetailById(id),
    refetchInterval: 2000,
  });
}

const fetchMatchDetails = async (matchId: number): Promise<MatchAndScore> => {
  try {
    const response = await Api.get<MatchAndScore>(
      `/Match/GetMatchDetails/${matchId}`
    );
    return response.data;
  } catch (error) {
    throw new Error(`Error fetching match details: ${error}`);
  }
};

/**
 * Hook to fetch and manage match details data
 *
 * @param matchId - ID of the match to fetch details for
 */
export function useGetMatchDetails(matchId: number) {
  return useQuery<MatchAndScore>({
    queryKey: [GET_MATCH_DETAILS, matchId],
    queryFn: () => fetchMatchDetails(matchId),
    enabled: !!matchId,
  });
}
