// client/src/pages/ProductListPage.jsx (Đã thêm Phân trang)

import React, { useState, useEffect, useContext } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import {
  Container,
  Row,
  Col,
  Spinner,
  Dropdown,
  DropdownButton,
  Pagination,
  Badge,
  Alert,
} from "react-bootstrap";
import AuthContext from "../context/AuthContext";
import Sidebar from "../components/Sidebar";
import ProductCard from "../components/ProductCard";

// Hằng số giới hạn sản phẩm mỗi trang (đã thống nhất với Back-end)
const PRODUCTS_PER_PAGE = 15;

// (Hàm buildCategoryTree giữ nguyên)
const buildCategoryTree = (categories) => {
  const map = {};
  const tree = [];
  categories.forEach((cat) => {
    map[cat.DanhMucID] = { ...cat, children: [] };
  });
  Object.values(map).forEach((cat) => {
    if (cat.DanhMucChaID) {
      if (map[cat.DanhMucChaID]) {
        map[cat.DanhMucChaID].children.push(cat);
      }
    } else {
      tree.push(cat);
    }
  });
  return tree;
};

const ProductListPage = () => {
  const location = useLocation();
  const navigate = useNavigate();

  // State filters (Sẽ được điền động)
  const [filters, setFilters] = useState({
    danhMuc: [],
    khoangGia: [],
  });

  // State cho danh mục
  const [categoryTree, setCategoryTree] = useState([]);
  const [categoriesLoading, setCategoriesLoading] = useState(true);

  // State mới cho phân trang
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  // === STATE MỚI CHO THUỘC TÍNH ===
  const [attributes, setAttributes] = useState([]);
  const [attributesLoading, setAttributesLoading] = useState(true);
  // ================================

  const [searchKeyword, setSearchKeyword] = useState("");
  const [sortBy, setSortBy] = useState("newest");
  const [sortTitle, setSortTitle] = useState("Sắp xếp");
  const [isLoading, setIsLoading] = useState(true);
  const [products, setProducts] = useState([]);
  const [error, setError] = useState(null);
  const { api } = useContext(AuthContext);

  // useEffect để đọc query params từ URL (Cập nhật để đọc Page)
  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const categoryFromURL = params.get("category");
    const searchFromURL = params.get("search");
    const pageFromURL = parseInt(params.get("page")) || 1; // <-- Đọc page từ URL

    setFilters((prev) => ({
      ...prev,
      danhMuc: categoryFromURL ? [categoryFromURL] : [],
    }));
    setSearchKeyword(searchFromURL || "");
    setCurrentPage(pageFromURL); // <-- Cập nhật page
  }, [location.search]);

  // useEffect để TẢI DANH MỤC VÀ THUỘC TÍNH
  useEffect(() => {
    const fetchSidebarData = async () => {
      try {
        setCategoriesLoading(true);
        setAttributesLoading(true);

        const catPromise = api.get("/categories");
        const attrPromise = api.get("/attributes");

        const [catRes, attrRes] = await Promise.all([catPromise, attrPromise]);

        const tree = buildCategoryTree(catRes.data);
        setCategoryTree(tree);
        setCategoriesLoading(false);

        setAttributes(attrRes.data);
        // Tự động thêm các key (ví dụ: 'kich-co') vào 'filters' state
        const initialFilters = { danhMuc: [], khoangGia: [] };
        attrRes.data.forEach((attr) => {
          initialFilters[attr.Slug] = []; // Ví dụ: kich-co: [], mau-sac: []
        });
        setFilters(initialFilters);
        setAttributesLoading(false);
      } catch (err) {
        console.error("Lỗi tải dữ liệu Sidebar:", err);
        setCategoriesLoading(false);
        setAttributesLoading(false);
      }
    };
    fetchSidebarData();
  }, [api]);

  // useEffect chính để TẢI SẢN PHẨM
  useEffect(() => {
    if (categoriesLoading || attributesLoading) return;

    const fetchProducts = async () => {
      setIsLoading(true);
      setError(null);

      try {
        const params = new URLSearchParams();

        Object.keys(filters).forEach((key) => {
          if (filters[key].length > 0) {
            params.append(key, filters[key].join(","));
          }
        });

        if (searchKeyword) params.append("search", searchKeyword);
        if (sortBy) params.append("sortBy", sortBy);

        // GỬI THAM SỐ PHÂN TRANG
        params.append("page", currentPage);
        // params.append('limit', PRODUCTS_PER_PAGE); // (Back-end dùng hằng số)

        const response = await api.get("/products", { params });

        // CẬP NHẬT PHÂN TRANG
        setProducts(response.data.products);
        setTotalPages(response.data.totalPages);
      } catch {
        setError("Không thể tải danh sách sản phẩm. Vui lòng thử lại.");
      } finally {
        setIsLoading(false);
      }
    };

    fetchProducts();
  }, [
    api,
    filters,
    sortBy,
    searchKeyword,
    categoriesLoading,
    attributesLoading,
    currentPage,
  ]); // <-- Thêm currentPage

  // === HÀM MỚI: XỬ LÝ CHUYỂN TRANG ===
  const handlePageChange = (page) => {
    if (page < 1 || page > totalPages) return;

    setCurrentPage(page);

    // Cập nhật URL (dùng navigate)
    const params = new URLSearchParams(location.search);
    params.set("page", page);
    navigate({ search: params.toString() });

    window.scrollTo(0, 0); // Cuộn lên đầu trang
  };

  // (Các hàm handler giữ nguyên)
  const handleFilterChange = (filterType, value, isChecked) => {
    setFilters((prevState) => {
      const newValues = { ...prevState };
      const currentValues = newValues[filterType] || [];

      if (isChecked) {
        newValues[filterType] = [...currentValues, value];
      } else {
        newValues[filterType] = currentValues.filter((item) => item !== value);
      }
      return newValues;
    });
  };

  // Hàm xử lý Sắp xếp
  const handleSortChange = (key, title) => {
    setSortBy(key);
    setSortTitle(title);
  };

  // Hàm xóa Badge (MỚI)
  const removeSearch = () => {
    setSearchKeyword("");
    // Cập nhật URL (xóa param 'search')
    const params = new URLSearchParams(location.search);
    params.delete("search");
    navigate({ search: params.toString() });
  };

  // Component con để render lưới sản phẩm (tự xử lý Loading/Error)
  const ProductGrid = () => {
    if (isLoading) {
      return (
        <div className="text-center py-5" style={{ minHeight: "300px" }}>
          <Spinner animation="border" />
        </div>
      );
    }
    if (error) {
      return <Alert variant="danger">{error}</Alert>;
    }
    if (products.length === 0) {
      return (
        <Col>
          <p>Không có sản phẩm nào khớp.</p>
        </Col>
      );
    }
    return (
      <Row>
        {products.map((product) => (
          <Col key={product.SanPhamID} sm={6} lg={4}>
            <ProductCard product={product} />
          </Col>
        ))}
      </Row>
    );
  };
  // Component Phân trang
  const renderPagination = () => {
    let items = [];
    // Hiển thị tối đa 5 nút phân trang
    let startPage = Math.max(1, currentPage - 2);
    let endPage = Math.min(totalPages, currentPage + 2);

    for (let number = startPage; number <= endPage; number++) {
      items.push(
        <Pagination.Item
          key={number}
          active={number === currentPage}
          onClick={() => handlePageChange(number)}
        >
          {number}
        </Pagination.Item>
      );
    }
    return (
      <Pagination className="justify-content-center mt-4">
        <Pagination.Prev
          onClick={() => handlePageChange(currentPage - 1)}
          disabled={currentPage === 1}
        />
        {startPage > 1 && <Pagination.Ellipsis />}
        {items}
        {endPage < totalPages && <Pagination.Ellipsis />}
        <Pagination.Next
          onClick={() => handlePageChange(currentPage + 1)}
          disabled={currentPage === totalPages}
        />
      </Pagination>
    );
  };

  // Hàm return chính
  return (
    <Container fluid className="py-5">
      <Row>
        <Col md={3}>
          {/* Truyền 'categoryTree' và 'loading' xuống Sidebar */}
          <Sidebar
            onFilterChange={handleFilterChange}
            activeFilters={filters}
            categoryTree={categoryTree}
            attributes={attributes}
            isLoading={categoriesLoading || attributesLoading}
          />
        </Col>
        <Col md={9}>
          <div className="d-flex justify-content-between align-items-center mb-3">
            {/* Hiển thị Badge cho từ khóa tìm kiếm */}
            <div>
              <span className="me-2">
                {searchKeyword ? "Kết quả cho:" : ""}
              </span>
              {searchKeyword && (
                <Badge
                  pill
                  bg="info"
                  className="me-1"
                  style={{ cursor: "pointer" }}
                  onClick={removeSearch}
                >
                  {searchKeyword} <span className="fw-bold">X</span>
                </Badge>
              )}
            </div>

            <div>
              <span className="me-2 text-muted">
                {!isLoading && `Tìm thấy ${products.length} sản phẩm!`}
              </span>
              <DropdownButton
                id="dropdown-sort"
                title={sortTitle}
                size="sm"
                onSelect={(key) =>
                  handleSortChange(
                    key,
                    key === "newest"
                      ? "Mới nhất"
                      : key === "price-asc"
                      ? "Giá: Thấp đến cao"
                      : "Giá: Cao đến thấp"
                  )
                }
              >
                <Dropdown.Item eventKey="newest">Mới nhất</Dropdown.Item>
                <Dropdown.Item eventKey="price-asc">
                  Giá: Thấp đến cao
                </Dropdown.Item>
                <Dropdown.Item eventKey="price-desc">
                  Giá: Cao đến thấp
                </Dropdown.Item>
              </DropdownButton>
            </div>
          </div>

          <ProductGrid />
          {/* SỬ DỤNG COMPONENT PHÂN TRANG MỚI */}
          {totalPages > 1 && renderPagination()}
        </Col>
      </Row>
    </Container>
  );
};

export default ProductListPage;
