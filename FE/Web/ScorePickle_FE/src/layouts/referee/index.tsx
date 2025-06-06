import { HomeOutlined, UserOutlined } from '@ant-design/icons';
import { Link, Outlet, useLocation } from 'react-router-dom';
import { PageHeader } from '../../components/index.ts';
import { AppLayout } from '../index.ts';
import { REFEREE_ITEMS } from '../../constants/index.ts';

// todo: review
export const RefereeLayout = () => {
  const { pathname } = useLocation();
  return (
    <>
      <AppLayout>
        <PageHeader
          title="Referee"
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
                  <UserOutlined />
                  <span>Referee</span>
                </>
              ),
              menu: {
                items: REFEREE_ITEMS.map((d) => ({
                  key: d.title,
                  title: <Link to={d.path}>{d.title}</Link>,
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
