// // client/src/pages/AdminProductListPage.jsx (HOÀN CHỈNH)

// import React, { useState, useEffect, useContext } from "react";
// import {
//   Container,
//   Row,
//   Col,
//   Card,
//   Button,
//   Table,
//   Spinner,
//   Alert,
//   Image,
//   Badge,
// } from "react-bootstrap";
// import AdminLayout from "../components/AdminLayout";
// import AuthContext from "../context/AuthContext";
// import { Plus, PencilSquare, Trash, EyeFill } from "react-bootstrap-icons";
// import { toast } from "react-toastify";
// import { Link } from "react-router-dom";
// import AdminProductModal from "../components/AdminProductModal.jsx"; // <-- ĐÃ IMPORT

// const AdminProductListPage = () => {
//   const [products, setProducts] = useState([]);
//   const [loading, setLoading] = useState(true);
//   const [error, setError] = useState(null);
//   const [deletingId, setDeletingId] = useState(null);
//   const { api } = useContext(AuthContext);

//   // States cho Modal
//   const [showModal, setShowModal] = useState(false);
//   const [isEditMode, setIsEditMode] = useState(false);
//   const [productToEdit, setProductToEdit] = useState(null);

//   // Hàm tải dữ liệu
//   const fetchProducts = async () => {
//     setLoading(true);
//     try {
//       // Gọi API Admin mới
//       const { data } = await api.get("/admin/products");
//       setProducts(data);
//     } catch (err) {
//       setError(
//         err.response?.data?.message || "Không thể tải danh sách sản phẩm."
//       );
//     } finally {
//       setLoading(false);
//     }
//   };

//   useEffect(() => {
//     fetchProducts();
//   }, [api]);

//   const formatCurrency = (amount) => {
//     return new Intl.NumberFormat("vi-VN", {
//       style: "currency",
//       currency: "VND",
//       minimumFractionDigits: 0,
//     }).format(amount);
//   };

//   // Hàm xử lý xóa (Archive)
//   const handleDelete = async (id) => {
//     if (
//       !window.confirm(
//         "Bạn có chắc chắn muốn XÓA (ARCHIVE) sản phẩm này không? Sản phẩm sẽ bị ẩn khỏi trang người dùng."
//       )
//     )
//       return;

//     setDeletingId(id);
//     try {
//       // Sử dụng route DELETE đã được bảo vệ Admin
//       // Hàm này thực chất là UPDATE TrangThai = 'ARCHIVED' trong Backend
//       await api.delete(`/products/${id}`);
//       toast.success(
//         "Đã xóa sản phẩm thành công (chuyển sang trạng thái ARCHIVED)."
//       );
//       fetchProducts(); // Tải lại danh sách
//     } catch (err) {
//       toast.error(err.response?.data?.message || "Xóa thất bại.");
//     } finally {
//       setDeletingId(null);
//     }
//   };

//   // === CÁC HÀM XỬ LÝ MODAL (ĐÃ SỬA LỖI LOGIC NÚT) ===
//   const handleShowAddModal = () => {
//     setIsEditMode(false);
//     setProductToEdit(null);
//     setShowModal(true);
//   };

//   const handleShowEditModal = (product) => {
//     setIsEditMode(true);
//     setProductToEdit(product);
//     setShowModal(true);
//   };

//   const handleProductUpdated = () => {
//     fetchProducts(); // Tải lại danh sách khi có cập nhật
//   };
//   // ==================================================

//   return (
//     <AdminLayout>
//       <Card className="shadow-sm">
//         <Card.Header className="d-flex justify-content-between align-items-center">
//           <h5>Quản lý Sản phẩm ({products.length})</h5>
//           <Button variant="primary" size="sm" onClick={handleShowAddModal}>
//             <Plus /> Thêm Sản phẩm
//           </Button>
//         </Card.Header>
//         <Card.Body>
//           {loading ? (
//             <div className="text-center">
//               <Spinner animation="border" size="sm" /> Đang tải...
//             </div>
//           ) : error ? (
//             <Alert variant="danger">{error}</Alert>
//           ) : (
//             <Table striped hover responsive size="sm" className="align-middle">
//               <thead>
//                 <tr>
//                   <th>ID</th>
//                   <th>Ảnh</th>
//                   <th>Tên Sản phẩm</th>
//                   <th>Giá bán</th>
//                   <th>Tồn kho</th>
//                   <th>Trạng thái</th>
//                   <th>Thao tác</th>
//                 </tr>
//               </thead>
//               <tbody>
//                 {products.map((p) => {
//                   let statusBg = "secondary";
//                   if (p.TrangThai === "ACTIVE") statusBg = "success";
//                   if (p.TrangThai === "DRAFT") statusBg = "warning";
//                   if (p.TrangThai === "ARCHIVED") statusBg = "danger";

