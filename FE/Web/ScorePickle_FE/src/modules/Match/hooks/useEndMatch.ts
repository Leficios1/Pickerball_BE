import { useMutation, useQueryClient } from '@tanstack/react-query';
import Api from '@src/api/api';
import { notification } from 'antd';
import { END_MATCH } from '../constants';

// Define the request payload interface
export interface EndMatchRequest {
  matchId: number;
  team1Score: number;
  team2Score: number;
  urlMatch?: string;
  log?: string;
}

// Define the response interface (adjust as needed based on actual API response)
export interface EndMatchResponse {
  success: boolean;
  message?: string;
}

/**
 * Sends a request to end a match with the provided scores
 * @param endMatchData The match completion data including scores
 * @returns API response
 */
export const endMatch = async (
  endMatchData: EndMatchRequest
): Promise<EndMatchResponse> => {
  const response = await Api.post<EndMatchResponse>(
    'Match/EndMatchNormalAndCompetitive',
    endMatchData
  );
  return response.data;
};

/**
 * React Query hook for ending a match with scores
 * @returns Mutation object for ending matches
 */
export function useEndMatch() {
  const queryClient = useQueryClient();

  return useMutation<EndMatchResponse, Error, { data: EndMatchRequest }>({
    mutationFn: ({ data }) => endMatch(data),
    onSuccess: () => {
      notification.success({
        message: 'Match Completed',
        description: 'The match has been completed with the final scores.',
        placement: 'topRight',
      });

      // Invalidate related queries to refetch updated data
      queryClient.invalidateQueries({ queryKey: [END_MATCH] });
      queryClient.invalidateQueries({ queryKey: ['matches'] });
      queryClient.invalidateQueries({ queryKey: ['match'] });
    },
    onError: (error) => {
      notification.error({
        message: 'Failed to Complete Match',
        description:
          error.message || 'An error occurred while completing the match.',
        placement: 'topRight',
      });
    },
  });
}
