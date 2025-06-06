import { useQuery } from '@tanstack/react-query';
import Api from '@src/api/api';
import { GET_PAYMENT_URL } from '../constants';

/**
 * Fetches all payment bills from the VN-Pay endpoint
 */
export const getPaymentUrl = async (
  userId: number,
  registrationId: number
): Promise<string> => {
  const response = await Api.get<string>(
    `/payment/vn-pay/${userId}/1/${registrationId}`
  );
  return response.data;
};

/**
 * Hook to query all payment bills from VN-Pay
 */
export function useGetPaymentUrl(userId: number, registrationId: number) {
  return useQuery<string, Error>({
    queryKey: [GET_PAYMENT_URL],
    queryFn: () => getPaymentUrl(userId, registrationId),
    enabled: false, // Initially, don't run the query
  });
}
