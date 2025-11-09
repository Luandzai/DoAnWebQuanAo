// server/src/controllers/reviewController.js (ĐÃ NÂNG CẤP MEDIA)
const pool = require("../config/db");
const { cloudinary } = require("../config/cloudinary"); // <-- IMPORT MỚI

// Hàm helper xóa file trên Cloudinary
const deleteCloudinaryFile = async (publicId, resourceType = "image") => {
  if (!publicId) return;
  try {
    await cloudinary.uploader.destroy(publicId, {
      resource_type: resourceType,
    });
  } catch (error) {
    console.error("Lỗi khi xóa file Cloudinary:", error);
  }
};

exports.createReview = async (req, res) => {
  const { NguoiDungID } = req.user;
  // Dữ liệu text giờ nằm trong req.body (từ FormData)
  const { PhienBanID, DiemSo, BinhLuan } = req.body;

  if (!PhienBanID || !DiemSo) {
    return res
      .status(400)
      .json({ message: "Thiếu thông tin phiên bản hoặc điểm số." });
  }

  // Lấy thông tin file (nếu có) từ req.files
  const hinhAnh = req.files?.image?.[0];
  const video = req.files?.video?.[0];

  try {
    // (Kiểm tra mua hàng và kiểm tra trùng lặp giữ nguyên)
    const [orders] = await pool.query(
      `SELECT * FROM DonHang dh
       JOIN ChiTietDonHang ctdh ON dh.DonHangID = ctdh.DonHangID
       WHERE dh.NguoiDungID = ? AND ctdh.PhienBanID = ? AND dh.TrangThai = 'DA_GIAO'`,
      [NguoiDungID, PhienBanID]
    );
    if (orders.length === 0) {
      throw new Error(
        "Bạn chỉ có thể đánh giá sản phẩm bạn đã mua và đã nhận hàng."
      );
    }
    const [existingReview] = await pool.query(
      "SELECT * FROM DanhGia WHERE NguoiDungID = ? AND PhienBanID = ?",
      [NguoiDungID, PhienBanID]
    );
    if (existingReview.length > 0) {
      throw new Error("Bạn đã đánh giá sản phẩm này rồi.");
    }

    // Thêm đánh giá mới với media
    const [result] = await pool.query(
      `INSERT INTO DanhGia 
         (PhienBanID, NguoiDungID, DiemSo, BinhLuan, 
          HinhAnhURL, HinhAnhPublicID, VideoURL, VideoPublicID) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        PhienBanID,
        NguoiDungID,
        DiemSo,
        BinhLuan || "",
        hinhAnh?.path || null, // URL an toàn từ Cloudinary
        hinhAnh?.filename || null, // PublicID (để xóa)
        video?.path || null,
        video?.filename || null,
      ]
    );

    res.status(201).json({
      message: "Cảm ơn bạn đã đánh giá sản phẩm!",
      DanhGiaID: result.insertId,
    });
  } catch (error) {
    // Nếu có lỗi, xóa file đã lỡ tải lên
    if (hinhAnh) await deleteCloudinaryFile(hinhAnh.filename, "image");
    if (video) await deleteCloudinaryFile(video.filename, "video");

    console.error("Lỗi khi tạo đánh giá:", error);
    res.status(500).json({ message: error.message || "Lỗi server nội bộ" });
  }
};

// (Hàm getMyReviewByProduct giữ nguyên)
exports.getMyReviewByProduct = async (req, res) => {
  const { NguoiDungID } = req.user;
  const { phienBanId } = req.params;

  try {
    // Lấy tất cả các cột mới
    const [review] = await pool.query(
      "SELECT * FROM DanhGia WHERE NguoiDungID = ? AND PhienBanID = ?",
      [NguoiDungID, phienBanId]
    );

    if (review.length === 0) {
      return res.json(null);
    }
    res.json(review[0]);
  } catch (error) {
    console.error("Lỗi khi lấy đánh giá:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// (Hàm updateReview đã được nâng cấp)
exports.updateReview = async (req, res) => {
  const { NguoiDungID } = req.user;
  const { id: DanhGiaID } = req.params;
  const { DiemSo, BinhLuan, XoaHinhAnh, XoaVideo } = req.body;

  const hinhAnhMoi = req.files?.image?.[0];
  const videoMoi = req.files?.video?.[0];

  if (!DiemSo) {
    return res.status(400).json({ message: "Thiếu điểm số." });
  }

  try {
    // 1. Lấy đánh giá cũ để kiểm tra
    const [rows] = await pool.query(
      "SELECT * FROM DanhGia WHERE DanhGiaID = ? AND NguoiDungID = ?",
      [DanhGiaID, NguoiDungID]
    );
    if (rows.length === 0) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy đánh giá hoặc bạn không có quyền." });
    }
    const reviewCu = rows[0];

    // 2. Chuẩn bị dữ liệu media mới
    let hinhAnhURL = reviewCu.HinhAnhURL;
    let hinhAnhPublicID = reviewCu.HinhAnhPublicID;
    let videoURL = reviewCu.VideoURL;
    let videoPublicID = reviewCu.VideoPublicID;

    // 3. Xử lý Hình ảnh
    if (hinhAnhMoi) {
      // Nếu có ảnh mới -> Xóa ảnh cũ (nếu có)
      await deleteCloudinaryFile(reviewCu.HinhAnhPublicID, "image");
      hinhAnhURL = hinhAnhMoi.path;
      hinhAnhPublicID = hinhAnhMoi.filename;
    } else if (XoaHinhAnh === "true") {
      // Nếu không có ảnh mới, nhưng user đòi Xóa
      await deleteCloudinaryFile(reviewCu.HinhAnhPublicID, "image");
      hinhAnhURL = null;
      hinhAnhPublicID = null;
    }

    // 4. Xử lý Video
    if (videoMoi) {
      await deleteCloudinaryFile(reviewCu.VideoPublicID, "video");
      videoURL = videoMoi.path;
      videoPublicID = videoMoi.filename;
    } else if (XoaVideo === "true") {
      await deleteCloudinaryFile(reviewCu.VideoPublicID, "video");
      videoURL = null;
      videoPublicID = null;
    }

    // 5. Cập nhật CSDL
    await pool.query(
      `UPDATE DanhGia SET 
         DiemSo = ?, BinhLuan = ?,
         HinhAnhURL = ?, HinhAnhPublicID = ?,
         VideoURL = ?, VideoPublicID = ?,
         NgayCapNhat = NOW() -- <-- SỬA ĐỔI: Thêm ngày cập nhật
       WHERE DanhGiaID = ?`,
      [
        DiemSo,
        BinhLuan || "",
        hinhAnhURL,
        hinhAnhPublicID,
        videoURL,
        videoPublicID,
        DanhGiaID,
      ]
    );

    res.json({ message: "Đã cập nhật đánh giá!" });
  } catch (error) {
    // Nếu có lỗi, xóa file đã lỡ tải lên (nếu có)
    if (hinhAnhMoi) await deleteCloudinaryFile(hinhAnhMoi.filename, "image");
    if (videoMoi) await deleteCloudinaryFile(videoMoi.filename, "video");

    console.error("Lỗi khi cập nhật đánh giá:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// --------------------------------------------------------
// --- ADMIN FUNCTIONS ---
// --------------------------------------------------------

// @desc    Admin: Lấy TẤT CẢ đánh giá (có phân trang, tìm kiếm)
// @route   GET /api/admin/reviews
// @access  Private (Admin)
exports.getAllReviewsAdmin = async (req, res) => {
  try {
    const { rating, search, page = 1, limit = 10 } = req.query;

    let conditions = [];
    let params = [];

    // Lọc theo điểm số
    if (rating) {
      conditions.push("dg.DiemSo = ?");
      params.push(rating);
    }

    // Tìm kiếm (Tên SP, Tên User, Email, Bình luận)
    if (search) {
      conditions.push(`(
        sp.TenSanPham LIKE ? OR
        nd.HoTen LIKE ? OR
        nd.Email LIKE ? OR
        dg.BinhLuan LIKE ?
      )`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm, searchTerm);
    }

    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";
    const offset = (page - 1) * limit;

    // 1. Đếm tổng số đánh giá
    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total 
       FROM DanhGia dg
       JOIN NguoiDung nd ON dg.NguoiDungID = nd.NguoiDungID
       JOIN PhienBanSanPham pb ON dg.PhienBanID = pb.PhienBanID
       JOIN SanPham sp ON pb.SanPhamID = sp.SanPhamID
       ${whereClause}`,
      params
    );
    const total = countResult[0].total;
    const totalPages = Math.ceil(total / limit);

    // 2. Lấy dữ liệu đánh giá
    const [reviews] = await pool.query(
      `SELECT 
          dg.DanhGiaID, dg.DiemSo, dg.BinhLuan, dg.NgayTao,
          dg.HinhAnhURL, dg.VideoURL,
          sp.TenSanPham, sp.Slug,
          nd.HoTen AS TenNguoiDung
       FROM DanhGia dg
       JOIN NguoiDung nd ON dg.NguoiDungID = nd.NguoiDungID
       JOIN PhienBanSanPham pb ON dg.PhienBanID = pb.PhienBanID
       JOIN SanPham sp ON pb.SanPhamID = sp.SanPhamID
       ${whereClause}
       ORDER BY dg.NgayTao DESC
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      success: true,
      reviews,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đánh giá Admin:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Xóa một đánh giá (Xóa cứng và xóa media)
// @route   DELETE /api/admin/reviews/:id
// @access  Private (Admin)
exports.deleteReviewAdmin = async (req, res) => {
  const { id: DanhGiaID } = req.params;
  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    // 1. Lấy thông tin media để xóa trên Cloudinary
    const [rows] = await connection.query(
      "SELECT HinhAnhPublicID, VideoPublicID FROM DanhGia WHERE DanhGiaID = ?",
      [DanhGiaID]
    );

    if (rows.length === 0) {
      throw new Error("Không tìm thấy đánh giá.");
    }
    const review = rows[0];

    // 2. Xóa file trên Cloudinary (Sử dụng hàm helper đã có)
    await deleteCloudinaryFile(review.HinhAnhPublicID, "image");
    await deleteCloudinaryFile(review.VideoPublicID, "video");

    // 3. Xóa đánh giá khỏi CSDL
    const [result] = await connection.query(
      "DELETE FROM DanhGia WHERE DanhGiaID = ?",
      [DanhGiaID]
    );

    if (result.affectedRows === 0) {
      throw new Error("Xóa đánh giá thất bại.");
    }

    await connection.commit();
    res.json({ message: "Đã xóa đánh giá thành công." });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi xóa đánh giá (Admin):", error);
    res.status(500).json({ message: error.message || "Lỗi server" });
  } finally {
    connection.release();
  }
};
