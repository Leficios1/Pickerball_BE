import { useMutation, useQueryClient } from '@tanstack/react-query';
import { JOIN_MATCH } from '../constants';
import { JoinMatchRequest } from '../models';
import Api from '@src/api/api';
import { message } from 'antd';

const joinMatch = async (data: JoinMatchRequest): Promise<boolean> => {
  try {
    const response = await Api.post<boolean>(`/Match/JoinMatch`, data);
    return response.data;
  } catch (error) {
    throw new Error('Cannot join this match. Some error occured.');
  }
};

export function useJoinMatch() {
  //   return useQuery<boolean>({
  //     queryKey: [GET_MATCH_BY_USER_ID, payload],
  //     queryFn: () => joinMatch(payload),
  //   });
  const queryClient = useQueryClient();
  return useMutation<boolean, Error, { data: JoinMatchRequest }>({
    mutationFn: ({ data }) => joinMatch(data),
    onSuccess: (data) => {
      if (data) message.success('Join match successfully');
      else message.error('Join match failed');
      queryClient.invalidateQueries({ queryKey: [JOIN_MATCH] });
    },
    onError: () => {
      message.info('You joined this match');
    },
  });
}
