import { HomeOutlined, DollarOutlined } from '@ant-design/icons';
import { Outlet, useLocation } from 'react-router-dom';
import { PageHeader } from '../../components/index.ts';
import { AppLayout } from '../index.ts';

export const PaymentAdminLayout = () => {
  const { pathname } = useLocation();
  return (
    <>
      <AppLayout>
        <PageHeader
          title="Payments"
          breadcrumbs={[
            {
              title: (
                <>
                  <HomeOutlined />
                  <span>home</span>
                </>
              ),
              path: '/',
            },
            {
              title: (
                <>
                  <DollarOutlined />
                  <span>Dashboard</span>
                </>
              ),
            },
            {
              title: pathname.split('/')[pathname.split('/').length - 1] || '',
            },
          ]}
        />
        <Outlet />
      </AppLayout>
    </>
  );
};
