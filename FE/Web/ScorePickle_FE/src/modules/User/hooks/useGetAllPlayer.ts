import { useQuery } from '@tanstack/react-query';
import { FETCH_PLAYER } from '../constants';
import { Player } from '../models';
import api from '@src//api/api';
import { Pagination } from '@src/modules/Pagination/models';

const fetchPlayers = async (
  PageNumber?: number,
  PageSize?: number,
  isOrderbyCreateAt?: boolean
): Promise<Pagination<Player>> => {
  try {
    const response = await api.getByQueryParams('/Player/GetAllPlayer', {
      PageNumber,
      PageSize,
      isOrderbyCreateAt,
    });
    const pagination: Pagination<Player> = {
      data: response.data as Player[],
      currentPage: PageNumber ?? 1,
      pageSize: PageSize ?? 10,
      totalItems: response.totalItems ?? 0,
      totalPages: response.totalPages ?? 0,
    };
    return pagination as Pagination<Player>;
  } catch (error) {
    throw new Error('Error fetching players');
  }
};

export function useGetAllPlayers(
  PageNumber: number = 1,
  PageSize: number = 10,
  isOrderbyCreateAt: boolean = true
) {
  return useQuery<Pagination<Player>>({
    queryKey: [FETCH_PLAYER, PageNumber, PageSize, isOrderbyCreateAt],
    queryFn: () => fetchPlayers(PageNumber, PageSize, isOrderbyCreateAt),
    refetchInterval: 3000,
  });
}
