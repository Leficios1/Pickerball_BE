import type React from 'react';
import { useState, useEffect } from 'react';
import { Form, Input, Button, message } from 'antd';
import { CameraOutlined } from '@ant-design/icons';
import 'antd/dist/reset.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useSelector } from 'react-redux';
import { RootState } from '@src/redux/store';
import useCloudinaryUpload from '@src/modules/Cloudinary/hooks/useCloudinaryUpload';
import { UpdateSponsorProfileRequest } from '@src/modules/Profile/models';
import { useUpdateSponsorProfile } from '@src/modules/Profile/hooks/useUpdateSponsorProfile';
import { useGetSponsorById } from '@src/modules/Sponsor/hooks/useGetSponsorById';

const SponsorProfile: React.FC = () => {
  const user = useSelector((state: RootState) => state.auth.user);
  const { data: sponsor } = useGetSponsorById(user?.id ?? 0);

  const [form] = Form.useForm();
  const [logoUrl, setLogoUrl] = useState<string>(
    sponsor?.logoUrl ??
      'https://inkythuatso.com/uploads/thumbnails/800/2023/03/9-anh-dai-dien-trang-inkythuatso-03-15-27-03.jpg'
  );
  const { uploadToCloudinary } = useCloudinaryUpload();
  const { mutate: updateProfile } = useUpdateSponsorProfile();

  // Ensure that form initializes with current user data
  useEffect(() => {
    if (user) {
      form.setFieldsValue({
        companyName: sponsor?.companyName ?? '',
        logoUrl: logoUrl,
        urlSocial: sponsor?.urlSocial ?? '',
        urlSocial1: sponsor?.urlSocial1 ?? '',
        descreption: sponsor?.descreption ?? '',
        contactEmail: sponsor?.contactEmail ?? '',
      });
    }
  }, [user, form, logoUrl]);

  const handleImageUpload = async (file: File) => {
    try {
      const result = await uploadToCloudinary(file);
      if (result && result.secure_url) {
        setLogoUrl(result.secure_url);
        message.success('Image uploaded successfully');
      }
    } catch (err) {
      message.error('Failed to upload image');
    }
  };

  const handleUpdateProfile = async (values: UpdateSponsorProfileRequest) => {
    const updatedValues = {
      ...values,
      logoUrl,
      status: user?.status ?? true,
    };

    updateProfile(
      { id: user?.id ?? 0, data: updatedValues },
      {
        onSuccess: () => {
          message.success('Profile updated successfully!');
        },
        onError: () => {
          message.error('Failed to update profile');
        },
      }
    );
  };

  const onFinish = (values: UpdateSponsorProfileRequest) => {
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
          <h1 className="text-black mb-4 text-center">
            Edit Sponsor Information
          </h1>

          {/* Form */}
          <Form form={form} layout="vertical" onFinish={onFinish}>
            {/* Profile Image */}
            <div className="mb-4">
              <div className="position-relative">
                <img
                  src={logoUrl || '/placeholder.svg'}
                  alt="Profile"
                  className="w-100 h-100 object-fit-cover"
                />
                <label
                  htmlFor="logo-image"
                  className="position-absolute bottom-0 end-0 bg-white rounded-circle p-1 cursor-pointer"
                  style={{ cursor: 'pointer' }}
                >
                  <CameraOutlined
                    style={{ fontSize: '20px', color: '#0066cc' }}
                  />
                </label>
                <input
                  id="logo-image"
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
              name="companyName"
              label={<span className="text-black">Company Name</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            <Form.Item
              name="descreption"
              label={<span className="text-black">Description</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            <Form.Item
              name="urlSocial"
              label={<span className="text-black">Social URL</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
              />
            </Form.Item>

            <Form.Item
              name="urlSocial1"
              label={<span className="text-black">Other Social URL</span>}
            >
              <Input
                size="large"
                className="rounded-pill"
                style={{ height: '50px' }}
                required
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

export default SponsorProfile;
