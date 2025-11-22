// server/src/controllers/productController.js (ĐÃ NÂNG CẤP BADGE ĐỘNG)
const pool = require("../config/db");
// Hằng số cho phân trang
const PRODUCTS_PER_PAGE = 15;
// === THÊM CÁC IMPORT NÀY LÊN ĐẦU ===
const { cloudinary } = require("../config/cloudinary");
const slugify = require("slugify");
// @desc    Lấy tất cả sản phẩm (ĐÃ NÂNG CẤP)
// @route   GET /api/products
// @access  Public
exports.getAllProducts = async (req, res) => {
  try {
    const filters = req.query;
    const { danhMuc, khoangGia, sortBy, search } = filters;

    // 1. Phân trang
    const page = parseInt(req.query.page) || 1;
    const limit = PRODUCTS_PER_PAGE;
    const offset = (page - 1) * limit;

    let baseSelect = `
      SELECT 
        sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc, 
        (SELECT HinhAnh.URL FROM HinhAnhSanPham AS HinhAnh 
         WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
         LIMIT 1) as HinhAnhChinh,
        MIN(pb.GiaBan) as GiaBan,
        IF(sp.NgayTao >= DATE_SUB(NOW(), INTERVAL 7 DAY), 1, 0) AS IsNew,
        (EXISTS (
            SELECT 1 FROM khuyenmai km
            WHERE (km.SanPhamID = sp.SanPhamID OR km.DanhMucID = sp.DanhMucID)
            AND km.NgayBatDau < NOW() AND km.NgayKetThuc > NOW()
        )) AS HasVoucher,
        COUNT(DISTINCT tt.ThuocTinhID) AS ThuocTinhKhop
    `;

    let fromJoin = `
      FROM SanPham AS sp
      LEFT JOIN DanhMuc AS dm_child ON sp.DanhMucID = dm_child.DanhMucID
      LEFT JOIN DanhMuc AS dm_parent ON dm_child.DanhMucChaID = dm_parent.DanhMucID
      LEFT JOIN PhienBanSanPham AS pb ON sp.SanPhamID = pb.SanPhamID
      LEFT JOIN ChiTietPhienBan AS ctpb ON pb.PhienBanID = ctpb.PhienBanID
      LEFT JOIN GiaTriThuocTinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
      LEFT JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
    `;

    let whereClauses = ["sp.TrangThai = 'ACTIVE'"];
    let params = [];
    let havingConditions = [];

    // Logic Lọc (Giữ nguyên)
    if (search) {
      whereClauses.push(`sp.TenSanPham LIKE ?`);
      params.push(`%${search}%`);
    }

    if (danhMuc) {
      const categories = danhMuc.split(",");
      whereClauses.push(`(dm_child.Slug IN (?) OR dm_parent.Slug IN (?))`);
      params.push(categories);
      params.push(categories);
    }

    if (khoangGia) {
      const priceRanges = khoangGia.split(",");
      let priceConditions = [];
      priceRanges.forEach((range) => {
        const [min, max] = range.split("-");
        priceConditions.push(`(pb.GiaBan BETWEEN ? AND ?)`);
        params.push(min);
        params.push(max);
      });
      whereClauses.push(`(${priceConditions.join(" OR ")})`);
    }

    const attributeFilters = Object.keys(filters).filter(
      (key) =>
        !["danhMuc", "khoangGia", "sortBy", "search", "page"].includes(key)
    );

    if (attributeFilters.length > 0) {
      attributeFilters.forEach((attrSlug) => {
        const values = filters[attrSlug].split(",");
        whereClauses.push(`(tt.Slug = ? AND gtt.GiaTri IN (?))`);
        params.push(attrSlug);
        params.push(values);
      });
      havingConditions.push(
        `COUNT(DISTINCT tt.ThuocTinhID) = ${attributeFilters.length}`
      );
    }
    // Kết thúc Logic Lọc

    let whereSql = "";
    if (whereClauses.length > 0) {
      whereSql = " WHERE " + whereClauses.join(" AND ");
    }

    let havingSql = "";
    if (havingConditions.length > 0) {
      havingSql = " HAVING " + havingConditions.join(" AND ");
    }

    const groupBy =
      " GROUP BY sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc ";

    // 2. Lấy Tổng số sản phẩm (Count Query)
    // Query chỉ cần lấy ID để đếm số sản phẩm khớp
    const countQuery = `SELECT sp.SanPhamID ${fromJoin} ${whereSql} ${groupBy} ${havingSql}`;

    // Tham số cho Count Query (không bao gồm LIMIT/OFFSET)
    const countParams = [...params];

    // Thực hiện Count Query
    const [allProducts] = await pool.query(countQuery, countParams);
    const totalProducts = allProducts.length;
    const totalPages = Math.ceil(totalProducts / limit);

    // 3. Lấy dữ liệu theo phân trang (Data Query)
    let dataQuery = baseSelect + fromJoin + whereSql + groupBy + havingSql;

    let orderAndLimit = "";
    if (sortBy === "price-asc") {
      orderAndLimit = " ORDER BY GiaBan ASC LIMIT ? OFFSET ?";
    } else if (sortBy === "price-desc") {
      orderAndLimit = " ORDER BY GiaBan DESC LIMIT ? OFFSET ?";
    } else {
      orderAndLimit = ` ORDER BY sp.NgayTao DESC LIMIT ? OFFSET ?`;
    }

    // Thêm tham số LIMIT/OFFSET vào mảng params chỉ cho data query
    params.push(limit);
    params.push(offset);

    dataQuery += orderAndLimit;

    const [products] = await pool.query(dataQuery, params);

    // 4. Trả về kết quả
    res.json({
      products,
      currentPage: page,
      totalPages: totalPages,
      totalProducts: totalProducts,
    });
  } catch (error) {
    console.error("Lỗi khi lấy tất cả sản phẩm (Filter/Pagination):", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Lấy chi tiết 1 sản phẩm (cho người dùng)
// @route   GET /api/products/:slug
// @access  Public
exports.getProductBySlug = async (req, res) => {
  try {
    const { slug } = req.params;
    const [productRows] = await pool.query(
      `SELECT 
         sp.*, 
         dm.Slug AS DanhMucSlug,
         (SELECT SUM(ctdh.SoLuong) 
          FROM ChiTietDonHang AS ctdh
          JOIN DonHang AS dh ON ctdh.DonHangID = dh.DonHangID
          JOIN PhienBanSanPham AS pb ON ctdh.PhienBanID = pb.PhienBanID
          WHERE pb.SanPhamID = sp.SanPhamID AND (dh.TrangThai = 'DA_GIAO' OR dh.TrangThai = 'DANG_XU_LY')
         ) AS TotalSold
       FROM SanPham AS sp 
       LEFT JOIN DanhMuc AS dm ON sp.DanhMucID = dm.DanhMucID
       WHERE sp.Slug = ? AND sp.TrangThai = 'ACTIVE'`,
      [slug]
    );
    if (productRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
    }
    const product = productRows[0];
    const [images] = await pool.query(
      "SELECT HinhAnhID, URL, MoTa FROM HinhAnhSanPham WHERE SanPhamID = ?",
      [product.SanPhamID]
    );
    const [variants] = await pool.query(
      `SELECT 
         pb.PhienBanID, pb.SKU, pb.GiaBan, pb.SoLuongTonKho,
         (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
            FROM ChiTietPhienBan AS ctpb
            JOIN GiaTriThuocTinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
            JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
            WHERE ctpb.PhienBanID = pb.PhienBanID
           ) AS ThuocTinh
       FROM PhienBanSanPham AS pb
       WHERE pb.SanPhamID = ? AND pb.SoLuongTonKho > 0
       GROUP BY pb.PhienBanID`,
      [product.SanPhamID]
    );

    const [reviews] = await pool.query(
      `SELECT 
         dg.DanhGiaID, dg.DiemSo, dg.BinhLuan, 
         dg.NgayTao, dg.NgayCapNhat,
         dg.HinhAnhURL, dg.VideoURL,
         nd.HoTen,
         (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
          FROM ChiTietPhienBan AS ctpb
          JOIN GiaTriThuocTinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
          JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
          WHERE ctpb.PhienBanID = dg.PhienBanID
         ) AS ThuocTinh
       FROM DanhGia AS dg
       JOIN NguoiDung AS nd ON dg.NguoiDungID = nd.NguoiDungID
       WHERE dg.PhienBanID IN (SELECT PhienBanID FROM PhienBanSanPham WHERE SanPhamID = ?)
       ORDER BY dg.NgayTao DESC`,
      [product.SanPhamID]
    );

    res.json({
      ...product,
      HinhAnh: images,
      PhienBan: variants,
      DanhGia: reviews,
    });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết sản phẩm:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// === HÀM TẠO SẢN PHẨM HOÀN CHỈNH (CREATE) ===
exports.createProduct = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    // 1. Lấy dữ liệu và Parse versions
    const {
      TenSanPham,
      MoTa,
      DanhMucID,
      GiaGoc,
      ThuongHieu,
      ChatLieu,
      versions: versionsJson, // versions là JSON string
    } = req.body;

    let versions = [];
    if (versionsJson) {
      versions = JSON.parse(versionsJson);
    }

    // 2. Kiểm tra bắt buộc & Slug
    if (!TenSanPham || !DanhMucID || !GiaGoc) {
      return res.status(400).json({
        message: "Thiếu thông tin bắt buộc (Tên, Danh mục, Giá gốc).",
      });
    }
    if (!req.files || req.files.length === 0) {
      return res
        .status(400)
        .json({ message: "Vui lòng tải lên ít nhất 1 ảnh." });
    }
    if (versions.length === 0) {
      return res
        .status(400)
        .json({ message: "Vui lòng thêm ít nhất một phiên bản sản phẩm." });
    }

    const slug = slugify(TenSanPham, {
      lower: true,
      locale: "vi",
      remove: /[*+~.()'"!:@]/g,
    });

    await connection.beginTransaction(); // Bắt đầu Transaction

    // 3. INSERT SanPham
    const [spResult] = await connection.query(
      `INSERT INTO SanPham (TenSanPham, Slug, MoTa, DanhMucID, GiaGoc, ThuongHieu, ChatLieu, TrangThai) 
       VALUES (?, ?, ?, ?, ?, ?, ?, 'ACTIVE')`,
      [
        TenSanPham,
        slug,
        MoTa || null,
        DanhMucID,
        GiaGoc,
        ThuongHieu || null,
        ChatLieu || null,
      ]
    );
    const newSanPhamID = spResult.insertId;

    // 4. INSERT Ảnh (req.files từ Multer/Cloudinary)
    for (let index = 0; index < req.files.length; index++) {
      const file = req.files[index];
      await connection.query(
        `INSERT INTO HinhAnhSanPham (SanPhamID, URL, MoTa, LaAnhChinh, ViTri) 
             VALUES (?, ?, ?, ?, ?)`,
        [newSanPhamID, file.path, file.originalname, index === 0 ? 1 : 0, index]
      );
    }

    // 5. INSERT Phiên bản và Chi tiết Phiên bản
    for (const version of versions) {
      // 5a. INSERT PhienBanSanPham
      const [pbResult] = await connection.query(
        `INSERT INTO PhienBanSanPham (SanPhamID, SKU, GiaBan, SoLuongTonKho) 
             VALUES (?, ?, ?, ?)`,
        [newSanPhamID, version.sku, version.price, version.stock]
      );
      const newPhienBanID = pbResult.insertId;

      // 5b. INSERT ChiTietPhienBan
      for (const [attrName, attrValue] of Object.entries(version.options)) {
        const [attrValueRows] = await connection.query(
          `SELECT gtt.GiaTriID 
                 FROM GiaTriThuocTinh AS gtt
                 JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
                 WHERE tt.TenThuocTinh = ? AND gtt.GiaTri = ?`,
          [attrName, attrValue]
        );

        if (attrValueRows.length === 0) {
          throw new Error(
            `Giá trị thuộc tính không hợp lệ: ${attrName}: ${attrValue}`
          );
        }

        await connection.query(
          `INSERT INTO ChiTietPhienBan (PhienBanID, GiaTriID) 
                 VALUES (?, ?)`,
          [newPhienBanID, attrValueRows[0].GiaTriID]
        );
      }
    }

    await connection.commit(); // Thành công
    res
      .status(201)
      .json({ message: "Tạo sản phẩm thành công!", SanPhamID: newSanPhamID });
  } catch (error) {
    await connection.rollback(); // Lỗi -> Hoàn tác DB

    // Xóa file đã tải lên Cloudinary nếu Transaction bị lỗi (Quan trọng!)
    if (req.files) {
      for (const file of req.files) {
        await cloudinary.uploader.destroy(file.filename);
      }
    }

    console.error("Lỗi khi tạo sản phẩm:", error);
    res
      .status(500)
      .json({ message: error.message || "Lỗi server nội bộ khi tạo sản phẩm" });
  } finally {
    connection.release();
  }
};

// @desc    Admin: Lấy chi tiết 1 sản phẩm (cho trang admin)
// @route   GET /api/admin/products/:id
// @access  Private (Admin)
exports.getAdminProductById = async (req, res) => {
  try {
    const { id } = req.params;

    // 1. Lấy thông tin sản phẩm cơ bản
    const [productRows] = await pool.query(
      `SELECT * FROM SanPham WHERE SanPhamID = ?`,
      [id]
    );
    if (productRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
    }
    const product = productRows[0];

    // 2. Lấy danh sách hình ảnh
    const [images] = await pool.query(
      "SELECT HinhAnhID, URL, LaAnhChinh FROM HinhAnhSanPham WHERE SanPhamID = ? ORDER BY ViTri ASC",
      [id]
    );

    // 3. Lấy danh sách phiên bản và thuộc tính của chúng
    const [variants] = await pool.query(
      `SELECT
         pb.PhienBanID, pb.SKU, pb.GiaBan, pb.SoLuongTonKho,
         JSON_OBJECTAGG(tt.TenThuocTinh, gtt.GiaTri) AS options
       FROM PhienBanSanPham AS pb
       JOIN ChiTietPhienBan AS ctpb ON pb.PhienBanID = ctpb.PhienBanID
       JOIN GiaTriThuocTinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
       JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
       WHERE pb.SanPhamID = ?
       GROUP BY pb.PhienBanID`,
      [id]
    );

    // Đổi tên các key cho nhất quán với frontend
    const formattedVariants = variants.map((v) => ({
      ...v,
      sku: v.SKU,
      price: v.GiaBan,
      stock: v.SoLuongTonKho,
    }));

    res.json({
      ...product,
      images: images,
      versions: formattedVariants, // Trả về 'versions' thay vì 'PhienBan'
    });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết sản phẩm admin:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.updateProduct = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id } = req.params;
    const {
      TenSanPham,
      MoTa,
      DanhMucID,
      GiaGoc,
      ThuongHieu,
      ChatLieu,
      versions: versionsJson,
      deletedImages: deletedImagesJson, // Ảnh bị xóa
      deletedVariantIds: deletedVariantIdsJson, // Phiên bản bị xóa
    } = req.body;

    let versions = [];
    if (versionsJson) {
      versions = JSON.parse(versionsJson);
    }

    let deletedImages = [];
    if (deletedImagesJson) {
      deletedImages = JSON.parse(deletedImagesJson);
    }

    let deletedVariantIds = [];
    if (deletedVariantIdsJson) {
      deletedVariantIds = JSON.parse(deletedVariantIdsJson);
    }

    await connection.beginTransaction();

    // 1. Update basic product info
    const slug = slugify(TenSanPham, {
      lower: true,
      locale: "vi",
      remove: /[*+~.()'"!:@]/g,
    });

    await connection.query(
      `UPDATE SanPham 
       SET TenSanPham = ?, Slug = ?, MoTa = ?, GiaGoc = ?, 
           ThuongHieu = ?, ChatLieu = ?, DanhMucID = ? 
       WHERE SanPhamID = ?`,
      [TenSanPham, slug, MoTa, GiaGoc, ThuongHieu, ChatLieu, DanhMucID, id]
    );

    // 2. Handle deleted images
    if (deletedImages && deletedImages.length > 0) {
      const imageIdsToDelete = deletedImages.map((img) => img.HinhAnhID);

      // Delete from Cloudinary
      for (const image of deletedImages) {
        const publicId = image.URL.split("/").pop().split(".")[0]; // Cần logic tốt hơn để lấy publicId
        if (publicId) await cloudinary.uploader.destroy(publicId);
      }
      // Delete from DB
      await connection.query(
        "DELETE FROM HinhAnhSanPham WHERE HinhAnhID IN (?)",
        [imageIdsToDelete]
      );
    }

    // 3. Add new images if any
    if (req.files && req.files.length > 0) {
      const [existingImages] = await connection.query(
        "SELECT COUNT(*) as count FROM HinhAnhSanPham WHERE SanPhamID = ?",
        [id]
      );

      let startPosition = existingImages[0].count;

      for (let index = 0; index < req.files.length; index++) {
        const file = req.files[index];
        await connection.query(
          `INSERT INTO HinhAnhSanPham (SanPhamID, URL, MoTa, LaAnhChinh, ViTri) 
           VALUES (?, ?, ?, ?, ?)`,
          [
            id,
            file.path,
            file.originalname,
            startPosition === 0 && index === 0 ? 1 : 0,
            startPosition + index,
          ]
        );
      }
    }

    // 4. Handle deleted variants
    if (deletedVariantIds && deletedVariantIds.length > 0) {
      await connection.query(
        "DELETE FROM ChiTietPhienBan WHERE PhienBanID IN (?)",
        [deletedVariantIds]
      );
      await connection.query(
        "DELETE FROM PhienBanSanPham WHERE PhienBanID IN (?)",
        [deletedVariantIds]
      );
    }

    // 5. Handle new and updated variants
    for (const version of versions) {
      if (version.PhienBanID) {
        // UPDATE existing variant
        await connection.query(
          `UPDATE PhienBanSanPham SET SKU = ?, GiaBan = ?, SoLuongTonKho = ? WHERE PhienBanID = ?`,
          [version.sku, version.price, version.stock, version.PhienBanID]
        );
      } else {
        // INSERT new variant
        const [pbResult] = await connection.query(
          `INSERT INTO PhienBanSanPham (SanPhamID, SKU, GiaBan, SoLuongTonKho) VALUES (?, ?, ?, ?)`,
          [id, version.sku, version.price, version.stock]
        );
        const newPhienBanID = pbResult.insertId;

        // Insert ChiTietPhienBan for the new variant
        for (const [attrName, attrValue] of Object.entries(version.options)) {
          const [attrValueRows] = await connection.query(
            `SELECT gtt.GiaTriID FROM GiaTriThuocTinh AS gtt
             JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
             WHERE tt.TenThuocTinh = ? AND gtt.GiaTri = ?`,
            [attrName, attrValue]
          );

          if (attrValueRows.length === 0) {
            throw new Error(
              `Giá trị thuộc tính không hợp lệ: ${attrName}: ${attrValue}`
            );
          }

          await connection.query(
            `INSERT INTO ChiTietPhienBan (PhienBanID, GiaTriID) VALUES (?, ?)`,
            [newPhienBanID, attrValueRows[0].GiaTriID]
          );
        }
      }
    }

    await connection.commit();
    res.json({
      message: "Cập nhật sản phẩm thành công!",
      productId: id,
    });
  } catch (error) {
    await connection.rollback();

    // Cleanup any uploaded images if there was an error
    if (req.files) {
      for (const file of req.files) {
        await cloudinary.uploader.destroy(file.filename);
      }
    }

    console.error("Lỗi khi cập nhật sản phẩm:", error);
    res.status(500).json({
      message: error.message || "Lỗi server khi cập nhật sản phẩm",
    });
  } finally {
    connection.release();
  }
};

// === HÀM XÓA SẢN PHẨM (ARCHIVE) ===
exports.deleteProduct = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id } = req.params;

    await connection.beginTransaction();

    // 1. Check if product exists and get its current status
    const [product] = await connection.query(
      "SELECT TrangThai FROM SanPham WHERE SanPhamID = ?",
      [id]
    );

    if (product.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm" });
    }

    // 2. Check if product is already archived
    if (product[0].TrangThai === "ARCHIVED") {
      return res
        .status(400)
        .json({ message: "Sản phẩm đã được lưu trữ trước đó" });
    }

    // 3. Check if product has any orders
    const [orders] = await connection.query(
      `SELECT COUNT(*) as count 
       FROM ChiTietDonHang ctdh 
       JOIN PhienBanSanPham pb ON ctdh.PhienBanID = pb.PhienBanID 
       WHERE pb.SanPhamID = ?`,
      [id]
    );

    // 4. If product has orders, just archive it
    if (orders[0].count > 0) {
      await connection.query(
        "UPDATE SanPham SET TrangThai = 'ARCHIVED' WHERE SanPhamID = ?",
        [id]
      );
    } else {
      // 5. If no orders, we can delete associated data
      // Get image URLs for Cloudinary cleanup
      const [images] = await connection.query(
        "SELECT URL FROM HinhAnhSanPham WHERE SanPhamID = ?",
        [id]
      );

      // Delete from HinhAnhSanPham
      await connection.query("DELETE FROM HinhAnhSanPham WHERE SanPhamID = ?", [
        id,
      ]);

      // Get variant IDs
      const [variants] = await connection.query(
        "SELECT PhienBanID FROM PhienBanSanPham WHERE SanPhamID = ?",
        [id]
      );
      const variantIds = variants.map((v) => v.PhienBanID);

      if (variantIds.length > 0) {
        // Delete from ChiTietPhienBan
        await connection.query(
          "DELETE FROM ChiTietPhienBan WHERE PhienBanID IN (?)",
          [variantIds]
        );
      }

      // Delete from PhienBanSanPham
      await connection.query(
        "DELETE FROM PhienBanSanPham WHERE SanPhamID = ?",
        [id]
      );

      // Delete from KhuyenMai if any
      await connection.query("DELETE FROM KhuyenMai WHERE SanPhamID = ?", [id]);

      // Finally delete the product
      await connection.query("DELETE FROM SanPham WHERE SanPhamID = ?", [id]);

      // Clean up images from Cloudinary
      for (const image of images) {
        const publicId = image.URL.split("/").pop().split(".")[0];
        await cloudinary.uploader.destroy(publicId);
      }
    }

    await connection.commit();
    res.json({
      message:
        orders[0].count > 0
          ? "Sản phẩm đã được lưu trữ thành công"
          : "Sản phẩm đã được xóa hoàn toàn",
    });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi xóa/lưu trữ sản phẩm:", error);
    res.status(500).json({ message: "Lỗi server khi xóa sản phẩm" });
  } finally {
    connection.release();
  }
};

// === HÀM BÁN CHẠY & MỚI NHẤT (ĐÃ NÂNG CẤP) ===
exports.getBestSellingProducts = async (req, res) => {
  try {
    const [products] = await pool.query(
      `SELECT 
         sp.SanPhamID, 
         sp.TenSanPham, 
         sp.Slug, 
         sp.GiaGoc,
         (SELECT HinhAnh.URL FROM HinhAnhSanPham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnhChinh,
         (SELECT MIN(pb_inner.GiaBan) FROM PhienBanSanPham AS pb_inner 
          WHERE pb_inner.SanPhamID = sp.SanPhamID) as GiaBan,
         SUM(ctdh.SoLuong) AS totalSold,
         
         -- === THÊM 2 CỜ BADGE ===
         IF(sp.NgayTao >= DATE_SUB(NOW(), INTERVAL 7 DAY), 1, 0) AS IsNew,
         (EXISTS (
             SELECT 1 FROM khuyenmai km
             WHERE (km.SanPhamID = sp.SanPhamID OR km.DanhMucID = sp.DanhMucID)
             AND km.NgayBatDau < NOW() AND km.NgayKetThuc > NOW()
         )) AS HasVoucher
         -- =======================

       FROM ChiTietDonHang AS ctdh
       JOIN DonHang AS dh ON ctdh.DonHangID = dh.DonHangID
       JOIN PhienBanSanPham AS pb ON ctdh.PhienBanID = pb.PhienBanID
       JOIN SanPham AS sp ON pb.SanPhamID = sp.SanPhamID
       WHERE (dh.TrangThai = 'DA_GIAO' OR dh.TrangThai = 'DANG_XU_LY') 
         AND sp.TrangThai = 'ACTIVE'
       GROUP BY sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc
       ORDER BY totalSold DESC
       LIMIT 8`
    );
    res.json(products);
  } catch (error) {
    console.error("Lỗi khi lấy sản phẩm bán chạy:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
exports.getNewestProducts = async (req, res) => {
  try {
    const [products] = await pool.query(
      `SELECT 
         sp.SanPhamID, 
         sp.TenSanPham, 
         sp.Slug, 
         sp.GiaGoc, 
         (SELECT HinhAnh.URL 
          FROM HinhAnhSanPham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnhChinh,
         (SELECT MIN(pb.GiaBan) 
          FROM PhienBanSanPham AS pb 
          WHERE pb.SanPhamID = sp.SanPhamID) as GiaBan,
          
          -- === THÊM 2 CỜ BADGE ===
          IF(sp.NgayTao >= DATE_SUB(NOW(), INTERVAL 7 DAY), 1, 0) AS IsNew,
          (EXISTS (
              SELECT 1 FROM khuyenmai km
              WHERE (km.SanPhamID = sp.SanPhamID OR km.DanhMucID = sp.DanhMucID)
              AND km.NgayBatDau < NOW() AND km.NgayKetThuc > NOW()
          )) AS HasVoucher
          -- =======================

       FROM SanPham AS sp
       WHERE sp.TrangThai = 'ACTIVE'
       ORDER BY sp.NgayTao DESC
       LIMIT 16`
    );
    res.json(products);
  } catch (error) {
    console.error("Lỗi khi lấy sản phẩm mới nhất:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Admin: Lấy TẤT CẢ sản phẩm (kể cả DRAFT/ARCHIVED)
// @route   GET /api/admin/products
// @access  Private (Admin)
// server/src/controllers/productController.js (PHIÊN BẢN NÂNG CẤP)

// ... (các hàm khác)

// @desc    Admin: Lấy TẤT CẢ sản phẩm (có phân trang, tìm kiếm, lọc)
// @route   GET /api/admin/products
// @access  Private (Admin)
exports.getAdminProducts = async (req, res) => {
  try {
    const {
      search,
      status,
      sortBy = "DATE_DESC",
      page = 1,
      limit = 10,
    } = req.query;

    let conditions = [];
    let params = [];

    // Điều kiện tìm kiếm (Tên sản phẩm, SKU)
    if (search) {
      conditions.push(`(
        sp.TenSanPham LIKE ? OR
        pb.SKU LIKE ?
      )`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm);
    }

    // Điều kiện trạng thái
    if (status) {
      conditions.push("sp.TrangThai = ?");
      params.push(status);
    } else {
      // Mặc định chỉ hiển thị ACTIVE, DRAFT, ARCHIVED nếu không lọc cụ thể
      conditions.push("sp.TrangThai IN ('ACTIVE', 'DRAFT', 'ARCHIVED')");
    }

    // Tạo WHERE clause
    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

    // ORDER BY clause
    const sortOrder =
      {
        DATE_DESC: "sp.NgayTao DESC",
        DATE_ASC: "sp.NgayTao ASC",
        PRICE_ASC: "GiaBanThapNhat ASC", // Sắp xếp theo alias
        PRICE_DESC: "GiaBanThapNhat DESC",
        STOCK_DESC: "TongTonKho DESC",
        STOCK_ASC: "TongTonKho ASC",
      }[sortBy] || "sp.NgayTao DESC";

    // Tính toán OFFSET
    const offset = (Number(page) - 1) * Number(limit);

    // Query đếm tổng số sản phẩm KHỚP (Quan trọng: Phải sử dụng GROUP BY)
    const countQuery = `
       SELECT COUNT(T.SanPhamID) AS total
       FROM (
          SELECT sp.SanPhamID
          FROM SanPham sp
          LEFT JOIN PhienBanSanPham pb ON sp.SanPhamID = pb.SanPhamID
          ${whereClause}
          GROUP BY sp.SanPhamID
       ) AS T
    `;

    // Thực hiện Count Query
    const [countResult] = await pool.query(countQuery, params);
    const total = countResult[0].total;
    const totalPages = Math.ceil(total / Number(limit));

    // Query chính để lấy danh sách sản phẩm
    const [products] = await pool.query(
      `SELECT 
        sp.SanPhamID, sp.TenSanPham, sp.Slug, sp.GiaGoc, sp.TrangThai, sp.NgayTao,
        (SELECT HinhAnh.URL FROM HinhAnhSanPham AS HinhAnh 
         WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
         LIMIT 1) as HinhAnhChinh,
        MIN(pb.GiaBan) as GiaBanThapNhat,
        SUM(pb.SoLuongTonKho) as TongTonKho
       FROM SanPham AS sp
       LEFT JOIN PhienBanSanPham AS pb ON sp.SanPhamID = pb.SanPhamID
       ${whereClause}
       GROUP BY sp.SanPhamID
       ORDER BY ${sortOrder}
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      success: true,
      products,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: totalPages,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách sản phẩm Admin:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải danh sách sản phẩm",
      error: error.message,
    });
  }
};