// import { useQuery } from '@tanstack/react-query';
// import { GET_LIST_MATCH_AND_SCORE } from '../constants';
// import { FullMatchInfo, MatchAndScore, Matches } from '../models';
// import Api from '@src/api/api';
// import { fetchVenueById } from '@src/modules/Venues/hooks/useGetVenueById';
// import { fetchUserById } from '@src/modules/User/hooks/useGetUserById';

// const fetchMatchDetail = async (id: number): Promise<MatchAndScore> => {
//   try {
//     const response = await Api.get<MatchAndScore>(
//       `/Match/GetMatchDetails/${id}`
//     );
//     return response.data;
//   } catch (error) {
//     throw new Error('No tournament matches found');
//   }
// };

// const fetchMatchByUserId = async (id: number): Promise<FullMatchInfo[]> => {
//   try {
//     const response = await Api.get<Matches[]>(`/Match/user/room/${id}`);
//     const matches = response.data;
//     const matchesInfo = await Promise.all(
//       matches.map(async (item) => {
//         const venue =
//           item.venueId !== null ? await fetchVenueById(item.venueId) : null;

//         const player1 = item.teams[0].members[0].playerId
//           ? await fetchUserById(item.teams[0].members[0].playerId)
//           : null;
//         const player2 = item.teams[0].members[1]
//           ? await fetchUserById(item.teams[0].members[1].playerId)
//           : null;
//         const player3 = item.teams[1].members[0]
//           ? await fetchUserById(item.teams[1].members[0].playerId)
//           : null;
//         const player4 = item.teams[1].members[1]
//           ? await fetchUserById(item.teams[1].members[1].playerId)
//           : null;
//         return {
//           ...item,
//           venueName: venue?.name,
//           venueAddress: venue?.address,
//           venueImage: venue?.urlImage,
//           player1: player1 ?? undefined,
//           player2: player2 ?? undefined,
//           player3: player3 ?? undefined,
//           player4: player4 ?? undefined,
//         };
//       })
//     );
//     const fullInfo: FullMatchInfo[] = await Promise.all(
//       matchesInfo.map(async (item) => {
//         const score = item.id !== null ? await fetchMatchDetail(item.id) : null;
//         return {
//           info: item,
//           score,
//         };
//       })
//     );
//     return fullInfo;
//   } catch (error) {
//     throw new Error('No tournament matches found');
//   }
// };

// export function useGetListMatchAndScore(id: number) {
//   return useQuery<FullMatchInfo[]>({
//     queryKey: [GET_LIST_MATCH_AND_SCORE, id],
//     queryFn: () => fetchMatchByUserId(id),
//   });
// }
import { useEffect, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { FullMatchInfo, MatchAndScore, Matches } from '../models';
import Api from '@src/api/api';
import { fetchVenueById } from '@src/modules/Venues/hooks/useGetVenueById';
import { fetchUserById } from '@src/modules/User/hooks/useGetUserById';
import { QueryClient } from '@tanstack/react-query';

const fetchMatchDetail = async (id: number): Promise<MatchAndScore> => {
  const { data } = await Api.get<MatchAndScore>(`/Match/GetMatchDetails/${id}`);
  return data;
};

// Hàm hook mới không prefetch và không cache
export function useGetListMatchAndScore(userId: number) {
  // 1. Fetch danh sách matches cơ bản
  const matchesQuery = useQuery<Matches[]>({
    queryKey: ['GET_LIST_MATCH_AND_SCORE', userId],
    queryFn: () =>
      Api.get<Matches[]>(`/Match/user/room/${userId}`).then((res) => res.data),
    staleTime: 0, // Tắt cache (không sử dụng staleTime)
  });

  // 2. Build FullMatchInfo từ data trả về mà không sử dụng cache
  const [data, setData] = useState<FullMatchInfo[]>([]);

  useEffect(() => {
    if (!matchesQuery.data) {
      setData([]);
      return;
    }

    const buildFullMatchInfo = async (
      match: Matches
    ): Promise<FullMatchInfo> => {
      // Resolve venue
      const venue = match.venueId
        ? await fetchVenueById(match.venueId)
        : undefined;

      // Resolve players
      const getPlayerFromApi = async (id?: number) =>
        id ? await fetchUserById(id) : undefined;
      const p1 = await getPlayerFromApi(match.teams[0].members[0]?.playerId);
      const p2 = await getPlayerFromApi(match.teams[0].members[1]?.playerId);
      const p3 = await getPlayerFromApi(match.teams[1].members[0]?.playerId);
      const p4 = await getPlayerFromApi(match.teams[1].members[1]?.playerId);

      // Resolve score
      const score = match.id ? await fetchMatchDetail(match.id) : null;

      return {
        info: {
          ...match,
          venueName: venue?.name,
          venueAddress: venue?.address,
          venueImage: venue?.urlImage,
          player1: p1,
          player2: p2,
          player3: p3,
          player4: p4,
        },
        score,
      };
    };

    Promise.all(matchesQuery.data.map(buildFullMatchInfo)).then(setData);
  }, [matchesQuery.data]);

  // 3. Trả về cả trạng thái và data đã enrich
  return {
    ...matchesQuery,
    data,
  } as {
    data: FullMatchInfo[];
    isLoading: boolean;
    isError: boolean;
    error: Error | null;
  };
}

export async function prefetchListMatchAndScore(userId: number) {
  const queryClient = new QueryClient();
  const matchesRes = await Api.get<Matches[]>(`/Match/user/room/${userId}`);
  const matches = matchesRes.data;

  // Đặt vào cache danh sách match
  await queryClient.setQueryData(['GET_LIST_MATCH_AND_SCORE', userId], matches);

  // Prefetch phụ
  await Promise.all(
    matches.map(async (match) => {
      if (match.venueId) {
        await queryClient.prefetchQuery({
          queryKey: ['venue', match.venueId],
          queryFn: () => fetchVenueById(match.venueId!),
          staleTime: 10 * 60 * 1000,
        });
      }

      match.teams.forEach((team) =>
        team.members.forEach((member) => {
          const pid = member.playerId;
          if (pid) {
            queryClient.prefetchQuery({
              queryKey: ['player', pid],
              queryFn: () => fetchUserById(pid),
              staleTime: 10 * 60 * 1000,
            });
          }
        })
      );

      if (match.id) {
        await queryClient.prefetchQuery({
          queryKey: ['matchDetail', match.id],
          queryFn: () => fetchMatchDetail(match.id),
          staleTime: 5 * 60 * 1000,
        });
      }
    })
  );
}
