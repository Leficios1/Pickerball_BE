import type React from 'react';
import { Form, Input, Button } from 'antd';
import 'antd/dist/reset.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import {
  useCheckPassword,
  useUpdatePassword,
} from '@src/modules/User/hooks/useUpdatePassword';
import { useState } from 'react';
import { EyeInvisibleOutlined, EyeOutlined } from '@ant-design/icons';

const UpdatePassword: React.FC = () => {
  const user = useSelector((state: RootState) => state.auth.user);
  const { mutate: updatePassword } = useUpdatePassword();
  const { mutate: checkPassword } = useCheckPassword();
  //const passwordRegex = /^(?=.*[A-Z])(?=.*\W).{8,}$/;

  const passwordRegexUpperCase = /[A-Z]/; // Kiểm tra ít nhất 1 ký tự hoa
  const passwordRegexSpecialChar = /\W/; // Kiểm tra ít nhất 1 ký tự đặc biệt
  const passwordMinLength = /.{8,}/; // Kiểm tra độ dài tối thiểu 8 ký tự

  const [form] = Form.useForm();
  const [oldPasswordVisible, setOldPasswordVisible] = useState(false);
  const [newPasswordVisible, setNewPasswordVisible] = useState(false);
  const [confirmPasswordVisible, setConfirmPasswordVisible] = useState(false);

  const onFinish = (values) => {
    handleUpdatePassword(values);
  };

  const handleUpdatePassword = async (values) => {
    const payload = {
      userId: user?.id ?? 0,
      oldPassword: values.oldPassword,
    };

    checkPassword(payload, {
      onSuccess: (isValid) => {
        if (!isValid) {
          // sai mật khẩu cũ ⇒ dừng ngay, không gọi update
          return;
        }
        // đúng rồi thì mới update mật khẩu mới
        updatePassword({
          userId: payload.userId,
          newPassword: values.newPassword,
        });
      },
      onError: (err) => {
        // ví dụ lỗi mạng, API… thì cũng có thể show message custom ở đây
        console.error('Your old password is wrong', err);
      },
    });
  };

  return (
    <div className="container d-flex justify-content-center align-items-center">
      <div
        className="d-flex flex-column"
        style={{
          minHeight: '100vh',
          width: '100%', // Adjust for mobile responsiveness
          maxWidth: '600px', // Limit max width to avoid stretching on large screens
        }}
      >
        <div className="p-4 mt-3">
          <h1 className="text-white mb-4 text-center">Update Password</h1>

          {/* Form */}
          <Form form={form} layout="vertical" onFinish={onFinish}>
            {/* Full Name Fields */}
            <Form.Item
              name="oldPassword"
              label={<span className="text-white">Old Password</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
                type={oldPasswordVisible ? 'text' : 'password'}
                suffix={
                  <Button
                    icon={
                      oldPasswordVisible ? (
                        <EyeOutlined />
                      ) : (
                        <EyeInvisibleOutlined />
                      )
                    }
                    onClick={() => setOldPasswordVisible(!oldPasswordVisible)}
                    type="text"
                    style={{ padding: 0 }}
                  />
                }
              />
            </Form.Item>

            <Form.Item
              name="newPassword"
              label={<span className="text-white">New Password</span>}
              rules={[
                {
                  required: true,
                  message: 'Please input your new password!',
                },
                // Kiểm tra độ dài mật khẩu
                {
                  validator: (_, value) =>
                    !value || passwordMinLength.test(value)
                      ? Promise.resolve()
                      : Promise.reject(
                          new Error('Password must be at least 8 characters.')
                        ),
                },
                // Kiểm tra ký tự hoa
                {
                  validator: (_, value) =>
                    !value || passwordRegexUpperCase.test(value)
                      ? Promise.resolve()
                      : Promise.reject(
                          new Error(
                            'Password must contain at least one uppercase letter.'
                          )
                        ),
                },
                // Kiểm tra ký tự đặc biệt
                {
                  validator: (_, value) =>
                    !value || passwordRegexSpecialChar.test(value)
                      ? Promise.resolve()
                      : Promise.reject(
                          new Error(
                            'Password must contain at least one special character.'
                          )
                        ),
                },
              ]}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                type={newPasswordVisible ? 'text' : 'password'}
                suffix={
                  <Button
                    icon={
                      newPasswordVisible ? (
                        <EyeOutlined />
                      ) : (
                        <EyeInvisibleOutlined />
                      )
                    }
                    onClick={() => setNewPasswordVisible(!newPasswordVisible)}
                    type="text"
                    style={{ padding: 0 }}
                  />
                }
              />
            </Form.Item>

            <Form.Item
              name="confirmPassword"
              label={<span className="text-white">Confirm Password</span>}
              dependencies={['newPassword']}
              rules={[
                {
                  required: true,
                  message: 'Please confirm your password!',
                },
                {
                  validator: (_, value) =>
                    value && value !== form.getFieldValue('newPassword')
                      ? Promise.reject(new Error('Passwords do not match!'))
                      : Promise.resolve(),
                },
              ]}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                type={confirmPasswordVisible ? 'text' : 'password'}
                suffix={
                  <Button
                    icon={
                      confirmPasswordVisible ? (
                        <EyeOutlined />
                      ) : (
                        <EyeInvisibleOutlined />
                      )
                    }
                    onClick={() =>
                      setConfirmPasswordVisible(!confirmPasswordVisible)
                    }
                    type="text"
                    style={{ padding: 0 }}
                  />
                }
              />
            </Form.Item>

            {/* Save Button */}
            <Form.Item className="text-end mt-4">
              <Button
                type="primary"
                htmlType="submit"
                className="rounded-pill px-4"
                style={{
                  backgroundColor: '#e6f7ff',
                  color: '#0066cc',
                  border: 'none',
                  width: '30%', // Make button full width on smaller screens
                }}
              >
                Save
              </Button>
            </Form.Item>
          </Form>
        </div>
      </div>
    </div>
  );
};

export default UpdatePassword;
