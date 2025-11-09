// client/src/pages/AdminCategoryPage.jsx
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
  Modal,
  Form,
} from "react-bootstrap";
import AdminLayout from "../components/AdminLayout";
import AuthContext from "../context/AuthContext";
import { toast } from "react-toastify";
import { Plus, PencilSquare, Trash } from "react-bootstrap-icons";
import slugify from "slugify";

// Hàm helper để xây dựng cây danh mục (giống trong ProductListPage)
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

// Component con để hiển thị từng dòng danh mục
const CategoryRow = ({
  cat,
  level,
  parentName,
  onEdit,
  onDelete,
  categories,
}) => {
  const rowContent = (
    <>
      <td>{cat.DanhMucID}</td>
      {/* Thụt lề theo cấp độ */}
      <td>
        <span style={{ marginLeft: `${level * 20}px` }}>
          {level > 0 ? "↳ " : ""}
          <strong>{cat.TenDanhMuc}</strong>
          {level > 0 && (
            <span className="ms-2 badge bg-secondary">{parentName}</span>
          )}
        </span>
      </td>
      <td>{cat.Slug}</td>
      <td>
        <Button
          variant="warning"
          size="sm"
          className="me-2"
          onClick={() => onEdit(cat)}
        >
          <PencilSquare />
        </Button>
        <Button variant="danger" size="sm" onClick={() => onDelete(cat)}>
          <Trash />
        </Button>
      </td>
    </>
  );

  return (
    <>
      <tr key={cat.DanhMucID}>{rowContent}</tr>
      {cat.children.map((child) => (
        <CategoryRow
          key={child.DanhMucID}
          cat={child}
          level={level + 1}
          parentName={cat.TenDanhMuc}
          onEdit={onEdit}
          onDelete={onDelete}
          categories={categories}
        />
      ))}
    </>
  );
};

