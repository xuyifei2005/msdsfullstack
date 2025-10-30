import React, { useEffect } from 'react';

const TestPage: React.FC = () => {
  console.log('🚀🚀🚀 测试页面开始渲染 🚀🚀🚀');
  
  useEffect(() => {
    console.log('🎯🎯🎯 测试页面已挂载 🎯🎯🎯');
    alert('测试页面加载成功！');
  }, []);

  return (
    <div style={{ padding: '20px' }}>
      <h1>调试测试页面</h1>
      <p>如果你看到这个页面，说明路由工作正常</p>
      <p>请检查控制台是否有调试信息</p>
    </div>
  );
};

export default TestPage;