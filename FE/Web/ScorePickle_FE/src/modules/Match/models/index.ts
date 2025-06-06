import { User } from '@src/modules/User/models';

export interface IMatch {
  teamResponse: any;
  id: number;
  title: string;
  description: string;
  matchDate: string;
  venueId: number;
  status: MatchStatus;
  matchCategory: MatchCategory;
  matchFormat: MatchFormat;
  winScore: number;
  isPublic: boolean;
  refereeId: number;
  touramentId: number;
  team1Score?: number;
  team2Score?: number;
}

export interface Match {
  id: number;
  title: string;
  description: string;
  matchDate: string;
  venueId: number | null;
  status: MatchStatus;
  matchCategory: MatchCategory;
  matchFormat: MatchFormat;
  winScore: number;
  isPublic: boolean;
  refereeId: number | null;
  teamResponse: Team[];
}

export interface Team {
  id: number;
  name: string;
  captainId: number | null;
  matchingId: number;
  members: Member[];
}

export interface Member {
  playerDetails: any;
  id: number;
  playerId: number;
  teamId: number;
  joinedAt: string;
}

export interface MatchRequest {
  title: string;
  description: string;
  matchDate: string;
  venueId?: number | null;
  status: number;
  matchCategory: number;
  matchFormat: number | null;
  winScore: number;
  isPublic: boolean;
  roomOnwer: number;
  player1Id: number;
  player2Id?: number | null;
  player3Id?: number | null;
  player4Id?: number | null;
  refereeId?: number | null;
  tournamentId?: number | null;
}

export interface IMatchScope {
  matchId: number;
  round: number;
  note: string;
  currentHaft: number;
  team1Score: number;
  team2Score: number;
  logs: string;
}

export interface EndTournamentMatchDTO extends IMatchScope {}

export enum MatchCategory {
  Competitive = 1,
  Custom = 2,
  Tournament = 3,
}

export enum MatchStatus {
  Scheduled = 1,
  Ongoing = 2,
  Completed = 3,
  Disabled = 4,
}

export enum TournamentType {
  Single = 1,
  Team = 2,
}

export enum MatchFormat {
  SingleMale = 1,
  SingleFemale = 2,
  DoublesMale = 3,
  DoublesFemale = 4,
  DoublesMix = 5,
}

export enum MatchWinScore {
  Score11 = 11,
  Score15 = 15,
  Score21 = 21,
}

export enum MatchPrivate {
  Public = 1,
  Private = 2,
}

export enum SendRequestStatus {
  Accept = 1,
  Reject = 2,
  Pending = 3,
}

export interface MatchResponse {
  id: number;
  title: string;
  description: string;
  matchDate: string;
  venueId: number;
  status: MatchStatus;
  matchCategory: MatchCategory;
  matchFormat: MatchFormat;
  winScore: MatchWinScore;
  roomOwner: number;
  team1Score: number | null;
  team2Score: number | null;
  isPublic: boolean;
  refereeId: number | null;
  teams: any[];
}

export interface TournamentMatch {
  id: number;
  title: string;
  description: string;
  matchDate: Date;
  createAt: Date;
  venueId: number | null;
  status: MatchStatus;
  matchCategory: MatchCategory;
  matchFormat: MatchFormat;
  winScore: number;
  roomOwner: number;
  team1Score: number | null;
  team2Score: number | null;
  isPublic: boolean;
  refereeId: number | null;
  teamResponse: TournamentTeam[];
}

export interface TournamentTeam {
  id: number;
  name: string;
  captainId: number | null;
  matchingId: number;
  members: TournamentMember[];
}

export interface TournamentMember {
  id: number;
  playerId: number;
  teamId: number;
  joinedAt: string;
}

//Xử lý view list all matches by userId

export interface Matches {
  id: number;
  title: string;
  description: string;
  matchDate: Date; // ISO date string
  venueId: number | null;
  status: MatchStatus;
  matchCategory: MatchCategory;
  matchFormat: MatchFormat;
  winScore: number;
  roomOwner: number;
  team1Score: number | null;
  team2Score: number | null;
  isPublic: boolean;
  refereeId: number | null;
  teams: Team[];
}

export interface MatchInfo extends Matches {
  venueName: string | null | undefined;
  venueAddress: string | null | undefined;
  venueImage: string | null | undefined;
  player1?: User | undefined;
  player2?: User | undefined;
  player3?: User | undefined;
  player4?: User | undefined;
}

export interface MatchAndScore {
  matchId: number;
  team1Score: number | null;
  team2Score: number | null;
  winnerId: number | null;
  loserId: number | null;
  date: string; // ISO string format, có thể dùng Date nếu muốn parse
  urlVideoMatch: string | null;
  log: string | null;
  matchScoreDetails: MatchScoreDetail[] | null | undefined;
}

export interface MatchScoreDetail {
  matchScoreId: number;
  round: number;
  note: string;
  currentHaft: number;
  team1Score: number;
  team2Score: number;
  logs?: string;
}

export interface FullMatchInfo {
  score: MatchAndScore | null | undefined;
  info: MatchInfo;
}

export interface JoinMatchRequest {
  matchId: number;
  userJoinId: number;
}

export interface ExtendMatchDetail extends Matches {
  player1: User | undefined | null;
  player2: User | undefined | null;
  player3: User | undefined | null;
  player4: User | undefined | null;
}
