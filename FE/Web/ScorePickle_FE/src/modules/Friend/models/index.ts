export interface GetFriendByUserIdResponse {
  id: number;
  user1Id: number;
  user2Id: number;
  userFriendId?: number | null;
  userFriendName?: string | null;
  userFriendAvatar?: string | null;
  status: FriendStatus;
  createdAt: Date;
  gender: string | null;
  exeprienceLevel: number | null;
}

export enum FriendStatus {
  Pending,
  Accepted,
  Blocked,
}

export interface AddFriendRequest {
  user1Id: number;
  user2Id: number;
}

export interface AddFriendResponse {
  id: number;
  user1Id: number;
  user2Id: number;
  userFriendId: number | null;
  userFriendName: string | null;
  userFriendAvatar: string | null;
  status: FriendStatus;
  createdAt: Date | null;
  gender: string | null;
  exeprienceLevel: number | null;
}
