import { useMutation } from '@tanstack/react-query';
import api from '@src/api/api';
import {
  UpdateSponsorProfileRequest,
  UpdateSponsorProfileResponse,
} from '../models';

export const createSponsorProfile = async (
  id: number,
  data: UpdateSponsorProfileRequest
): Promise<UpdateSponsorProfileResponse> => {
  try {
    const response = await api.post<UpdateSponsorProfileResponse>(
      `/Sponner/CreateSponner`,
      data
    );
    return response.data;
  } catch (error) {
    throw new Error('Error updating referee data');
  }
};

export function useCreateSponsorProfile() {
  return useMutation<
    UpdateSponsorProfileResponse,
    Error,
    { id: number; data: UpdateSponsorProfileRequest }
  >({
    mutationFn: ({ id, data }) => createSponsorProfile(id, data),
  });
}