//                   return (
//                     <tr key={p.SanPhamID}>
//                       <td>{p.SanPhamID}</td>
//                       <td>
//                         <Image
//                           src={
//                             p.HinhAnhChinh ||
//                             "https://placehold.co/50x50?text=No+Img"
//                           }
//                           style={{
//                             width: "50px",
//                             height: "50px",
//                             objectFit: "cover",
//                           }}
//                           thumbnail
//                         />
//                       </td>
//                       <td>{p.TenSanPham}</td>
//                       <td>{formatCurrency(p.GiaBanThapNhat)}</td>
//                       <td>{p.TongTonKho}</td>
//                       <td>
//                         <Badge bg={statusBg}>{p.TrangThai}</Badge>
//                       </td>
//                       <td>
//                         <Button
//                           as={Link}
//                           to={`/product/${p.Slug}`}
//                           variant="info"
//                           size="sm"
//                           className="me-2"
//                           title="Xem trên website"
//                         >
//                           <EyeFill />
//                         </Button>
//                         <Button
//                           variant="warning"
//                           size="sm"
//                           className="me-2"
//                           onClick={() => handleShowEditModal(p)} // <-- GỌI HÀM SỬA
//                         >
//                           <PencilSquare />
//                         </Button>
//                         <Button
//                           variant="danger"
//                           size="sm"
//                           onClick={() => handleDelete(p.SanPhamID)}
//                           disabled={deletingId === p.SanPhamID}
//                         >
//                           <Trash />
//                         </Button>
//                       </td>
//                     </tr>
//                   );
//                 })}
//               </tbody>
//             </Table>
//           )}
//         </Card.Body>
//       </Card>

//       {/* MODAL THÊM/SỬA SẢN PHẨM */}
//       <AdminProductModal
//         show={showModal}
//         onHide={() => setShowModal(false)}
//         onProductUpdated={handleProductUpdated}
//         isEdit={isEditMode}
//         productToEdit={productToEdit}
//       />
//     </AdminLayout>
//   );
// };

// export default AdminProductListPage;
// client/src/pages/AdminProductListPage.jsx (HOÀN CHỈNH FILTER & PAGINATION)

