import type React from 'react';
import { useState, useEffect } from 'react';
import { Form, Input, DatePicker, Radio, Button, message } from 'antd';
import { CameraOutlined, CalendarOutlined } from '@ant-design/icons';
import 'antd/dist/reset.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import useCloudinaryUpload from '@src/modules/Cloudinary/hooks/useCloudinaryUpload';
import { useUpdateProfile } from '@src/modules/Profile/hooks/useUpdateProfile';
import { UpdateProfile } from '@src/modules/Profile/models';
import moment from 'moment';
import { setUser } from '@src/redux/authentication/authSlide';

const EditProfile: React.FC = () => {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.auth.user);

  const [form] = Form.useForm();
  const [profileImage, setProfileImage] = useState<string>(
    user?.avatarUrl ??
      'https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg'
  );
  const { uploadToCloudinary } = useCloudinaryUpload();
  const { mutate: updateProfile } = useUpdateProfile();

  // Ensure that form initializes with current user data
  useEffect(() => {
    if (user) {
      form.setFieldsValue({
        firstName: user.firstName,
        secondName: user.secondName,
        lastName: user.lastName,
        dateOfBirth: moment(user.dateOfBirth),
        gender: user.gender,
        phoneNumber: user.phoneNumber,
        avatarUrl: profileImage,
        status: user.status,
      });
    }
  }, [user, form, profileImage]);

  const handleImageUpload = async (file: File) => {
    try {
      const result = await uploadToCloudinary(file);
      if (result && result.secure_url) {
        setProfileImage(result.secure_url);
        message.success('Image uploaded successfully');
      }
    } catch (err) {
      message.error('Failed to upload image');
    }
  };

  const handleUpdateProfile = async (values: UpdateProfile) => {
    const date =
      values.dateOfBirth && moment.isMoment(values.dateOfBirth)
        ? values.dateOfBirth.toISOString()
        : null;

    //values.dateOfBirth = date instanceof Date ? date.toISOString() : date ?? new Date().toISOString();
    values.avatarUrl = profileImage;
    values.status = user?.status ?? true;

    // Send the update request
    updateProfile(
      { id: user?.id ?? 0, data: values },
      {
        onSuccess: (updatedUser) => {
          dispatch(setUser(updatedUser));
          message.success('Profile updated successfully!');
        },
        onError: () => {
          message.error('Failed to update profile');
        },
      }
    );
  };

  const onFinish = (values: UpdateProfile) => {
    handleUpdateProfile(values);
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
          <h1 className="text-white mb-4 text-center">Edit Profile</h1>

          {/* Form */}
          <Form form={form} layout="vertical" onFinish={onFinish}>
            {/* Profile Image */}
            <div className="d-flex justify-content-center mb-4">
              <div className="position-relative">
                <div
                  style={{
                    width: '100px',
                    height: '100px',
                    borderRadius: '50%',
                    overflow: 'hidden',
                    border: '2px solid white',
                  }}
                >
                  <img
                    src={profileImage || '/placeholder.svg'}
                    alt="Profile"
                    className="w-100 h-100 object-fit-cover"
                  />
                </div>
                <label
                  htmlFor="profile-image"
                  className="position-absolute bottom-0 end-0 bg-white rounded-circle p-1 cursor-pointer"
                  style={{ cursor: 'pointer' }}
                >
                  <CameraOutlined
                    style={{ fontSize: '18px', color: '#0066cc' }}
                  />
                </label>
                <input
                  id="profile-image"
                  type="file"
                  accept="image/*"
                  onChange={(e) => {
                    const file = e.target.files?.[0];
                    if (file) {
                      handleImageUpload(file);
                    }
                  }}
                  style={{ display: 'none' }}
                />
              </div>
            </div>

            {/* Full Name Fields */}
            <Form.Item
              name="firstName"
              label={<span className="text-white">First Name</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            <Form.Item
              name="secondName"
              label={<span className="text-white">Second Name</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
              />
            </Form.Item>

            <Form.Item
              name="lastName"
              label={<span className="text-white">Last Name</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            {/* Date of Birth */}
            <Form.Item
              name="dateOfBirth"
              label={<span className="text-white">Birthday</span>}
            >
              <DatePicker
                size="large"
                className="rounded-pill w-100"
                style={{ height: '50px' }}
                format="YYYY-MM-DD"
                suffixIcon={<CalendarOutlined style={{ color: '#bfbfbf' }} />}
                disabledDate={(current) => {
                  // Không cho chọn ngày sau hôm nay
                  return current && current > moment().endOf('day');
                }}
              />
            </Form.Item>

            {/* Gender */}
            {/* <Form.Item
              name="gender"
              label={<span className="text-white">Gender</span>}
            >
              <Radio.Group className="w-100 d-flex" buttonStyle="solid">
                <Radio.Button
                  value="Male"
                  className="flex-grow-1 text-center"
                  style={{
                    height: '50px',
                    lineHeight: '50px',
                    borderTopLeftRadius: 50,
                    borderBottomLeftRadius: 50,
                  }}
                >
                  Male
                </Radio.Button>
                <Radio.Button
                  value="Female"
                  className="flex-grow-1 text-center"
                  style={{
                    height: '50px',
                    lineHeight: '50px',
                    borderTopRightRadius: 50,
                    borderBottomRightRadius: 50,
                  }}
                >
                  Female
                </Radio.Button>
              </Radio.Group>
            </Form.Item> */}

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

export default EditProfile;
