import { HomeOutlined, DollarOutlined } from '@ant-design/icons';
import { Link, Outlet, useLocation } from 'react-router-dom';
import { PageHeader } from '../../components/index.ts';
import { SPONSOR_PAYMENT_ITEMS } from '../../constants/index.ts';
import { AppLayout } from '../index.ts';

export const PaymentLayout = () => {
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
                  <span>Payment Management</span>
                </>
              ),
              menu: {
                items: SPONSOR_PAYMENT_ITEMS.map((item) => ({
                  key: item.title,
                  title: <Link to={item.path}>{item.title}</Link>,
                })),
              },
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
