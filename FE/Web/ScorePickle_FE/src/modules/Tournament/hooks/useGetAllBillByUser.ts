import Api from '@src/api/api';
import { Bill } from '@src/modules/Payment/models';
import { useQuery } from '@tanstack/react-query';
/**
 * Fetches all payment bills for a specific sponsor
 */
const fetchBillByUser = async (sponnerId: number): Promise<Bill[]> => {
  const response = await Api.get<Bill[]>(
    `/payment/vn-pay/GetAllBillByUserId/${sponnerId}`
  );
  return response.data as Bill[]; // Extract bills array from data property
};

/**
 * Hook to query payment bills for a specific sponsor
 */
export function useGetAllBillByUser(sponnerId: number) {
  return useQuery<Bill[], Error>({
    queryKey: ['sponsorBills', sponnerId],
    queryFn: () => fetchBillByUser(sponnerId),
    enabled: !!sponnerId, // Only run query if sponnerId is provided
    refetchInterval: 3000,
  });
}
