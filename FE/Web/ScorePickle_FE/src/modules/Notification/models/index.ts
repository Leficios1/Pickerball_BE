export interface NotificationResponse {
  id: number;
  message: string;
  createdAt: Date;
  isRead: boolean;
  type: NotificationType;
  referenceId: number;
  bonusId: string | null;
  redirectUrl: string;
  extraInfo: string;
}

export interface Notification extends NotificationResponse {
  referenceName: string;
}

export enum NotificationType {
  FriendRequest = 1,
  MatchRequest = 2,
  TournamentTeamRequest = 3,
  AcceptTournamentTeamRequest = 4,
  AcceptMatchRequest = 5,
  Other = 6,
}
