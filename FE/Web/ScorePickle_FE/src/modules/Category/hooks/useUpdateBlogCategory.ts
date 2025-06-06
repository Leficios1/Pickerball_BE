import { useMutation } from '@tanstack/react-query';
import api from '@src/api/api';
import { message } from 'antd';
import {
  UpdateBlogCategoryPayload,
  UpdateBlogCategoryResponse,
} from '../models';

const updateBlogCategory = async (
  updatedRule: UpdateBlogCategoryPayload
): Promise<UpdateBlogCategoryResponse> => {
  try {
    const response = await api.put('/blog-categories/edit', updatedRule);
    return response.data as UpdateBlogCategoryResponse;
  } catch (error) {
    throw new Error('Error updating rule');
  }
};

export function useUpdateBlogCategory() {
  return useMutation<
    UpdateBlogCategoryResponse,
    Error,
    UpdateBlogCategoryPayload
  >({
    mutationFn: updateBlogCategory,
    onSuccess: (data) => {
      message.success(data.message);
    },
    onError: () => {
      message.error('Failed to update rule');
    },
  });
}
