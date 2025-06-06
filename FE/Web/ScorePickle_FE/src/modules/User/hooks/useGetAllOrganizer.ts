import { useQuery } from '@tanstack/react-query';
import { FETCH_ALL_ORGANIZERS } from '../constants';
import { User } from '../models';
import api from '@src//api/api';
import { Pagination } from '@src/modules/Pagination/models';

const fetchOrganizers = async (
  PageNumber?: number,
  PageSize?: number,
  isOrderByCreateAt: boolean = true
): Promise<Pagination<User>> => {
  try {
    const response = await api.getByQueryParams('/User/GetAllOrganizer', {
      PageNumber,
      PageSize,
      isOrderByCreateAt,
    });
    const pagination: Pagination<User> = {
      data: response.data as User[],
      currentPage: PageNumber ?? 1,
      pageSize: PageSize ?? 10,
      totalItems: response.totalItems ?? 0,
      totalPages: response.totalPages ?? 0,
    };
    return pagination as Pagination<User>;
  } catch (error) {
    throw new Error('Error fetching Organizers');
  }
};

export function useGetAllOrganizers(
  PageNumber: number = 1,
  PageSize: number = 10,
  isOrderByCreateAt: boolean = true
) {
  return useQuery<Pagination<User>>({
    queryKey: [FETCH_ALL_ORGANIZERS, PageNumber, PageSize, isOrderByCreateAt],
    queryFn: () => fetchOrganizers(PageNumber, PageSize, isOrderByCreateAt),
    refetchInterval: 3000,
  });
}
