import { DefaultFooter } from '@ant-design/pro-components';
import React from 'react';

const Footer: React.FC = () => {
  return (
    <DefaultFooter
      style={{
        background: 'none',
      }}
      links={[
        {
          key: 'MSDS安全智库网',
          title: 'MSDS安全智库网',
          href: '',
          blankTarget: true,
        },
      ]}
    />
  );
};

export default Footer;
