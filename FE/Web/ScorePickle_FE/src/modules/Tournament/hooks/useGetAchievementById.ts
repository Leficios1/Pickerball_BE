import Api from '@src/api/api';
import { useQuery } from '@tanstack/react-query';

export interface Achievement {
  id: number;
  title: string;
  description: string;
  awardedAt: string;
}

/**
 * Fetches an achievement by its ID
 */
const fetchAchievementById = async (
  achievementId: number
): Promise<Achievement[]> => {
  const response = await Api.get<Achievement[]>(
    `/Achivement/GetAchivement/${achievementId}`
  );
  // Return the first item from the array or throw an error if no achievement found
  if (response.data.length === 0) {
    throw new Error(`Achievement with ID ${achievementId} not found`);
  }
  return response.data;
};

/**
 * Hook to query a specific achievement by ID
 */
export function useGetAchievementById(achievementId: number) {
  return useQuery<Achievement[], Error>({
    queryKey: ['achievement', achievementId],
    queryFn: () => fetchAchievementById(achievementId),
    enabled: !!achievementId, // Only run query if achievementId is provided
  });
}
