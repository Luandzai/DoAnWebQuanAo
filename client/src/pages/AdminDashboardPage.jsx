// client/src/pages/AdminDashboardPage.jsx (HOÀN CHỈNH VỚI BIỂU ĐỒ)

import React, { useState, useEffect, useContext, useMemo } from "react";
import { Link } from "react-router-dom";
import {
  Card,
  Row,
  Col,
  Spinner,
  Table,
  Alert,
  Badge,
  Form,
  ListGroup,
} from "react-bootstrap";
import {
  TrophyFill,
  BoxSeam,
  PersonWorkspace,
  ExclamationTriangleFill,
} from "react-bootstrap-icons";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import { Bar } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from "chart.js";

// Đăng ký các thành phần cần thiết của Chart.js
ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const AdminDashboardPage = () => {
  // State hiện có
  const [stats, setStats] = useState({
    totalSales: 0,
    newOrdersCount: 0,
    lowStockCount: 0,
    totalUsersCount: 0, // Đã thêm để hiển thị
    latestOrders: [],
    topSellingProducts: [],
    lowStockProducts: [],
    topCustomer: null,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  // STATES MỚI CHO BIỂU ĐỒ
  const [salesData, setSalesData] = useState([]);
  const currentYear = new Date().getFullYear();
  const [selectedYear, setSelectedYear] = useState(currentYear);
  const [chartLoading, setChartLoading] = useState(false);

  // Hàm định dạng tiền tệ
  const formatCurrency = (amount) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(amount);
  };

  // Hàm định dạng số lượng
  const formatNumber = (num) => {
    return new Intl.NumberFormat("vi-VN").format(num);
  };

  const LOW_STOCK_THRESHOLD = 10;

  // HÀM FETCH DỮ LIỆU BIỂU ĐỒ
  const fetchSalesData = async (year) => {
    setChartLoading(true);
    try {
      const { data } = await api.get(`/admin/sales/monthly?year=${year}`);
      setSalesData(data.salesData);
    } catch (err) {
      console.error("Lỗi tải dữ liệu biểu đồ:", err);
    } finally {
      setChartLoading(false);
    }
  };

  // Tải dữ liệu chính (Dashboard Stats)
  useEffect(() => {
    const fetchStats = async () => {
      setLoading(true);
      try {
        // API đã được sửa ở Backend để trả về totalUsersCount
        const { data } = await api.get("/admin/dashboard-stats");
        setStats(data);
      } catch (err) {
        setError(
          err.response?.data?.message || "Không thể tải dữ liệu Dashboard."
        );
      } finally {
        setLoading(false);
      }
    };
    fetchStats();
  }, [api]);

  // Tải dữ liệu biểu đồ khi năm thay đổi
  useEffect(() => {
    fetchSalesData(selectedYear);
  }, [api, selectedYear]);

  // Mảng năm cho Dropdown (Từ 3 năm trước đến 1 năm sau)
  const availableYears = useMemo(() => {
    const years = [];
    for (let i = currentYear - 3; i <= currentYear + 1; i++) {
      years.push(i);
    }
    return years;
  }, [currentYear]);

  // Dữ liệu và Cấu hình cho Biểu đồ Cột (ChartJS)
  const chartData = {
    labels: [
      "T1",
      "T2",
      "T3",
      "T4",
      "T5",
      "T6",
      "T7",
      "T8",
      "T9",
      "T10",
      "T11",
      "T12",
    ],
    datasets: [
      {
        label: "Doanh thu (VND)",
        data: salesData.map((item) => item.revenue),
        backgroundColor: "rgba(54, 162, 235, 0.6)", // Xanh dương
        borderColor: "rgba(54, 162, 235, 1)",
        borderWidth: 1,
      },
    ],
  };

  const chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: "top",
      },
      title: {
        display: true,
        text: `DOANH THU THEO THÁNG NĂM ${selectedYear}`,
      },
      tooltip: {
        callbacks: {
          label: function (context) {
            let label = context.dataset.label || "";
            if (label) {
              label += ": ";
            }
            if (context.parsed.y !== null) {
              label += formatCurrency(context.parsed.y);
            }
            return label;
          },
        },
      },
    },
    scales: {
      y: {
        beginAtZero: true,
        ticks: {
          // KHẮC PHỤC LỖI TICKS: Chỉ sử dụng callback(value)
          callback: function (value) {
            return formatCurrency(value);
          },
        },
      },
    },
  };

  return (
    <AdminLayout>
      <h2 className="mb-4">Dashboard</h2>
      {error && <Alert variant="danger">{error}</Alert>}

      {/* 1. KHU VỰC THỐNG KÊ TỔNG QUAN */}
      <Row className="mb-4">
        {loading ? (
          <div className="text-center py-5">
            <Spinner animation="border" />
          </div>
        ) : (
          <>
            <Col md={3}>
              <Card className="shadow-sm border-0 h-100">
                <Card.Body>
                  <Card.Title className="text-muted">
                    Doanh số tháng này
                  </Card.Title>
                  <h3 className="text-primary">
                    {formatCurrency(stats.totalSales)}
                  </h3>
                </Card.Body>
              </Card>
            </Col>
            <Col md={3}>
              <Card className="shadow-sm border-0 h-100">
                <Card.Body>
                  <Card.Title className="text-muted">Đơn hàng mới</Card.Title>
                  <h3 className="text-info">{stats.newOrdersCount}</h3>
                </Card.Body>
              </Card>
            </Col>
            <Col md={3}>
              <Card className="shadow-sm border-0 h-100">
                <Card.Body>
                  <Card.Title className="text-muted">
                    Sản phẩm tồn kho thấp
                  </Card.Title>
                  <h3 className="text-warning">{stats.lowStockCount}</h3>
                </Card.Body>
              </Card>
            </Col>
            <Col md={3}>
              <Card className="shadow-sm border-0 h-100">
                <Card.Body>
                  <Card.Title className="text-muted">
                    Tổng Người dùng
                  </Card.Title>
                  <h3 className="text-success">{stats.totalUsersCount}</h3>
                </Card.Body>
              </Card>
            </Col>
          </>
        )}
      </Row>

      {/* ======================================================= */}
      {/* 2. KHU VỰC BIỂU ĐỒ DOANH THU */}
      {/* ======================================================= */}
      <Card className="shadow-sm mt-4">
        <Card.Header className="d-flex justify-content-between align-items-center">
          Doanh thu theo tháng
          {/* Dropdown chọn Năm */}
          <Form.Group controlId="selectYear" className="mb-0">
            <Form.Select
              size="sm"
              value={selectedYear}
              onChange={(e) => setSelectedYear(parseInt(e.target.value))}
            >
              {availableYears.map((year) => (
                <option key={year} value={year}>
                  Năm {year}
                </option>
              ))}
            </Form.Select>
          </Form.Group>
        </Card.Header>
        <Card.Body>
          {chartLoading ? (
            <div className="text-center py-5">
              <Spinner animation="border" />
            </div>
          ) : (
            // Biểu đồ cột Bar Chart
            <Bar options={chartOptions} data={chartData} />
          )}
        </Card.Body>
      </Card>

      {/* ======================================================= */}
      {/* 4. KHU VỰC THỐNG KÊ CHI TIẾT */}
      {/* ======================================================= */}
      <Row className="mt-4 g-4">
        {/* SẢN PHẨM BÁN CHẠY */}
        <Col md={6}>
          <Card className="shadow-sm">
            <Card.Header className="d-flex align-items-center">
              <TrophyFill className="me-2 text-warning" />
              Top 10 Sản phẩm bán chạy
            </Card.Header>
            <Card.Body className="p-0">
              {loading ? (
                <div className="text-center py-5">
                  <Spinner animation="border" size="sm" />
                </div>
              ) : stats.topSellingProducts.length > 0 ? (
                <Table hover responsive className="align-middle mb-0">
                  <thead className="bg-light">
                    <tr>
                      <th>#</th>
                      <th>Tên sản phẩm</th>
                      <th className="text-center">Đã bán</th>
                      <th className="text-end">Doanh thu</th>
                    </tr>
                  </thead>
                  <tbody>
                    {stats.topSellingProducts.map((product, index) => (
                      <tr key={product.Slug}>
                        <td>{index + 1}</td>
                        <td>
                          <Link
                            to={`/product/${product.Slug}`}
                            target="_blank"
                            className="text-decoration-none"
                          >
                            {product.TenSanPham}
                          </Link>
                        </td>
                        <td className="text-center">
                          {formatNumber(product.totalSold)}
                        </td>
                        <td className="text-end fw-bold text-success">
                          {formatCurrency(product.totalRevenue)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              ) : (
                <p className="text-muted text-center p-3 mb-0">
                  Chưa có dữ liệu bán hàng.
                </p>
              )}
            </Card.Body>
          </Card>
        </Col>

        {/* SẢN PHẨM TỒN KHO THẤP */}
        <Col md={6}>
          <Card className="shadow-sm">
            <Card.Header className="d-flex align-items-center">
              <ExclamationTriangleFill className="me-2 text-danger" />
              Top 10 Sản phẩm tồn kho thấp
            </Card.Header>
            <Card.Body className="p-0">
              {loading ? (
                <div className="text-center py-5">
                  <Spinner animation="border" size="sm" />
                </div>
              ) : stats.lowStockProducts.length > 0 ? (
                <Table hover responsive className="align-middle mb-0">
                  <thead className="bg-light">
                    <tr>
                      <th>#</th>
                      <th>Tên sản phẩm</th>
                      <th className="text-center">Tồn kho</th>
                    </tr>
                  </thead>
                  <tbody>
                    {stats.lowStockProducts.map((product, index) => (
                      <tr key={product.Slug}>
                        <td>{index + 1}</td>
                        <td>
                          <Link
                            to={`/product/${product.Slug}`}
                            target="_blank"
                            className="text-decoration-none"
                          >
                            {product.TenSanPham}
                          </Link>
                        </td>
                        <td className="text-center fw-bold text-danger">
                          {formatNumber(product.totalStock)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              ) : (
                <p className="text-muted text-center p-3 mb-0">
                  Không có sản phẩm nào có tồn kho thấp.
                </p>
              )}
            </Card.Body>
          </Card>
        </Col>
      </Row>
      <Row className="mt-4">
        {/* KHÁCH HÀNG TIỀM NĂNG */}
        {/* Đặt trong một Row riêng */}
        <Col md={12}>
          <Card className="shadow-sm">
            <Card.Header className="d-flex align-items-center">
              <PersonWorkspace className="me-2 text-info" />
              Khách hàng tiềm năng nhất
            </Card.Header>
            <Card.Body className="text-center">
              {loading ? (
                <Spinner animation="border" size="sm" />
              ) : stats.topCustomer ? (
                <>
                  <h5 className="card-title">{stats.topCustomer.HoTen}</h5>
                  <p className="card-text text-muted">
                    {stats.topCustomer.Email}
                  </p>
                  <h4 className="text-primary">
                    {formatCurrency(stats.topCustomer.totalSpent)}
                  </h4>
                  <p className="text-muted mb-0">Tổng chi tiêu</p>
                </>
              ) : (
                <p className="text-muted mb-0">Chưa có dữ liệu.</p>
              )}
            </Card.Body>
          </Card>
        </Col>
      </Row>

      {/* 3. DANH SÁCH ĐƠN HÀNG GẦN ĐÂY */}
      <Card className="shadow-sm mt-4">
        <Card.Header>Đơn hàng chờ xử lý (5 đơn gần nhất)</Card.Header>
        <Card.Body>
          {stats.latestOrders.length === 0 ? (
            <p>Không có đơn hàng mới nào cần xử lý.</p>
          ) : (
            <Table responsive hover size="sm">
              <thead>
                <tr>
                  <th>Mã ĐH</th>
                  <th>Khách hàng</th>
                  <th>Ngày đặt</th>
                  <th>Tổng tiền</th>
                  <th>Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                {stats.latestOrders.map((order) => (
                  <tr key={order.DonHangID}>
                    <td>ORD_{order.DonHangID}</td>
                    <td>{order.HoTen}</td>
                    <td>
                      {new Date(order.NgayDatHang).toLocaleDateString("vi-VN")}
                    </td>
                    <td>{formatCurrency(order.TongThanhToan)}</td>
                    <td>
                      <Badge bg="info">{order.TrangThai}</Badge>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          )}
        </Card.Body>
      </Card>
    </AdminLayout>
  );
};

export default AdminDashboardPage;
