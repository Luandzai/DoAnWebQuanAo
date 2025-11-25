// client/src/components/ConfirmStatusModal.jsx
import React, { useState, useEffect } from "react";
import { Modal, Button, Spinner, Form } from "react-bootstrap";

const ConfirmStatusModal = ({
  show,
  onHide,
  onConfirm,
  title,
  message,
  isProcessing,
  targetStatus, // Nhận thêm prop này để biết đang chuyển sang trạng thái nào
}) => {
  const [maVanDon, setMaVanDon] = useState("");
  const [donViVC, setDonViVC] = useState("Giao Hàng Nhanh");

  // Reset form khi mở modal
  useEffect(() => {
    if (show) {
      setMaVanDon("");
      setDonViVC("Giao Hàng Nhanh");
    }
  }, [show]);

  const handleConfirm = () => {
    // Truyền dữ liệu vận chuyển về hàm cha
    onConfirm({ maVanDon, tenDonViVC: donViVC });
  };

  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>{title}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>{message}</p>

        {/* Chỉ hiện form nhập nếu trạng thái đích là DANG_GIAO */}
        {targetStatus === "DANG_GIAO" && (
          <div className="bg-light p-3 rounded border">
            <h6 className="fw-bold mb-3">Thông tin Vận chuyển (Bắt buộc)</h6>
            <Form.Group className="mb-2">
              <Form.Label>Đơn vị vận chuyển</Form.Label>
              <Form.Select
                value={donViVC}
                onChange={(e) => setDonViVC(e.target.value)}
              >
                <option value="Giao Hàng Nhanh">Giao Hàng Nhanh (GHN)</option>
                <option value="Giao Hàng Tiết Kiệm">Giao Hàng Tiết Kiệm</option>
                <option value="Viettel Post">Viettel Post</option>
                <option value="Shopee Xpress">Shopee Xpress</option>
              </Form.Select>
            </Form.Group>
            <Form.Group>
              <Form.Label>Mã vận đơn</Form.Label>
              <Form.Control
                type="text"
                placeholder="Ví dụ: GHN12345678"
                value={maVanDon}
                onChange={(e) => setMaVanDon(e.target.value)}
                autoFocus
              />
              <Form.Text className="text-muted">
                Nhập mã để khách hàng có thể tra cứu.
              </Form.Text>
            </Form.Group>
          </div>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide} disabled={isProcessing}>
          Hủy bỏ
        </Button>
        <Button
          variant="primary"
          onClick={handleConfirm}
          disabled={isProcessing || (targetStatus === "DANG_GIAO" && !maVanDon)}
        >
          {isProcessing ? (
            <>
              <Spinner
                as="span"
                animation="border"
                size="sm"
                className="me-2"
              />
              Đang xử lý...
            </>
          ) : (
            "Xác nhận"
          )}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ConfirmStatusModal;
