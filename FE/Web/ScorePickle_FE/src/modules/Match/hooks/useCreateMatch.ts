import { useMutation, useQueryClient } from '@tanstack/react-query';
import { MatchRequest, MatchResponse } from '../models';
import Api from '@src/api/api';
import { CREATE_MATCH } from '../constants';
import { message } from 'antd';

export const createMatch = async (
  matchData: MatchRequest
): Promise<MatchResponse> => {
  const response = await Api.post<MatchResponse>('Match', matchData);
  return response.data;
};

export function useCreateMatch() {
  const queryClient = useQueryClient();
  return useMutation<MatchResponse, Error, { data: MatchRequest }>({
    mutationFn: ({ data }) => createMatch(data),
    onSuccess: (data) => {
      console.log(data);
      message.success('Create match successfully');
      queryClient.invalidateQueries({ queryKey: [CREATE_MATCH] });
    },
  });
}
