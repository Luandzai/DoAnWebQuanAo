// client/src/components/SizeGuideModal.jsx
import React, { useState, useEffect, useContext } from "react";
import { Modal, Spinner, Alert } from "react-bootstrap";
import AuthContext from "../context/AuthContext";

const SizeGuideModal = ({ show, onHide, categoryId }) => {
  const [content, setContent] = useState(null);
  const [loading, setLoading] = useState(false);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    if (show && categoryId) {
      const fetchSizeChart = async () => {
        setLoading(true);
        setContent(null);
        try {
          const { data } = await api.get(`/sizecharts/${categoryId}`);
          setContent(data.MoTa);
        } catch (error) {
          console.error("Lỗi tải size chart:", error);
        } finally {
          setLoading(false);
        }
      };
      fetchSizeChart();
    }
  }, [show, categoryId, api]);

  return (
    <Modal show={show} onHide={onHide} centered size="lg">
      <Modal.Header closeButton>
        <Modal.Title>Hướng dẫn chọn size</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {loading ? (
          <div className="text-center py-4">
            <Spinner animation="border" />
          </div>
        ) : content ? (
          <div dangerouslySetInnerHTML={{ __html: content }} />
        ) : (
          <Alert variant="warning">
            Chưa có hướng dẫn chọn size cụ thể cho sản phẩm này.
            <br />
            Vui lòng tham khảo bảng size chung hoặc liên hệ CSKH.
          </Alert>
        )}
        <p className="text-muted small mt-3">
          * Số đo có thể chênh lệch 1-2cm tùy thuộc vào độ co giãn của vải.
        </p>
      </Modal.Body>
    </Modal>
  );
};

export default SizeGuideModal;
