export interface CreateTournamentRegistrationPayload {
  tournamentId: number;
  playerId: number;
  isAccept?: boolean;
  partnerId?: number | null;
}

export interface CreateTournamentRegistrationResponse {
  id: number;
  tournamentId: number;
  playerId: number;
  isAccept: boolean;
  partnerId: number;
  registeredAt: Date;
}

export interface TournamentInvitation {
  id: number;
  registrationId: number;
  requesterId: number;
  requesterName: string;
  partnerId: number;
  tournamentId: number;
  tournamentName: string;
  status: InvitationStatus;
  createdAt: Date;
}

export enum InvitationStatus {
  Pending = 1,
  Accepted = 2,
  Rejected = 3,
}

export interface TournamentTeamRequestByTounrnamentAndPlayerId {
  id: number;
  tournamentId: number;
  playerId: number;
  partnerId: number;
  requestId: number;
  isApproved: TouramentregistrationStatus;
  registeredAt: Date;
}

export enum TouramentregistrationStatus {
  Pending = 1, // Da accept tu partner cho payment
  Approved = 2, // Da payment
  Rejected = 3, // Ko dong y cho tham gia giai dau
  Waiting = 4, // Cho accept tu partner
  Eliminated = 5, // Bi loai
  Request = 6, // Nhan duoc loi moi tham gia
  Winner = 7,
}

export interface GetTournamentRegistrationResponse {
  id: number;
  playerId: number;
  tournamentId: number;
  registeredAt: Date; // ISO date string
  isApproved: boolean;
  partnerId: number | null;
  requestId: number | null;
}
