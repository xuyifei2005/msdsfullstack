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
          key: 'MSDS 危险化学品说明书管理平台',
          title: 'MSDS 危险化学品说明书管理平台',
          href: '',
          blankTarget: true,
        },
      ]}
    />
  );
};

export default Footer;
