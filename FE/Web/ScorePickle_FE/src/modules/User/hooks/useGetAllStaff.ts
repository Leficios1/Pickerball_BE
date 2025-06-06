import { useQuery } from '@tanstack/react-query';
import { FETCH_ALL_STAFFS } from '../constants';
import { User } from '../models';
import api from '@src//api/api';
import { Pagination } from '@src/modules/Pagination/models';

const fetchStaffs = async (
  PageNumber?: number,
  PageSize?: number,
  isOrderByCreateAt: boolean = true
): Promise<Pagination<User>> => {
  try {
    const response = await api.getByQueryParams('/User/GetAllStaff', {
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
    throw new Error('Error fetching Staffs');
  }
};

export function useGetAllStaffs(
  PageNumber: number = 1,
  PageSize: number = 10,
  isOrderByCreateAt: boolean = true
) {
  return useQuery<Pagination<User>>({
    queryKey: [FETCH_ALL_STAFFS, PageNumber, PageSize, isOrderByCreateAt],
    queryFn: () => fetchStaffs(PageNumber, PageSize, isOrderByCreateAt),
    refetchInterval: 3000,
  });
}
