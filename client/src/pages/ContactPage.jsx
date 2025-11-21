// client/src/pages/ContactPage.jsx (File MỚI)

import React, { useState } from "react";
import {
  Container,
  Row,
  Col,
  Form,
  Button,
  Spinner,
  Alert,
} from "react-bootstrap";
import axios from "axios";

const ContactPage = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    message: "",
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  const { name, email, phone, message } = formData;

  const onChange = (e) =>
    setFormData({ ...formData, [e.target.name]: e.target.value });

  const onSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError("");
    setSuccess("");
    try {
      const res = await axios.post(
        `${import.meta.env.VITE_API_URL}/api/contact`,
        formData
      );
      setSuccess(res.data.message);
      setFormData({ name: "", email: "", phone: "", message: "" }); // Reset form
    } catch (err) {
      setError(
        err.response?.data?.message || "Đã có lỗi xảy ra. Vui lòng thử lại."
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <Container className="py-5">
      <Row className="justify-content-center">
        <Col md={8} lg={6}>
          <h1 className="text-center mb-4">Liên Hệ Với Chúng Tôi</h1>
          <p className="text-center text-muted mb-4">
            Nếu bạn có bất kỳ câu hỏi hoặc góp ý nào, đừng ngần ngại gửi cho
            chúng tôi. Chúng tôi luôn sẵn lòng lắng nghe!
          </p>
          {error && <Alert variant="danger">{error}</Alert>}
          {success && <Alert variant="success">{success}</Alert>}
          <Form onSubmit={onSubmit}>
            <Form.Group className="mb-3" controlId="contactName">
              <Form.Label>Họ và Tên</Form.Label>
              <Form.Control
                type="text"
                placeholder="Nhập họ và tên của bạn"
                name="name"
                value={name}
                onChange={onChange}
                required
              />
            </Form.Group>
            <Form.Group className="mb-3" controlId="contactEmail">
              <Form.Label>Email</Form.Label>
              <Form.Control
                type="email"
                placeholder="Nhập địa chỉ email"
                name="email"
                value={email}
                onChange={onChange}
                required
              />
            </Form.Group>
            <Form.Group className="mb-3" controlId="contactPhone">
              <Form.Label>Số điện thoại (Không bắt buộc)</Form.Label>
              <Form.Control
                type="tel"
                placeholder="Nhập số điện thoại"
                name="phone"
                value={phone}
                onChange={onChange}
              />
            </Form.Group>
            <Form.Group className="mb-3" controlId="contactMessage">
              <Form.Label>Nội dung</Form.Label>
              <Form.Control
                as="textarea"
                rows={5}
                placeholder="Nội dung bạn muốn gửi..."
                name="message"
                value={message}
                onChange={onChange}
                required
              />
            </Form.Group>
            <div className="d-grid">
              <Button variant="dark" type="submit" disabled={loading}>
                {loading ? (
                  <>
                    <Spinner
                      as="span"
                      animation="border"
                      size="sm"
                      role="status"
                      aria-hidden="true"
                    />{" "}
                    Đang gửi...
                  </>
                ) : (
                  "Gửi Tin Nhắn"
                )}
              </Button>
            </div>
          </Form>
        </Col>
      </Row>
    </Container>
  );
};

export default ContactPage;
