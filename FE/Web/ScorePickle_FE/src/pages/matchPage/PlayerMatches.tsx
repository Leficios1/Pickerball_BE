// import {
//   MatchCategory,
//   Matches,
//   MatchFormat,
//   MatchStatus,
// } from '@src/modules/Match/models';
//import MatchDetail from './MatchDetail';
// import { useGetMatchByUserId } from '@src/modules/Match/hooks/useGetMatchByUserId';
// import { RootState } from '@src/redux/store';
// import { useSelector } from 'react-redux';

export default function PlayerMatchesPage() {
  //const user = useSelector((state: RootState) => state.auth.user);
  //const { data: matchList } = useGetMatchByUserId(user?.id ?? 0);
  //const { data, isLoading, error } = useGetMatchByUserId((matchList ?? [])[21]?.id ?? 0);

  //   if (isLoading) return <div>Loading…</div>;
  //   if (error || !data) return <div>Match not found</div>;
  // const sampleMatch: Matches = {
  //   id: 52,
  //   title: 'qư',
  //   description: 'qew',
  //   matchDate: new Date('2025-04-20T16:39:03.777'),
  //   venueId: 1,
  //   status: MatchStatus.Ongoing,
  //   matchCategory: MatchCategory.Custom,
  //   matchFormat: MatchFormat.DoublesMix,
  //   winScore: 11,
  //   roomOwner: 1,
  //   team1Score: null,
  //   team2Score: null,
  //   isPublic: true,
  //   refereeId: 1,
  //   teams: [
  //     {
  //       id: 83,
  //       name: 'Team 1',
  //       captainId: 1,
  //       matchingId: 52,
  //       members: [
  //         {
  //           playerDetails: null,
  //           id: 75,
  //           playerId: 1,
  //           teamId: 83,
  //           joinedAt: '2025-04-20T16:41:20.5845214',
  //         },
  //         {
  //           playerDetails: null,
  //           id: 76,
  //           playerId: 6,
  //           teamId: 83,
  //           joinedAt: '2025-04-20T16:41:20.7917335',
  //         },
  //       ],
  //     },
  //     {
  //       id: 84,
  //       name: 'Team 2',
  //       captainId: 6,
  //       matchingId: 52,
  //       members: [
  //         {
  //           playerDetails: null,
  //           id: 77,
  //           playerId: 10,
  //           teamId: 84,
  //           joinedAt: '2025-04-20T16:41:20.9839373',
  //         },
  //         {
  //           playerDetails: null,
  //           id: 78,
  //           playerId: 7,
  //           teamId: 84,
  //           joinedAt: '2025-04-20T16:41:21.176351',
  //         },
  //       ],
  //     },
  //   ],
  // };
  //return <MatchDetail />;

  return <div>Player Matches Page</div>;
}
