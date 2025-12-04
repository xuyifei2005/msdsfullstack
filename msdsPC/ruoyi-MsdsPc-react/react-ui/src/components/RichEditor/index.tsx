import React, { useRef, useMemo } from 'react';
import ReactQuill, { Quill } from 'react-quill';
import 'react-quill/dist/quill.snow.css';
import { message } from 'antd';
import { request } from '@umijs/max';

interface RichEditorProps {
  value?: string;
  onChange?: (value: string) => void;
  placeholder?: string;
  style?: React.CSSProperties;
}

const RichEditor: React.FC<RichEditorProps> = ({ value, onChange, placeholder, style }) => {
  const quillRef = useRef<ReactQuill>(null);

  const imageHandler = () => {
    const input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');
    input.click();

    input.onchange = async () => {
      const file = input.files ? input.files[0] : null;
      if (!file) return;

      const formData = new FormData();
      formData.append('file', file);

      try {
        const res = await request<{ url: string; code: number; msg: string }>('/api/common/upload', {
          method: 'POST',
          data: formData,
          headers: {
            // Content-Type is automatically set by browser with boundary for FormData
          },
        });

        if (res.code === 200) {
          const quill = quillRef.current?.getEditor();
          const range = quill?.getSelection();
          if (quill && range) {
            quill.insertEmbed(range.index, 'image', res.url);
            quill.setSelection(range.index + 1);
          }
        } else {
          message.error(res.msg || 'Image upload failed');
        }
      } catch (error) {
        message.error('Image upload failed');
        console.error(error);
      }
    };
  };

  const modules = useMemo(() => ({
    toolbar: {
      container: [
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
        ['bold', 'italic', 'underline', 'strike', 'blockquote'],
        [{ 'list': 'ordered' }, { 'list': 'bullet' }, { 'indent': '-1' }, { 'indent': '+1' }],
        [{ 'color': [] }, { 'background': [] }],
        [{ 'align': [] }],
        ['link', 'image', 'video'],
        ['clean']
      ],
      handlers: {
        image: imageHandler
      }
    }
  }), []);

  return (
    <ReactQuill
      ref={quillRef}
      theme="snow"
      value={value || ''}
      onChange={onChange}
      modules={modules}
      placeholder={placeholder}
      style={{ height: 300, marginBottom: 50, ...style }}
    />
  );
};

export default RichEditor;