import React, { useState, useEffect, useContext, useCallback } from "react";
import {
  Container,
  Row,
  Col,
  Card,
  Button,
  Table,
  Spinner,
  Alert,
  Image,
  Badge,
  Form, // Thêm Form
  InputGroup, // Thêm InputGroup
  Pagination, // Thêm Pagination
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import {
  Plus,
  PencilSquare,
  Trash,
  EyeFill,
  Search, // Thêm Search icon
  ArrowDownUp, // Thêm ArrowDownUp icon
} from "react-bootstrap-icons";
import { toast } from "react-toastify";
import { Link } from "react-router-dom";
import AdminProductModal from "../components/AdminProductModal.jsx";

const STATUS_OPTIONS = {
  ACTIVE: { name: "Đang bán", color: "success" },
  DRAFT: { name: "Bản nháp", color: "warning" },
  ARCHIVED: { name: "Đã ẩn/Xóa", color: "danger" },
};

const SORT_OPTIONS = {
  DATE_DESC: { key: "DATE_DESC", name: "Mới nhất trước" },
  DATE_ASC: { key: "DATE_ASC", name: "Cũ nhất trước" },
  PRICE_ASC: { key: "PRICE_ASC", name: "Giá tăng dần" },
  PRICE_DESC: { key: "PRICE_DESC", name: "Giá giảm dần" },
  STOCK_DESC: { key: "STOCK_DESC", name: "Tồn kho nhiều nhất" },
  STOCK_ASC: { key: "STOCK_ASC", name: "Tồn kho ít nhất" },
};

const AdminProductListPage = () => {
  // Data states
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [deletingId, setDeletingId] = useState(null);
  const { api } = useContext(AuthContext);

  // States cho Modal
  const [showModal, setShowModal] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [productToEdit, setProductToEdit] = useState(null);

  // === STATES CHO FILTER VÀ PAGINATION ===
  const [searchTerm, setSearchTerm] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [sortBy, setSortBy] = useState(SORT_OPTIONS.DATE_DESC.key);
  const [pageSize, setPageSize] = useState(10);
  const [currentPage, setCurrentPage] = useState(1);
  const [pagination, setPagination] = useState({
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  });
  // ============================================

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: 0,
    }).format(amount);
  };

  // Hàm tải dữ liệu (Sử dụng useCallback)
  const fetchProducts = useCallback(
    async (filters = {}) => {
      setLoading(true);
      try {
        const params = new URLSearchParams();

        if (filters.search) params.append("search", filters.search);
        if (filters.status) params.append("status", filters.status);
        if (filters.sortBy) params.append("sortBy", filters.sortBy);
        if (filters.page) params.append("page", filters.page);
        if (filters.limit) params.append("limit", filters.limit);

        // Gọi API Admin
        const { data } = await api.get(`/admin/products?${params.toString()}`);

        // Dữ liệu trả về bây giờ là object {products, pagination}
        setProducts(data.products || []);
        setPagination(
          data.pagination || {
            total: 0,
            page: 1,
            limit: 10,
            totalPages: 0,
          }
        );
        setError(null);
      } catch (err) {
        setError(
          err.response?.data?.message || "Không thể tải danh sách sản phẩm."
        );
      } finally {
        setLoading(false);
      }
    },
    [api]
  );

  // 1. Load products khi filter (trừ searchTerm) hoặc currentPage thay đổi (Không debounce)
  // Logic này sẽ lo việc chuyển trang khi người dùng click
  useEffect(() => {
    fetchProducts({
      search: searchTerm,
      status: statusFilter,
      sortBy: sortBy,
      page: currentPage,
      limit: pageSize,
    });
  }, [statusFilter, sortBy, currentPage, pageSize, fetchProducts]); // BỎ searchTerm

  // 2. Xử lý debounce cho searchTerm (và reset trang nếu cần)
  useEffect(() => {
    const timeoutId = setTimeout(() => {
      // Khi searchTerm thay đổi, nếu người dùng đang ở trang > 1, reset về trang 1
      if (currentPage !== 1) {
        setCurrentPage(1);
      } else {
        // Nếu đã ở trang 1, gọi fetchOrders để debounce việc tìm kiếm (với page 1)
        fetchProducts({
          search: searchTerm,
          status: statusFilter,
          sortBy: sortBy,
          page: 1, // Dùng page 1 cho lần fetch này
          limit: pageSize,
        });
      }
    }, 500);

    return () => clearTimeout(timeoutId);
  }, [searchTerm, fetchProducts]); // CHỈ THEO DÕI searchTerm và fetchProducts

  // Hàm xử lý xóa (Archive)
  const handleDelete = async (id) => {
    if (
      !window.confirm(
        "Bạn có chắc chắn muốn XÓA (ARCHIVE) sản phẩm này không? Sản phẩm sẽ bị ẩn khỏi trang người dùng."
      )
    )
      return;

    setDeletingId(id);
    try {
      // Sử dụng route DELETE đã được bảo vệ Admin
      await api.delete(`/products/${id}`);
      toast.success(
        "Đã xóa sản phẩm thành công (chuyển sang trạng thái ARCHIVED)."
      );
      // Tải lại danh sách sau khi xóa
      fetchProducts({
        search: searchTerm,
        status: statusFilter,
        sortBy: sortBy,
        page: currentPage,
        limit: pageSize,
      });
    } catch (err) {
      toast.error(err.response?.data?.message || "Xóa thất bại.");
    } finally {
      setDeletingId(null);
    }
  };

  // === CÁC HÀM XỬ LÝ MODAL ===
  const handleShowAddModal = () => {
    setIsEditMode(false);
    setProductToEdit(null);
    setShowModal(true);
  };

  const handleShowEditModal = (product) => {
    setIsEditMode(true);
    setProductToEdit(product);
    setShowModal(true);
  };

  const handleProductUpdated = () => {
    // Tải lại danh sách khi có cập nhật
    fetchProducts({
      search: searchTerm,
      status: statusFilter,
      sortBy: sortBy,
      page: currentPage,
      limit: pageSize,
    });
  };
  // ==================================================

  return (
    <AdminLayout>
      <Card className="shadow-sm">
        {/* === START: HEADER CÓ FILTER VÀ SORT === */}
        <Card.Header className="bg-white">
          <Row className="align-items-center">
            <Col md={3}>
              <h5 className="mb-0">Quản lý Sản phẩm ({pagination.total})</h5>
            </Col>

            {/* 1. Tìm kiếm */}
            <Col md={3}>
              <InputGroup size="sm">
                <InputGroup.Text>
                  <Search />
                </InputGroup.Text>
                <Form.Control
                  placeholder="Tìm theo tên, SKU..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
              </InputGroup>
            </Col>

            {/* 2. Lọc trạng thái */}
            <Col md={2}>
              <Form.Select
                size="sm"
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="">Tất cả trạng thái</option>
                {Object.entries(STATUS_OPTIONS).map(([key, value]) => (
                  <option key={key} value={key}>
                    {value.name}
                  </option>
                ))}
              </Form.Select>
            </Col>

            {/* 3. Sắp xếp */}
            <Col md={2}>
              <Form.Select
                size="sm"
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
              >
                {Object.values(SORT_OPTIONS).map((option) => (
                  <option key={option.key} value={option.key}>
                    {option.name}
                  </option>
                ))}
              </Form.Select>
            </Col>

            {/* 4. Page Size và Nút Thêm */}
            <Col
              md={2}
              className="d-flex justify-content-end align-items-center"
            >
              <Form.Select
                size="sm"
                value={pageSize}
                onChange={(e) => setPageSize(Number(e.target.value))}
                className="me-2"
              >
                {[10, 20, 50].map((size) => (
                  <option key={size} value={size}>
                    {size} dòng / trang
                  </option>
                ))}
              </Form.Select>
              <Button variant="primary" size="sm" onClick={handleShowAddModal}>
                <Plus />
              </Button>
            </Col>
          </Row>
        </Card.Header>
        {/* === END: HEADER CÓ FILTER VÀ SORT === */}

        <Card.Body className="p-0">
          {loading ? (
            <div className="text-center py-5">
              <Spinner animation="border" size="sm" /> Đang tải...
            </div>
          ) : error ? (
            <Alert variant="danger" className="m-3">
              {error}
            </Alert>
          ) : products.length === 0 ? (
            <div className="text-center py-5">
              <p className="mb-0 text-muted">Không tìm thấy sản phẩm nào</p>
            </div>
          ) : (
            <>
              <Table hover responsive className="align-middle mb-0">
                <thead className="bg-light">
                  <tr>
                    <th>ID</th>
                    <th>Ảnh</th>
                    <th>Tên Sản phẩm</th>
                    <th>
                      <div className="d-flex align-items-center">
                        Giá bán
                        <ArrowDownUp className="ms-1" />
                      </div>
                    </th>
                    <th>
                      <div className="d-flex align-items-center">
                        Tồn kho
                        <ArrowDownUp className="ms-1" />
                      </div>
                    </th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {products.map((p) => {
                    const statusConfig = STATUS_OPTIONS[p.TrangThai] || {
                      name: p.TrangThai,
                      color: "secondary",
                    };
                    return (
                      <tr key={p.SanPhamID}>
                        <td>{p.SanPhamID}</td>
                        <td>
                          <Image
                            src={
                              p.HinhAnhChinh ||
                              "https://placehold.co/50x50?text=No+Img"
                            }
                            style={{
                              width: "50px",
                              height: "50px",
                              objectFit: "cover",
                            }}
                            thumbnail
                          />
                        </td>
                        <td>{p.TenSanPham}</td>
                        <td>{formatCurrency(p.GiaBanThapNhat)}</td>
                        <td>{p.TongTonKho}</td>
                        <td>
                          <Badge bg={statusConfig.color}>
                            {statusConfig.name}
                          </Badge>
                        </td>
                        <td>
                          <Button
                            as={Link}
                            to={`/product/${p.Slug}`}
                            variant="info"
                            size="sm"
                            className="me-2"
                            title="Xem trên website"
                          >
                            <EyeFill />
                          </Button>
                          <Button
                            variant="warning"
                            size="sm"
                            className="me-2"
                            onClick={() => handleShowEditModal(p)}
                          >
                            <PencilSquare />
                          </Button>
                          <Button
                            variant="danger"
                            size="sm"
                            onClick={() => handleDelete(p.SanPhamID)}
                            disabled={deletingId === p.SanPhamID}
                          >
                            <Trash />
                          </Button>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </Table>

              {/* === PHÂN TRANG === */}
              <div className="d-flex justify-content-center p-3">
                {pagination.totalPages > 1 && (
                  <Pagination>
                    <Pagination.First
                      onClick={() => setCurrentPage(1)}
                      disabled={currentPage === 1}
                    />
                    <Pagination.Prev
                      onClick={() => setCurrentPage(currentPage - 1)}
                      disabled={currentPage === 1}
                    />

                    {[...Array(pagination.totalPages)].map((_, idx) => (
                      <Pagination.Item
                        key={idx + 1}
                        active={idx + 1 === currentPage}
                        onClick={() => setCurrentPage(idx + 1)}
                      >
                        {idx + 1}
                      </Pagination.Item>
                    ))}

                    <Pagination.Next
                      onClick={() => setCurrentPage(currentPage + 1)}
                      disabled={currentPage === pagination.totalPages}
                    />
                    <Pagination.Last
                      onClick={() => setCurrentPage(pagination.totalPages)}
                      disabled={currentPage === pagination.totalPages}
                    />
                  </Pagination>
                )}
              </div>
              {/* === END PHÂN TRANG === */}
            </>
          )}
        </Card.Body>
      </Card>

      {/* MODAL THÊM/SỬA SẢN PHẨM */}
      <AdminProductModal
        show={showModal}
        onHide={() => setShowModal(false)}
        onProductUpdated={handleProductUpdated}
        isEdit={isEditMode}
        productToEdit={productToEdit}
      />
    </AdminLayout>
  );
};

export default AdminProductListPage;
