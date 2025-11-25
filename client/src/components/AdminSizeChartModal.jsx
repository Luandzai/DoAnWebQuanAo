// client/src/components/AdminSizeChartModal.jsx
import React, { useState, useEffect, useContext } from "react";
import { Modal, Button, Form, Alert, Spinner } from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";

const AdminSizeChartModal = ({ show, onHide, category }) => {
  const { api } = useContext(AuthContext);
  const [content, setContent] = useState("");
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  // Load dữ liệu cũ khi mở modal
  useEffect(() => {
    if (show && category) {
      const fetchSizeChart = async () => {
        setLoading(true);
        try {
          const { data } = await api.get(`/sizecharts/${category.DanhMucID}`);
          // Nếu có data thì set, nếu chưa có thì để mẫu bảng HTML mặc định
          setContent(data.MoTa || getDefaultTemplate());
        } catch (error) {
          console.error(error);
          toast.error("Lỗi tải bảng size");
        } finally {
          setLoading(false);
        }
      };
      fetchSizeChart();
    }
  }, [show, category, api]);

  const handleSubmit = async () => {
    setSaving(true);
    try {
      await api.post("/sizecharts", {
        DanhMucID: category.DanhMucID,
        MoTa: content,
      });
      toast.success("Lưu bảng size thành công!");
      onHide();
    } catch (error) {
      toast.error("Lỗi khi lưu bảng size");
    } finally {
      setSaving(false);
    }
  };

  // Template mặc định để Admin đỡ phải gõ code HTML từ đầu
  const getDefaultTemplate = () => {
    return `<table class="table table-bordered table-sm">
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
  </tbody>
</table>`;
  };

  return (
    <Modal show={show} onHide={onHide} size="lg" centered>
      <Modal.Header closeButton>
        <Modal.Title>
          Cấu hình Bảng Size cho: <strong>{category?.TenDanhMuc}</strong>
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {loading ? (
          <div className="text-center py-4">
            <Spinner animation="border" />
          </div>
        ) : (
          <>
            <Alert variant="info" className="small">
              Bạn có thể nhập mã HTML để tạo bảng (Table). Dùng class{" "}
              <code>table table-bordered</code> của Bootstrap để đẹp hơn.
            </Alert>
            <Form.Group className="mb-3">
              <Form.Label>Nội dung (HTML)</Form.Label>
              <Form.Control
                as="textarea"
                rows={10}
                value={content}
                onChange={(e) => setContent(e.target.value)}
                style={{ fontFamily: "monospace", fontSize: "0.9rem" }}
              />
            </Form.Group>
            <h6>Xem trước:</h6>
            <div
              className="border p-3 rounded bg-light"
              dangerouslySetInnerHTML={{ __html: content }}
            />
          </>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onHide}>
          Đóng
        </Button>
        <Button
          variant="primary"
          onClick={handleSubmit}
          disabled={saving || loading}
        >
          {saving ? "Đang lưu..." : "Lưu thay đổi"}
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default AdminSizeChartModal;
