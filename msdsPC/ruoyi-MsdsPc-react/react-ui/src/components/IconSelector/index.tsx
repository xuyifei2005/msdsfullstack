import * as React from 'react';
import { Input, Empty } from 'antd';
import type { CategoriesKeys } from './fields';
import { categories } from './fields';
// import { useIntl } from '@umijs/max';

interface IconSelectorProps {
  onSelect: any;
}

interface IconSelectorState {
  searchKey: string;
}

const IconSelector: React.FC<IconSelectorProps> = (props) => {
  // const intl = useIntl();
  // const { messages } = intl;
  const { onSelect } = props;
  const [displayState, setDisplayState] = React.useState<IconSelectorState>({
    searchKey: '',
  });

  const newIconNames: string[] = [];

  const handleSearchIcon = React.useCallback(
    debounce((searchKey: string) => {
      setDisplayState(prevState => ({ ...prevState, searchKey }));
    }),
    [],
  );

  const renderCategories = React.useMemo<React.ReactNode>(() => {
    return <Empty style={{ margin: '2em 0' }} />;
  }, [displayState.searchKey]);
  return (
    <>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <Input.Search
          style={{ margin: '0 10px', flex: 1 }}
          allowClear
          onChange={e => handleSearchIcon(e.currentTarget.value)}
          size="large"
          autoFocus
        />
      </div>
      {renderCategories}
    </>
  );
};

export default IconSelector
