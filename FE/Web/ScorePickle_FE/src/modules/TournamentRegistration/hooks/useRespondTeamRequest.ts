import { useMutation } from '@tanstack/react-query';
import Api from '@src/api/api';

const respondTeamRequest = async (
  requestId: number,
  isAccept: string
): Promise<void> => {
  try {
    await Api.post(
      `/TournamentTeamRequest/RespondToTeamRequest/${requestId}`,
      isAccept
    );
  } catch (error) {
    throw new Error('Error responding to team request');
  }
};

export function useRespondTeamRequest() {
  return useMutation<void, Error, { id: number; isAccept: string }>({
    mutationFn: ({ id, isAccept }) => respondTeamRequest(id, isAccept),
  });
}
