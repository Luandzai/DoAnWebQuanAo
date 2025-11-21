// client/src/components/ConfirmStatusModal.jsx
import React from "react";
import { Modal, Button, Spinner } from "react-bootstrap";

const ConfirmStatusModal = ({
  show,
  onHide,
  onConfirm,
  title,
  message,
  isProcessing,
}) => {
  return (
    <Modal show={show} onHide={onHide} centered>
      <Modal.Header closeButton>
        <Modal.Title>{title}</Modal.Title>
      </Modal.Header>
      <Modal.Body>{message}</Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide} disabled={isProcessing}>
          Hủy bỏ
        </Button>
        <Button variant="primary" onClick={onConfirm} disabled={isProcessing}>
          {isProcessing ? (
            <>
              <Spinner
                as="span"
                animation="border"
                size="sm"
                role="status"
                aria-hidden="true"
              />
              <span className="ms-2">Đang xử lý...</span>
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
