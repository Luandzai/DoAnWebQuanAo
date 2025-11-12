import React, { useState, useEffect, useContext, useMemo } from "react";
import {
  Card,
  Row,
  Col,
  Spinner,
  Table,
  Alert,
  Badge,
  Form,
  Button, // FIX: Đã thêm Button
} from "react-bootstrap";
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
    totalUsersCount: 0,
    latestOrders: [],
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  // STATES CHO BIỂU ĐỒ (Đã có)
  const [salesData, setSalesData] = useState([]);
  const currentYear = new Date().getFullYear();
  const [selectedYear, setSelectedYear] = useState(currentYear);
  const [chartLoading, setChartLoading] = useState(false);

  // === PHẦN CODE MỚI THÊM VÀO ===
  // STATES MỚI CHO BÁO CÁO SẢN PHẨM / KHÁCH HÀNG
  const [topProducts, setTopProducts] = useState([]);
  const [tpLimit, setTpLimit] = useState(10);
  const [loadingTopProducts, setLoadingTopProducts] = useState(false);

  const [lowStock, setLowStock] = useState([]);
  const [lsThreshold, setLsThreshold] = useState(10);
  const [lsLimit, setLsLimit] = useState(50);
  const [loadingLowStock, setLoadingLowStock] = useState(false);

  const [topCustomers, setTopCustomers] = useState([]);
  const [tcLimit, setTcLimit] = useState(10);
  const [loadingTopCustomers, setLoadingTopCustomers] = useState(false);
  // === KẾT THÚC PHẦN CODE MỚI ===

  // Hàm định dạng tiền tệ
  const formatCurrency = (amount) => {
    // FIX: Thêm kiểm tra an toàn
    if (typeof amount !== 'number') {
      amount = 0;
    }
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(amount);
  };

  // HÀM FETCH DỮ LIỆU BIỂU ĐỒ (Đã có)
  const fetchSalesData = async (year) => {
    setChartLoading(true);
    try {
      const { data } = await api.get(`/admin/sales/monthly?year=${year}`);
      // FIX: Thêm kiểm tra an toàn
      setSalesData(data.salesData || []);
    } catch (err) {
      console.error("Lỗi tải dữ liệu biểu đồ:", err);
      setSalesData([]); // Đặt lại mảng rỗng khi lỗi
    } finally {
      setChartLoading(false);
    }
  };

  // === PHẦN CODE MỚI THÊM VÀO ===
  // HÀM FETCH CHO BÁO CÁO MỚI
  const fetchTopProducts = async () => {
    setLoadingTopProducts(true);
    try {
      const { data } = await api.get(
        `/admin/products/top?year=${selectedYear}&limit=${tpLimit}`
      );
      setTopProducts(data.products || []);
    } catch (err) {
      console.error("Lỗi khi lấy sản phẩm bán chạy:", err);
    } finally {
      setLoadingTopProducts(false);
    }
  };

  const fetchLowStock = async () => {
    setLoadingLowStock(true);
    try {
      const { data } = await api.get(
        `/admin/products/low-stock?threshold=${lsThreshold}&limit=${lsLimit}`
      );
      setLowStock(data.products || []);
    } catch (err) {
      console.error("Lỗi khi lấy sản phẩm sắp hết hàng:", err);
    } finally {
      setLoadingLowStock(false);
    }
  };

  const fetchTopCustomers = async () => {
    setLoadingTopCustomers(true);
    try {
      const { data } = await api.get(
        `/admin/customers/top?year=${selectedYear}&limit=${tcLimit}`
      );
      setTopCustomers(data.customers || []);
    } catch (err) {
      console.error("Lỗi khi lấy khách hàng tiềm năng:", err);
    } finally {
      setLoadingTopCustomers(false);
    }
  };
  // === KẾT THÚC PHẦN CODE MỚI ===

  // Tải dữ liệu chính (Dashboard Stats)
  useEffect(() => {
    const fetchStats = async () => {
      setLoading(true);
      try {
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
    // FIX: Thêm kiểm tra an toàn
    if (!api) return; 
    fetchStats();
  }, [api]);

  // Tải dữ liệu biểu đồ khi năm thay đổi
  useEffect(() => {
    // FIX: Thêm kiểm tra an toàn
    if (!api) return;
    fetchSalesData(selectedYear);
  }, [api, selectedYear]);

  // === PHẦN CODE MỚI THÊM VÀO ===
  // Tự động tải báo cáo khi component mount / tham số thay đổi
  useEffect(() => {
    if (!api) return;
    fetchTopProducts();
  }, [api, selectedYear, tpLimit]);

  useEffect(() => {
    if (!api) return;
    fetchLowStock();
  }, [api, lsThreshold, lsLimit]);

  useEffect(() => {
    if (!api) return;
    fetchTopCustomers();
  }, [api, selectedYear, tcLimit]);
  // === KẾT THÚC PHẦN CODE MỚI ===


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
      "T1", "T2", "T3", "T4", "T5", "T6",
      "T7", "T8", "T9", "T10", "T11", "T12",
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

      {/* 2. KHU VỰC BIỂU ĐỒ DOANH THU */}
      <Card className="shadow-sm mt-4">
        <Card.Header className="d-flex justify-content-between align-items-center">
          Doanh thu theo tháng
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
            <Bar options={chartOptions} data={chartData} />
          )}
        </Card.Body>
      </Card>

      {/* 3. DANH SÁCH ĐƠN HÀNG GẦN ĐÂY */}
      <Card className="shadow-sm mt-4">
        <Card.Header>Đơn hàng chờ xử lý (5 đơn gần nhất)</Card.Header>
        <Card.Body>
          {/* FIX: Thêm kiểm tra loading và !stats.latestOrders */}
          {loading ? (
             <div className="text-center py-3">
               <Spinner animation="border" size="sm" />
             </div>
          ) : !stats.latestOrders || stats.latestOrders.length === 0 ? (
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

      {/* === PHẦN CODE MỚI THÊM VÀO === */}
      {/* 4. KHU VỰC BÁO CÁO MỚI */}
      <Row className="g-3 mt-4">
        {/* SẢN PHẨM BÁN CHẠY */}
        <Col lg={6}>
          <Card>
            <Card.Header className="d-flex justify-content-between align-items-center">
              <div>
                <strong>Sản phẩm bán chạy</strong>
                <div className="text-muted small">Năm: {selectedYear}</div>
              </div>
              <div className="d-flex gap-2">
                <Form.Control
                  type="number"
                  value={tpLimit}
                  min={1}
                  onChange={(e) => setTpLimit(Number(e.target.value) || 1)}
                  size="sm"
                  style={{ width: '70px' }}
                />
                <Button size="sm" onClick={fetchTopProducts}>
                  Tải lại
                </Button>
              </div>
            </Card.Header>
            <Card.Body>
              {loadingTopProducts ? (
                <div className="text-center py-3">
                  <Spinner animation="border" />
                </div>
              ) : topProducts.length === 0 ? (
                <div>Không có dữ liệu.</div>
              ) : (
                <Table hover responsive size="sm">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Sản phẩm</th>
                      <th>Phiên bản</th>
                      <th>Số lượng bán</th>
                      <th>Doanh thu</th>
                    </tr>
                  </thead>
                  <tbody>
                    {topProducts.map((p, idx) => (
                      <tr key={p.PhienBanSanPhamID || idx}>
                        <td>{idx + 1}</td>
                        <td>{p.TenSanPham}</td>
                        <td>{p.TenPhienBan}</td>
                        <td>{p.totalSold}</td>
                        <td>{formatCurrency(Number(p.totalRevenue))}</td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              )}
            </Card.Body>
          </Card>
        </Col>

        {/* SẢN PHẨM SẮP HẾT HÀNG */}
        <Col lg={6}>
          <Card>
            <Card.Header className="d-flex justify-content-between align-items-center">
              <div>
                <strong>Sản phẩm sắp hết hàng</strong>
                <div className="text-muted small">Ngưỡng: ≤ {lsThreshold}</div>
              </div>
              <div className="d-flex gap-2">
                <Form.Control
                  type="number"
                  placeholder="Ngưỡng"
                  value={lsThreshold}
                  min={0}
                  onChange={(e) => setLsThreshold(Number(e.target.value) || 0)}
                  size="sm"
                  style={{ width: '70px' }}
                />
                <Form.Control
                  type="number"
                  placeholder="SL"
                  value={lsLimit}
                  min={1}
                  onChange={(e) => setLsLimit(Number(e.target.value) || 1)}
                  size="sm"
                  style={{ width: '70px' }}
                />
                <Button size="sm" onClick={fetchLowStock}>
                  Tải lại
                </Button>
              </div>
            </Card.Header>
            <Card.Body>
              {loadingLowStock ? (
                <div className="text-center py-3">
                  <Spinner animation="border" />
                </div>
              ) : lowStock.length === 0 ? (
                <div>Không có sản phẩm thỏa điều kiện.</div>
              ) : (
                <Table hover responsive size="sm">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Sản phẩm</th>
                      <th>Phiên bản</th>
                      <th>Tồn kho</th>
                    </tr>
                  </thead>
                  <tbody>
                    {lowStock.map((p, idx) => (
                      <tr key={p.PhienBanSanPhamID || idx}>
                        <td>{idx + 1}</td>
                        <td>{p.TenSanPham}</td>
                        <td>{p.TenPhienBan}</td>
                        <td>
                          <Badge bg={p.SoLuongTonKho <= 5 ? "danger" : "warning"}>
                            {p.SoLuongTonKho}
                          </Badge>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              )}
            </Card.Body>
          </Card>
        </Col>

        {/* KHÁCH HÀNG TIỀM NĂNG */}
        <Col lg={12}>
          <Card className="mt-3">
            <Card.Header className="d-flex justify-content-between align-items-center">
              <div>
                <strong>Khách hàng tiềm năng</strong>
                <div className="text-muted small">Năm: {selectedYear}</div>
              </div>
              <div className="d-flex gap-2">
                <Form.Control
                  type="number"
                  value={tcLimit}
                  min={1}
                  onChange={(e) => setTcLimit(Number(e.target.value) || 1)}
                  size="sm"
                  style={{ width: '70px' }}
                />
                <Button size="sm" onClick={fetchTopCustomers}>
                  Tải lại
                </Button>
              </div>
            </Card.Header>
            <Card.Body>
              {loadingTopCustomers ? (
                <div className="text-center py-3">
                  <Spinner animation="border" />
                </div>
              ) : topCustomers.length === 0 ? (
                <div>Không có khách hàng nào.</div>
              ) : (
                <Table hover responsive size="sm">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>Khách hàng</th>
                      <th>Email</th>
                      <th>Số đơn</th>
                      <th>Tổng chi</th>
                    </tr>
                  </thead>
                  <tbody>
                    {topCustomers.map((c, idx) => (
                      <tr key={c.NguoiDungID || idx}>
                        <td>{idx + 1}</td>
                        <td>{c.HoTen}</td>
                        <td>{c.Email}</td>
                        <td>{c.orderCount}</td>
                        <td>{formatCurrency(Number(c.totalSpent))}</td>
                      </tr>
                    ))}
                  </tbody>
                </Table>
              )}
            </Card.Body>
          </Card>
        </Col>
      </Row>
      {/* === KẾT THÚC PHẦN CODE MỚI === */}
    </AdminLayout>
  );
};

export default AdminDashboardPage;