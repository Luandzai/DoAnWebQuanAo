// client/src/pages/ProductDetailPage.jsx (ĐÃ SỬA LỖI VOUCHER)

import React, { useState, useEffect, useContext } from "react";
import { useParams, Link } from "react-router-dom";
import {
  Container,
  Row,
  Col,
  Image,
  Button,
  Spinner,
  Badge,
  Tabs,
  Tab,
  Modal,
  ListGroup,
  InputGroup,
  Form,
  ButtonGroup,
  Alert,
  Table,
} from "react-bootstrap";
import {
  ChevronLeft,
  ChevronRight,
  PlayCircleFill,
} from "react-bootstrap-icons";
import { toast } from "react-toastify";

import AuthContext from "../context/AuthContext";
import CartContext from "../context/CartContext";
import ProductCard from "../components/ProductCard";
import StarRating from "../components/StarRating";
import VoucherSlider from "../components/VoucherSlider";
import "./ProductDetailPage.css";

const ProductDetailPage = () => {
  const { slug } = useParams();
  const { api, user } = useContext(AuthContext);
  const { addToCart } = useContext(CartContext);

  // States
  const [isLoading, setIsLoading] = useState(true);
  const [product, setProduct] = useState(null);
  const [error, setError] = useState(null);
  const [relatedProducts, setRelatedProducts] = useState([]);

  // States cho Lựa chọn
  const [availableAttributes, setAvailableAttributes] = useState([]);
  const [selectedOptions, setSelectedOptions] = useState({});
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [selectedImage, setSelectedImage] = useState("");
  const [selectedVariant, setSelectedVariant] = useState(null);
  const [quantity, setQuantity] = useState(1);

  // States cho Voucher và Modal
  const [showVoucherModal, setShowVoucherModal] = useState(false);
  const [appliedVoucher, setAppliedVoucher] = useState(null);
  const [vouchers, setVouchers] = useState([]);
  const [voucherLoading, setVoucherLoading] = useState(false);
  const [collectingVoucher, setCollectingVoucher] = useState(null);
  const [showSizeModal, setShowSizeModal] = useState(false);

  // State cho Modal xem ảnh
  const [showImageModal, setShowImageModal] = useState(false);
  const [modalImageUrl, setModalImageUrl] = useState("");

  // State cho Modal xem video
  const [showVideoModal, setShowVideoModal] = useState(false);
  const [modalVideoUrl, setModalVideoUrl] = useState("");

  // Hàm tải dữ liệu
  const fetchProductData = async () => {
    setIsLoading(true);
    setError(null);
    try {
      // === SỬA ĐỔI LOGIC TẢI VOUCHER ===
      // 1. Tải sản phẩm chính TRƯỚC
      const productResponse = await api.get(`/products/${slug}`);
      const mainProduct = productResponse.data;
      if (!mainProduct) throw new Error("404 - Không tìm thấy sản phẩm");
      setProduct(mainProduct);

      // 2. Dùng SanPhamID để tải voucher và sản phẩm liên quan song song
      const voucherPromise = api.get(
        `/vouchers/product/${mainProduct.SanPhamID}`
      );
      const relatedPromise = mainProduct.DanhMucSlug
        ? api.get(`/products?danhMuc=${mainProduct.DanhMucSlug}`)
        : api.get("/products");

      const [voucherResponse, relatedResponse] = await Promise.all([
        voucherPromise,
        relatedPromise,
      ]);

      setVouchers(voucherResponse.data);
      setRelatedProducts(relatedResponse.data.products || []);
      // === KẾT THÚC SỬA ĐỔI ===

      if (mainProduct.PhienBan && mainProduct.PhienBan.length > 0) {
        const attributesMap = new Map();
        mainProduct.PhienBan.forEach((variant) => {
          if (variant.ThuocTinh) {
            variant.ThuocTinh.split(", ").forEach((attrString) => {
              const [name, value] = attrString.split(": ");
              if (!attributesMap.has(name)) {
                attributesMap.set(name, new Set());
              }
              attributesMap.get(name).add(value);
            });
          }
        });
        const parsedAttributes = [];
        attributesMap.forEach((valueSet, name) => {
          parsedAttributes.push({ name: name, values: [...valueSet] });
        });
        setAvailableAttributes(parsedAttributes);
        const defaultVariant = mainProduct.PhienBan[0];
        const defaultOptions = {};
        if (defaultVariant.ThuocTinh) {
          defaultVariant.ThuocTinh.split(", ").forEach((attrString) => {
            const [name, value] = attrString.split(": ");
            defaultOptions[name] = value;
          });
        }
        setSelectedOptions(defaultOptions);
        setSelectedVariant(defaultVariant);
      }

      if (mainProduct.HinhAnh && mainProduct.HinhAnh.length > 0) {
        setSelectedImage(mainProduct.HinhAnh[0].URL);
        setCurrentImageIndex(0);
      }
    } catch (err) {
      setError(err.message || "Không thể tải chi tiết sản phẩm.");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    window.scrollTo(0, 0);
    setAppliedVoucher(null);
    fetchProductData();
  }, [slug, api]);

  useEffect(() => {
    if (product && availableAttributes.length > 0) {
      const newVariant = product.PhienBan.find((variant) => {
        if (!variant.ThuocTinh) return false;
        return availableAttributes.every((attr) => {
          const selectedValue = selectedOptions[attr.name];
          return variant.ThuocTinh.includes(`${attr.name}: ${selectedValue}`);
        });
      });
      setSelectedVariant(newVariant || null);
      setQuantity(1);
    }
  }, [product, selectedOptions, availableAttributes]);

  useEffect(() => {
    if (product && product.HinhAnh.length > 0) {
      setSelectedImage(product.HinhAnh[currentImageIndex].URL);
    }
  }, [currentImageIndex, product]);

  // === CÁC HÀM HANDLER ===

  const handleOptionSelect = (name, value) => {
    setSelectedOptions((prevOptions) => ({
      ...prevOptions,
      [name]: value,
    }));
  };

  const handleShowImageModal = (url) => {
    setModalImageUrl(url);
    setShowImageModal(true);
  };
  const handleCloseImageModal = () => {
    setShowImageModal(false);
    setModalImageUrl("");
  };

  const handleShowVideoModal = (url) => {
    setModalVideoUrl(url);
    setShowVideoModal(true);
  };
  const handleCloseVideoModal = () => {
    setShowVideoModal(false);
    setModalVideoUrl("");
  };

  const handleNextImage = () => {
    const nextIndex = (currentImageIndex + 1) % product.HinhAnh.length;
    setCurrentImageIndex(nextIndex);
  };
  const handlePrevImage = () => {
    const prevIndex =
      (currentImageIndex - 1 + product.HinhAnh.length) % product.HinhAnh.length;
    setCurrentImageIndex(prevIndex);
  };

  const handleQuantityChange = (amount) =>
    setQuantity((prev) => Math.max(1, prev + amount));
  const handleCloseSizeModal = () => setShowSizeModal(false);
  const handleShowSizeModal = (e) => {
    e.preventDefault();
    setShowSizeModal(true);
  };
  const handleCloseModal = () => setShowVoucherModal(false);

  const handleShowModal = async () => {
    setShowVoucherModal(true);
  };

  const handleCollectAndApplyVoucher = async (voucher) => {
    if (!user) {
      toast.error("Vui lòng đăng nhập để nhận voucher.");
      return;
    }
    setCollectingVoucher(voucher.MaKhuyenMai);
    try {
      await api.post("/vouchers/collect", { MaKhuyenMai: voucher.MaKhuyenMai });
      setAppliedVoucher(voucher);
      handleCloseModal();
      toast.success("Đã lưu voucher!");
    } catch (err) {
      toast.error(err.response?.data?.message || "Không thể lưu voucher này.");
    } finally {
      setCollectingVoucher(null);
    }
  };

  const handleAddToCart = () => {
    if (!user) {
      toast.error("Vui lòng đăng nhập để thêm vào giỏ hàng");
      return;
    }
    if (selectedVariant) {
      addToCart(selectedVariant.PhienBanID, quantity);
    } else {
      toast.warn("Vui lòng chọn đầy đủ các thuộc tính");
    }
  };

  // Tính toán dữ liệu (Rating, Stock)
  let avgRating = 0;
  let reviewCount = 0;
  if (product && product.DanhGia && product.DanhGia.length > 0) {
    reviewCount = product.DanhGia.length;
    avgRating =
      product.DanhGia.reduce((acc, item) => acc + item.DiemSo, 0) / reviewCount;
  }
  const totalSold = product ? parseFloat(product.TotalSold) || 0 : 0;

  const stockColor = selectedVariant ? "#198754" : "#dc3545";

  // Render Loading / Error
  if (isLoading) {
    return (
      <Container
        fluid
        className="py-5 text-center d-flex justify-content-center align-items-center"
        style={{ minHeight: "80vh" }}
      >
        <Spinner animation="border" />
      </Container>
    );
  }
  if (error || !product) {
    return (
      <Container fluid className="py-5 text-center">
        <Alert variant="danger">
          {error || "404 - Không tìm thấy sản phẩm"}
        </Alert>
        <Button as={Link} to="/">
          Quay về Trang chủ
        </Button>
      </Container>
    );
  }

  // === RENDER TRANG CHI TIẾT ===
  return (
    <Container fluid className="py-5">
      <Row>
        {/* CỘT 1: GALLERY ẢNH (Dọc) (md={1}) */}
        <Col md={1} className="d-none d-md-block">
          <div className="product-gallery-thumbnails">
            {product.HinhAnh.map((img, index) => (
              <Image
                key={img.HinhAnhID}
                src={img.URL}
                className={`thumbnail-image-vert ${
                  currentImageIndex === index ? "active" : ""
                }`}
                onClick={() => setCurrentImageIndex(index)}
              />
            ))}
          </div>
        </Col>

        {/* CỘT 2: ẢNH CHÍNH (md={6}) */}
        <Col md={6} className="position-relative">
          <Image src={selectedImage} fluid className="product-image-main" />

          <Button
            variant="link"
            className="image-nav-btn prev"
            onClick={handlePrevImage}
          >
            <ChevronLeft size={24} />
          </Button>
          <Button
            variant="link"
            className="image-nav-btn next"
            onClick={handleNextImage}
          >
            <ChevronRight size={24} />
          </Button>
        </Col>

        {/* CỘT 3: THÔNG TIN (md={5}) */}
        <Col md={5} className="product-info-col">
          <h2 className="product-title">{product.TenSanPham}</h2>

          <div className="product-meta-info d-flex align-items-center flex-wrap">
            <StarRating value={avgRating} text={`(${reviewCount} đánh giá)`} />
            <span className="ms-2">| Đã bán {totalSold} </span>
            <span className="ms-2">
              |
              {selectedVariant ? (
                <span
                  className="stock-status-text ms-1"
                  style={{ color: stockColor }}
                >
                  Tồn kho: {selectedVariant.SoLuongTonKho}
                </span>
              ) : (
                <span
                  className="stock-status-text ms-1"
                  style={{ color: stockColor }}
                >
                  Hết hàng
                </span>
              )}
            </span>
          </div>

          {/* Giá */}
          <div className="my-3 p-3 bg-light rounded">
            {selectedVariant ? (
              <>
                {parseFloat(selectedVariant.GiaBan) <
                parseFloat(product.GiaGoc) ? (
                  <>
                    <span className="product-price-old">
                      {parseFloat(product.GiaGoc).toLocaleString("vi-VN")} ₫
                    </span>
                    <span className="product-price-new ms-2">
                      {parseFloat(selectedVariant.GiaBan).toLocaleString(
                        "vi-VN"
                      )}{" "}
                      ₫
                    </span>
                  </>
                ) : (
                  <span className="product-price-new">
                    {parseFloat(selectedVariant.GiaBan).toLocaleString("vi-VN")}{" "}
                    ₫
                  </span>
                )}
              </>
            ) : (
              <span className="product-price-new text-muted">
                Vui lòng chọn thuộc tính
              </span>
            )}
          </div>

          <div className="d-flex justify-content-between mb-3 product-size-helper">
            <Button variant="link" size="sm">
              Giúp bạn chọn size
            </Button>
            <Button variant="link" size="sm" onClick={handleShowSizeModal}>
              Bảng size
            </Button>
          </div>

          {availableAttributes.map((attr) => {
            // Render giao diện Màu Sắc
            if (attr.name === "Màu Sắc") {
              return (
                <div className="mb-3" key={attr.name}>
                  <span className="product-option-label">
                    {attr.name}: {selectedOptions[attr.name]}
                  </span>
                  <div className="color-swatch-group">
                    {attr.values.map((value) => (
                      <span
                        key={value}
                        className={`color-swatch ${
                          selectedOptions[attr.name] === value ? "active" : ""
                        }`}
                        style={{
                          backgroundColor:
                            value === "Trắng"
                              ? "#FFF"
                              : value === "Đen"
                              ? "#000"
                              : value === "Xanh"
                              ? "#0047AB"
                              : value === "Đỏ"
                              ? "#FF0000"
                              : value === "Vàng"
                              ? "#FFFF00"
                              : value === "Nâu"
                              ? "#8B4513"
                              : "#EEE", // Default
                        }}
                        title={value}
                        onClick={() => handleOptionSelect(attr.name, value)}
                      />
                    ))}
                  </div>
                </div>
              );
            }

            // Render giao diện Kích Cỡ (bất kỳ loại kích cỡ nào)
            if (attr.name.includes("Kích Cỡ")) {
              return (
                <div className="mb-3" key={attr.name}>
                  <span className="product-option-label">
                    {attr.name}: {selectedOptions[attr.name]}
                  </span>
                  <ButtonGroup className="size-btn-group">
                    {attr.values.map((value) => (
                      <Button
                        key={value}
                        variant="outline-secondary"
                        className="size-btn"
                        active={selectedOptions[attr.name] === value}
                        onClick={() => handleOptionSelect(attr.name, value)}
                      >
                        {value}
                      </Button>
                    ))}
                  </ButtonGroup>
                </div>
              );
            }
            return null;
          })}
          {/* Bộ chọn số lượng */}
          <div className="mb-3">
            <InputGroup className="quantity-selector">
              <Button
                variant="outline-secondary"
                onClick={() => handleQuantityChange(-1)}
                disabled={!selectedVariant}
              >
                -
              </Button>
              <Form.Control value={quantity} readOnly />
              <Button
                variant="outline-secondary"
                onClick={() => handleQuantityChange(1)}
                disabled={!selectedVariant}
              >
                +
              </Button>
            </InputGroup>
          </div>

          {/* Nút Thêm vào giỏ hàng */}
          <Button
            variant="warning"
            size="lg"
            className="w-100 fw-bold mb-3 btn-add-to-cart"
            disabled={!selectedVariant}
            onClick={handleAddToCart}
          >
            {selectedVariant ? "Thêm vào giỏ hàng" : "Hết hàng"}
          </Button>

          {/* Voucher Slider */}
          <VoucherSlider
            vouchers={vouchers}
            onVoucherClick={handleShowModal}
            onApply={handleCollectAndApplyVoucher}
            appliedVoucher={appliedVoucher}
          />
        </Col>
      </Row>

      {/* === PHẦN DƯỚI (TABS, REVIEWS, SẢN PHẨM LIÊN QUAN) === */}
      <Row className="mt-5">
        <Col>
          <Tabs
            defaultActiveKey="description"
            id="product-tabs"
            className="product-tabs mb-3"
            justify
          >
            <Tab eventKey="description" title="Mô tả chi tiết">
              <p className="mt-3 product-description">{product.MoTa}</p>
            </Tab>

            <Tab eventKey="reviews" title={`Đánh giá (${reviewCount})`}>
              <div className="mt-3">
                <h4 className="mb-3">Đánh giá sản phẩm</h4>
                {product.DanhGia.length > 0 ? (
                  product.DanhGia.map((review) => (
                    <div key={review.DanhGiaID} className="review-item">
                      <p className="mb-0 review-author">{review.HoTen}</p>
                      <StarRating value={review.DiemSo} />

                      {review.ThuocTinh && (
                        <p className="text-muted small mb-1 fst-italic">
                          Mặt hàng: {review.ThuocTinh}
                        </p>
                      )}

                      <p className="mb-1">{review.BinhLuan}</p>

                      <div className="review-media d-flex gap-2 mb-2">
                        {review.HinhAnhURL && (
                          <div
                            className="review-media-thumbnail"
                            onClick={() =>
                              handleShowImageModal(review.HinhAnhURL)
                            }
                          >
                            <Image src={review.HinhAnhURL} thumbnail />
                          </div>
                        )}
                        {review.VideoURL && (
                          <div
                            className="review-media-thumbnail video-thumbnail"
                            onClick={() =>
                              handleShowVideoModal(review.VideoURL)
                            }
                          >
                            <video src={review.VideoURL} />
                            <PlayCircleFill className="play-icon-overlay" />
                          </div>
                        )}
                      </div>

                      <small className="review-date">
                        {new Date(
                          review.NgayCapNhat || review.NgayTao
                        ).toLocaleDateString("vi-VN")}
                        {review.NgayCapNhat && (
                          <span className="fst-italic"> (đã chỉnh sửa)</span>
                        )}
                      </small>
                    </div>
                  ))
                ) : (
                  <p>Hiện chưa có đánh giá nào.</p>
                )}
                <Alert variant="info" className="mt-4">
                  Để lại đánh giá? Vui lòng mua hàng và đánh giá từ trang{" "}
                  <Link to="/profile/orders">Đơn hàng của tôi</Link>.
                </Alert>
              </div>
            </Tab>
          </Tabs>
        </Col>
      </Row>

      {/* SẢN PHẨM LIÊN QUAN */}
      <Row className="mt-5">
        <Col>
          <h2 className="fw-bold text-center mb-4">CÓ THỂ BẠN SẼ THÍCH</h2>
          <Row>
            {relatedProducts
              .filter((p) => p.SanPhamID !== product.SanPhamID)
              .slice(0, 4)
              .map((p) => (
                <Col key={p.SanPhamID} sm={6} md={4} lg={3}>
                  <ProductCard product={p} />
                </Col>
              ))}
          </Row>
        </Col>
      </Row>

      {/* MODAL VOUCHER (Hiển thị dữ liệu thật) */}
      <Modal show={showVoucherModal} onHide={handleCloseModal} centered>
        <Modal.Header closeButton>
          <Modal.Title>Voucher và khuyến mãi</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {voucherLoading ? (
            <div className="text-center">
              <Spinner animation="border" />
            </div>
          ) : vouchers.length === 0 ? (
            <p>Hiện chưa có voucher nào.</p>
          ) : (
            <ListGroup variant="flush">
              {vouchers.map((voucher) => (
                <ListGroup.Item
                  key={voucher.MaKhuyenMai}
                  className="d-flex justify-content-between align-items-center"
                >
                  <div>
                    <strong>{voucher.TenKhuyenMai}</strong>
                    <p className="mb-0 text-muted small">
                      Hết hạn:{" "}
                      {new Date(voucher.NgayKetThuc).toLocaleDateString(
                        "vi-VN"
                      )}
                    </p>
                  </div>
                  <Button
                    variant="danger"
                    size="sm"
                    className="btn-apply-voucher"
                    onClick={() => handleCollectAndApplyVoucher(voucher)}
                    disabled={collectingVoucher === voucher.MaKhuyenMai}
                  >
                    {collectingVoucher === voucher.MaKhuyenMai ? (
                      <Spinner as="span" animation="border" size="sm" />
                    ) : (
                      "Nhận"
                    )}
                  </Button>
                </ListGroup.Item>
              ))}
            </ListGroup>
          )}
        </Modal.Body>
      </Modal>

      {/* MODAL BẢNG SIZE */}
      <Modal show={showSizeModal} onHide={handleCloseSizeModal} centered>
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
              <tr>
                <td>S</td>
                <td>150 - 160</td>
                <td>45 - 55</td>
              </tr>
              <tr>
                <td>M</td>
                <td>160 - 170</td>
                <td>55 - 65</td>
              </tr>
              <tr>
                <td>L</td>
                <td>170 - 175</td>
                <td>65 - 75</td>
              </tr>
              <tr>
                <td>XL</td>
                <td>175 - 180</td>
                <td>75 - 85</td>
              </tr>
              <tr>
                <td>XXL</td>
                <td>180+</td>
                <td>85+</td>
              </tr>
            </tbody>
          </Table>
          <p className="text-muted small">
            Lưu ý: Bảng size chỉ mang tính chất tham khảo. Kích thước có thể
            thay đổi tùy theo form dáng của bạn.
          </p>
        </Modal.Body>
      </Modal>

      {/* MODAL XEM ẢNH */}
      <Modal
        show={showImageModal}
        onHide={handleCloseImageModal}
        centered
        size="lg"
        className="image-preview-modal"
      >
        <Modal.Body>
          <Image src={modalImageUrl} fluid />
        </Modal.Body>
      </Modal>

      {/* MODAL XEM VIDEO */}
      <Modal
        show={showVideoModal}
        onHide={handleCloseVideoModal}
        centered
        size="lg"
        className="video-preview-modal"
      >
        <Modal.Body>
          <video
            src={modalVideoUrl}
            controls
            autoPlay
            style={{ width: "100%" }}
          />
        </Modal.Body>
      </Modal>
    </Container>
  );
};

export default ProductDetailPage;
