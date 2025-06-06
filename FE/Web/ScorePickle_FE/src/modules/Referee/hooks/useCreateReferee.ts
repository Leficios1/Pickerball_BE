import { useMutation } from '@tanstack/react-query';
import Api from '@src/api/api';
import { RegisterUserRequest, RoleFactory } from '@src/modules/User/models';

const registerRefereesUser = async (
  user: RegisterUserRequest
): Promise<void> => {
  const payload: RegisterUserRequest = {
    ...user,
    RoleId: RoleFactory.Referee,
  };
  await Api.post('/User/create-referee', payload);
};

export function useCreateReferees() {
  return useMutation({
    mutationFn: registerRefereesUser,
    onError: (error) => {
      console.error('Error create referee:', error);
    },
  });
}
