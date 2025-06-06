import { useQuery } from '@tanstack/react-query';
import api from '@src/api/api';
import { GET_INVITATION } from '../constants';
import { NotificationResponse, Notification } from '../models';
import { fetchUserById } from '@src/modules/User/hooks/useGetUserById';

/**
 * Lấy danh sách notification type 3 hoặc 4
 * rồi enrich thêm referenceName từ API GetUserById
 */
const fetchTournamentTeamRequestByPlayerId = async (
  userId: number
): Promise<Notification[]> => {
  // 1) Lấy mảng NotificationResponse
  const resp = await api.get<NotificationResponse[]>(
    `/Notification/getNotificationByUserId/${userId}`
  );
  const filtered = resp.data.filter((item) => item.type === 4);

  // 2) Với mỗi item, gọi API lấy User để pull tên
  const enriched = await Promise.all(
    filtered.map(async (item) => {
      const user = await fetchUserById(item.referenceId);
      return {
        ...item,
        referenceName:
          user.firstName ?? '' + !!user.secondName ?? '' + user.lastName ?? '',
      };
    })
  );

  return enriched;
};

export function useGetTournamentTeamRequestNotification(id: number) {
  return useQuery<Notification[]>({
    queryKey: [GET_INVITATION, id],
    queryFn: () => fetchTournamentTeamRequestByPlayerId(id),
  });
}
