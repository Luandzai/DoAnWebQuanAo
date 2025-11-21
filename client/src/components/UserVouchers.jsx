// client/src/components/UserVouchers.jsx

import React, { useState, useEffect, useContext } from "react";
import { Row, Col, Spinner, Alert, Card, Badge } from "react-bootstrap";
import AuthContext from "../context/AuthContext";

// Sao chép style từ trang chi tiết sản phẩm
const voucherCardStyle = {
  backgroundColor: "#fff9e0",
  border: "1px solid #fff9e0",
  borderRadius: "8px",
  cursor: "pointer",
};
const voucherBadgeStyle = {
  backgroundColor: "#dc3545",
  color: "white",
  fontWeight: 500,
};
const voucherCodeStyle = {
  color: "#dc3545",
  fontWeight: 700,
};

const UserVouchers = () => {
  const [vouchers, setVouchers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    const fetchVouchers = async () => {
      setLoading(true);
      setError(null);
      try {
        // === SỬA LỖI Ở ĐÂY ===
        // Gọi API mới (của riêng user) thay vì API public
        const { data } = await api.get("/user/my-vouchers");
        setVouchers(data);
      } catch (err) {
        setError("Không thể tải mã khuyến mãi của bạn.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchVouchers();
  }, [api]);

  if (loading) {
    return (
      <div className="text-center">
        <Spinner animation="border" />
      </div>
    );
  }

  if (error) {
    return <Alert variant="danger">{error}</Alert>;
  }

  return (
    <>
      <h3 className="mb-4">Mã Khuyến Mãi Của Bạn</h3>
      {vouchers.length === 0 ? (
        <p>Bạn chưa lưu mã khuyến mãi nào.</p>
      ) : (
        <Row>
          {vouchers.map((v) => (
            <Col md={6} key={v.MaKhuyenMai} className="mb-3">
              <Card body style={voucherCardStyle}>
                <div className="d-flex justify-content-between align-items-center">
                  <div>
                    <h5 className="mb-1" style={voucherCodeStyle}>
                      {v.MaKhuyenMai}
                    </h5>
                    <p className="mb-0 text-muted small">{v.TenKhuyenMai}</p>
                    <p className="mb-0 text-muted small">
                      Hết hạn:{" "}
                      {new Date(v.NgayKetThuc).toLocaleDateString("vi-VN")}
                    </p>
                  </div>
                  <Badge style={voucherBadgeStyle}>
                    {v.LoaiGiamGia === "SOTIEN"
                      ? `${parseFloat(v.GiaTriGiam) / 1000}K`
                      : `${parseFloat(v.GiaTriGiam)}%`}
                  </Badge>
                </div>
              </Card>
            </Col>
          ))}
        </Row>
      )}
    </>
  );
};

export default UserVouchers;
