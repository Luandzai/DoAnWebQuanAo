// client/src/pages/ReturnListPage.jsx
import React, { useState, useEffect, useContext } from "react";
import { Table, Spinner, Alert, Badge } from "react-bootstrap";
import AuthContext from "../context/AuthContext";

const ReturnListPage = () => {
  const [returns, setReturns] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  useEffect(() => {
    const fetchReturns = async () => {
      setLoading(true);
      setError(null);
      try {
        const { data } = await api.get("/user/returns"); // Gọi API mới
        setReturns(data);
      } catch (err) {
        setError("Không thể tải lịch sử đổi/trả.");
      } finally {
        setLoading(false);
      }
    };
    fetchReturns();
  }, [api]);

  if (loading) {
    /* ... */
  }
  if (error) {
    /* ... */
  }

  return (
    <>
      <h3 className="mb-4">Lịch sử Đổi/Trả</h3>
      {returns.length === 0 ? (
        <p>Bạn chưa có yêu cầu đổi/trả nào.</p>
      ) : (
        <Table striped bordered hover responsive size="sm">
          <thead>
            <tr>
              <th>ID Yêu Cầu</th>
              <th>Mã Đơn Hàng</th>
              <th>Ngày Yêu Cầu</th>
              <th>Trạng Thái</th>
            </tr>
          </thead>
          <tbody>
            {returns.map((req) => (
              <tr key={req.ReturnID}>
                <td>RET_{req.ReturnID}</td>
                <td>ORD_{req.DonHangID}</td>
                <td>{new Date(req.NgayYeuCau).toLocaleDateString("vi-VN")}</td>
                <td>
                  <Badge bg={req.Status === "APPROVED" ? "success" : "warning"}>
                    {req.Status}
                  </Badge>
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      )}
    </>
  );
};

export default ReturnListPage;
