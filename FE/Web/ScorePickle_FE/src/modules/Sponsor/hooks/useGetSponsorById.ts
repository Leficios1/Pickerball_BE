import { useQuery } from '@tanstack/react-query';
import Api from '@src/api/api';
import { UpdateSponsorProfileResponse } from '@src/modules/Profile/models';
import { GET_SPONSOR_BY_ID } from '../constants';

const getSponsorById = async (
  sponsorId: number
): Promise<UpdateSponsorProfileResponse> => {
  try {
    const response = await Api.get(`/Sponner/GetById/${sponsorId}`);
    return response.data as UpdateSponsorProfileResponse;
  } catch (error) {
    throw new Error('Error fetching matches by referee ID');
  }
};

export function useGetSponsorById(sponsorId: number) {
  return useQuery<UpdateSponsorProfileResponse>({
    queryKey: [GET_SPONSOR_BY_ID, sponsorId],
    queryFn: () => getSponsorById(sponsorId),
    enabled: !!sponsorId,
    refetchInterval: 3000, // Optional: keep if you want auto-polling
  });
}
