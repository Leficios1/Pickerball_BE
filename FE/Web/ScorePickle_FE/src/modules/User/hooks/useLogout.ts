import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { removeLocalStorageItem } from '@src/utils/localStorageUtils';
import { PATH_AUTH } from '@src/constants';
import { useDispatch } from 'react-redux';
import { clearAuth } from '@src/redux/authentication/authSlide';

const useLogout = () => {
  const [isLoggingOut, setIsLoggingOut] = useState(false);
  const navigate = useNavigate();
  const dispatch = useDispatch();

  const logout = async () => {
    setIsLoggingOut(true);

    try {
      // Giả sử bạn đang lưu token trong localStorage hoặc sessionStorage
      removeLocalStorageItem('token');
      removeLocalStorageItem('refreshToken');
      dispatch(clearAuth());

      // Thực hiện điều hướng sau khi đăng xuất
      navigate(PATH_AUTH.signin);
    } catch (error) {
      console.error('Logout failed', error);
    } finally {
      setIsLoggingOut(false);
    }
  };

  return { logout, isLoggingOut };
};

export default useLogout;