// Component chính
const AdminCategoryPage = () => {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [showModal, setShowModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [isEdit, setIsEdit] = useState(false);
  const [currentCategory, setCurrentCategory] = useState(null);
  const [categoryToDelete, setCategoryToDelete] = useState(null);
  const [modalData, setModalData] = useState({
    TenDanhMuc: "",
    Slug: "",
    DanhMucChaID: "",
  });
  const [modalError, setModalError] = useState("");
  const [modalLoading, setModalLoading] = useState(false);

  const { api } = useContext(AuthContext);

  const fetchCategories = useCallback(async () => {
    setLoading(true);
    try {
      const { data } = await api.get("/categories");
      setCategories(data);
    } catch (err) {
      setError("Không thể tải danh sách danh mục.");
      console.error("Error fetching categories:", err);
    } finally {
      setLoading(false);
    }
  }, [api]);

  useEffect(() => {
    fetchCategories();
  }, [api, fetchCategories]);

  const handleShowAdd = () => {
    setIsEdit(false);
    setCurrentCategory(null);
    setModalData({ TenDanhMuc: "", Slug: "", DanhMucChaID: "" });
    setShowModal(true);
  };

  const handleShowEdit = (category) => {
    setIsEdit(true);
    setCurrentCategory(category);
    setModalData({
      TenDanhMuc: category.TenDanhMuc,
      Slug: category.Slug,
      DanhMucChaID: category.DanhMucChaID || "",
    });
    setShowModal(true);
  };

  const handleCloseModal = () => setShowModal(false);

  // === HÀM XỬ LÝ GỬI FORM (CREATE/UPDATE) ===
  const handleSubmit = async (e) => {
    e.preventDefault();
    setModalLoading(true);
    setModalError("");

    try {
      if (!modalData.TenDanhMuc.trim()) {
        setModalError("Tên danh mục không được để trống");
        return;
      }

      let response;
      const dataToSend = {
        TenDanhMuc: modalData.TenDanhMuc.trim(),
        Slug:
          modalData.Slug.trim() ||
          slugify(modalData.TenDanhMuc, {
            lower: true,
            locale: "vi",
            remove: /[*+~.()'"!:@]/g,
          }),
        DanhMucChaID: modalData.DanhMucChaID || null,
      };

      if (isEdit) {
        response = await api.put(
          `/categories/${currentCategory.DanhMucID}`,
          dataToSend
        );
      } else {
        response = await api.post("/categories", dataToSend);
      }

      toast.success(response.data.message);
      fetchCategories(); // Tải lại danh sách
      handleCloseModal();
    } catch (err) {
      const errorMessage =
        err.response?.data?.message ||
        (isEdit ? "Cập nhật thất bại" : "Tạo mới thất bại");
      setModalError(errorMessage);
      toast.error(errorMessage);
    } finally {
      setModalLoading(false);
    }
  };

  // === HÀM XỬ LÝ XÓA ===
  const handleShowDeleteModal = (category) => {
    setCategoryToDelete(category);
    setShowDeleteModal(true);
  };

  const handleCloseDeleteModal = () => {
    setShowDeleteModal(false);
    setCategoryToDelete(null);
  };

  const handleConfirmDelete = async () => {
    try {
      const response = await api.delete(
        `/categories/${categoryToDelete.DanhMucID}`
      );
      toast.success(response.data.message);
      fetchCategories();
      handleCloseDeleteModal();
    } catch (err) {
      toast.error(err.response?.data?.message || "Xóa thất bại");
    }
  };

  // Xây dựng cây để hiển thị phân cấp
  const categoryTree = buildCategoryTree(categories);
  // Danh sách danh mục cha (loại trừ danh mục hiện tại nếu đang sửa)
  const parentCategories = categories.filter(
    (cat) =>
      !cat.DanhMucChaID &&
      (!isEdit || cat.DanhMucID !== currentCategory?.DanhMucID)
  );

  return (
    <AdminLayout>
      <Card className="shadow-sm">
        <Card.Header className="d-flex justify-content-between align-items-center">
          <h5>Quản lý Danh mục</h5>
          <Button variant="primary" size="sm" onClick={handleShowAdd}>
            <Plus /> Thêm Danh mục
          </Button>
        </Card.Header>
        <Card.Body>
          {loading ? (
            <div className="text-center">
              <Spinner animation="border" size="sm" /> Đang tải...
            </div>
          ) : error ? (
            <Alert variant="danger">{error}</Alert>
          ) : (
            <Table striped hover responsive size="sm" className="align-middle">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Tên Danh mục</th>
                  <th>Slug</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {/* Dùng component CategoryRow để render đệ quy */}
                {categoryTree.map((cat) => (
                  <CategoryRow
                    key={cat.DanhMucID}
                    cat={cat}
                    level={0}
                    onEdit={handleShowEdit}
                    onDelete={handleShowDeleteModal}
                    categories={categories}
                  />
                ))}
              </tbody>
            </Table>
          )}
        </Card.Body>
      </Card>

      {/* Modal Thêm/Sửa Danh mục */}
      <Modal show={showModal} onHide={handleCloseModal} centered>
        <Modal.Header closeButton>
          <Modal.Title>
            {isEdit ? "Cập nhật Danh mục" : "Thêm Danh mục mới"}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {modalError && <Alert variant="danger">{modalError}</Alert>}
          <Form onSubmit={handleSubmit}>
            <Form.Group className="mb-3">
              <Form.Label>Tên Danh mục</Form.Label>
              <Form.Control
                type="text"
                value={modalData.TenDanhMuc}
                onChange={(e) =>
                  setModalData({ ...modalData, TenDanhMuc: e.target.value })
                }
                required
              />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Slug</Form.Label>
              <Form.Control
                type="text"
                value={modalData.Slug}
                onChange={(e) =>
                  setModalData({ ...modalData, Slug: e.target.value })
                }
                required
              />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Danh mục Cha (Tùy chọn)</Form.Label>
              <Form.Select
                value={modalData.DanhMucChaID}
                onChange={(e) =>
                  setModalData({ ...modalData, DanhMucChaID: e.target.value })
                }
              >
                <option value="">-- Chọn Danh mục Cha --</option>
                {parentCategories.map((cat) => (
                  <option key={cat.DanhMucID} value={cat.DanhMucID}>
                    {cat.TenDanhMuc}
                  </option>
                ))}
              </Form.Select>
            </Form.Group>

            <Button
              type="submit"
              variant="primary"
              className="w-100"
              disabled={modalLoading}
            >
              {modalLoading ? (
                <Spinner as="span" animation="border" size="sm" />
              ) : isEdit ? (
                "Cập nhật"
              ) : (
                "Thêm mới"
              )}
            </Button>
          </Form>
        </Modal.Body>
      </Modal>

      {/* Delete Confirmation Modal */}
      <Modal show={showDeleteModal} onHide={handleCloseDeleteModal} centered>
        <Modal.Header closeButton>
          <Modal.Title>Xác nhận xóa danh mục</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {categoryToDelete && (
            <p>
              Bạn có chắc chắn muốn xóa danh mục "
              <strong>{categoryToDelete.TenDanhMuc}</strong>"?
              {categoryToDelete.children?.length > 0 && (
                <Alert variant="warning" className="mt-2">
                  Lưu ý: Danh mục này có {categoryToDelete.children.length} danh
                  mục con. Việc xóa có thể không thành công nếu có sản phẩm liên
                  quan.
                </Alert>
              )}
            </p>
          )}
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={handleCloseDeleteModal}>
            Hủy bỏ
          </Button>
          <Button variant="danger" onClick={handleConfirmDelete}>
            Xác nhận xóa
          </Button>
        </Modal.Footer>
      </Modal>
    </AdminLayout>
  );
};

export default AdminCategoryPage;
