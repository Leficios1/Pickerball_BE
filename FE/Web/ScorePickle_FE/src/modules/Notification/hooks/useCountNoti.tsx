import { useQuery } from '@tanstack/react-query';
import Api from '@src/api/api';
import { COUNT_NOTIFICATION } from '../constants';

/**
 * Fetches all payment bills from the VN-Pay endpoint
 */
const countNoti = async (id: number): Promise<number> => {
  const response = await Api.get<number>(`/Notification/CountNotiOfUser/${id}`);
  return response.data;
};

/**
 * Hook to query all payment bills from VN-Pay
 */
export function useCountNotification(id: number) {
  return useQuery<number, Error>({
    queryKey: [COUNT_NOTIFICATION, id],
    queryFn: () => countNoti(id),
    enabled: !!id, // Only run query if id is provided
    refetchInterval: 3000, // Refetch every 3 seconds (3000 ms)
  });
}
