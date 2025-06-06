import Api from '@src/api/api';
import { useMutation } from '@tanstack/react-query';

const respondFriendRequest = async (
  user1Id: number,
  user2Id: number,
  isAccept: boolean
): Promise<void> => {
  try {
    if (isAccept)
      await Api.post(`/Friend/AcceptFriend`, {
        user1Id,
        user2Id,
      });
    else
      await Api.delete(`/Friend/RemoveFriend`, {
        user1Id,
        user2Id,
      });
  } catch (error) {
    throw new Error('Error responding to friend request');
  }
};

export function useRespondFriendRequest() {
  return useMutation<
    void,
    Error,
    { user1Id: number; user2Id: number; isAccept: boolean }
  >({
    mutationFn: ({ user1Id, user2Id, isAccept }) =>
      respondFriendRequest(user1Id, user2Id, isAccept),
  });
}
