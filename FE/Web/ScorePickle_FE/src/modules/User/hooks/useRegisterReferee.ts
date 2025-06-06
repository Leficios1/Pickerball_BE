import { useMutation } from '@tanstack/react-query';
import Api from '@src/api/api';
import { RefereeResponse, RegisterUserRequest, RoleFactory } from '../models';
import { message } from 'antd';

const registerReferees = async (
  user: RegisterUserRequest
): Promise<RefereeResponse> => {
  const payload: RegisterUserRequest = {
    ...user,
    RoleId: RoleFactory.Referee,
  };
  const response = await Api.post('/User/create-referee', payload);
  if (response.statusCode !== 200) {
    message.info(response.message);
  }
  return response.data as RefereeResponse;
};

export function useRegisterReferees() {
  return useMutation({
    mutationFn: registerReferees,
    onError: (error) => {
      console.error('Error registering:', error);
    },
  });
}
