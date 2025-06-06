import { useMutation } from '@tanstack/react-query';
import api from '@src/api/api';
import { UpdateProfile } from '../models';
import { User } from '@src/modules/User/models';

export const updateProfile = async (
  id: number,
  data: UpdateProfile
): Promise<User> => {
  try {
    const response = await api.patch<User>(
      `/User/UpdateUserWithUserDetails/${id}`,
      data
    );
    return response.data;
  } catch (error) {
    throw new Error('Error updating referee data');
  }
};

export function useUpdateProfile() {
  return useMutation<User, Error, { id: number; data: UpdateProfile }>({
    mutationFn: ({ id, data }) => updateProfile(id, data),
  });
}
