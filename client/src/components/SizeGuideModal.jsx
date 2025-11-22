// client/src/components/SizeGuideModal.jsx
import React from 'react';
import { Modal, Table } from 'react-bootstrap';

const SizeGuideModal = ({ show, onHide }) => {
    return (
        <Modal show={show} onHide={onHide} centered>
            <Modal.Header closeButton>
                <Modal.Title>Hướng dẫn chọn size</Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <p>Sử dụng bảng dưới đây để chọn size phù hợp nhất với bạn:</p>
                <Table striped bordered hover size="sm" responsive>
                    <thead>
                        <tr>
                            <th>Size</th>
                            <th>Chiều cao (cm)</th>
                            <th>Cân nặng (kg)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td>S</td><td>150 - 160</td><td>45 - 55</td></tr>
                        <tr><td>M</td><td>160 - 170</td><td>55 - 65</td></tr>
                        <tr><td>L</td><td>170 - 175</td><td>65 - 75</td></tr>
                        <tr><td>XL</td><td>175 - 180</td><td>75 - 85</td></tr>
                        <tr><td>XXL</td><td>180+</td><td>85+</td></tr>
                    </tbody>
                </Table>
                <p className="text-muted small">
                    Lưu ý: Bảng size chỉ mang tính chất tham khảo. Kích thước có thể thay đổi tùy theo form dáng của bạn.
                </p>
            </Modal.Body>
        </Modal>
    );
};

export default SizeGuideModal;
