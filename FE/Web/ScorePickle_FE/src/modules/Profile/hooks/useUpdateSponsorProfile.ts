import { useMutation } from '@tanstack/react-query';
import api from '@src/api/api';
import {
  UpdateSponsorProfileRequest,
  UpdateSponsorProfileResponse,
} from '../models';

export const updateSponsorProfile = async (
  id: number,
  data: UpdateSponsorProfileRequest
): Promise<UpdateSponsorProfileResponse> => {
  try {
    const response = await api.patch<UpdateSponsorProfileResponse>(
      `/Sponner/UpdateSponner/${id}`,
      data
    );
    return response.data;
  } catch (error) {
    throw new Error('Error updating referee data');
  }
};

export function useUpdateSponsorProfile() {
  return useMutation<
    UpdateSponsorProfileResponse,
    Error,
    { id: number; data: UpdateSponsorProfileRequest }
  >({
    mutationFn: ({ id, data }) => updateSponsorProfile(id, data),
  });
}
