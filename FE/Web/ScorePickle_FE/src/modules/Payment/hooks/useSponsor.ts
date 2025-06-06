import { useMutation } from '@tanstack/react-query';
import Api from '@src/api/api';
import { CHECK_PAYMENT } from '../constants';
import { SponsorRequest } from '../models';

// Hàm gửi request tài trợ
export const sponsorTournament = async ({
  request,
}: {
  request: SponsorRequest;
}): Promise<string> => {
  const apiResponse = await Api.post<string>(
    `Tourament/DonateForTourament`,
    request
  );
  return apiResponse.data as string;
};

// Hook mutation
export function useSponsorTournament() {
  return useMutation<string, Error, SponsorRequest>({
    mutationKey: [CHECK_PAYMENT],
    mutationFn: (request: SponsorRequest) => sponsorTournament({ request }),
    // onSuccess, onError, onSettled,... có thể thêm nếu cần
  });
}
