// server/src/controllers/adminController.js
const pool = require("../config/db");

// @desc    Admin: Lấy dữ liệu thống kê cho Dashboard
// @route   GET /api/admin/dashboard-stats
// @access  Private (Admin)
exports.getDashboardStats = async (req, res) => {
  try {
    // 1. DOANH SỐ THÁNG HIỆN TẠI (Đơn hàng đã giao)
    const [salesResult] = await pool.query(
      `SELECT SUM(TongThanhToan) AS totalSales 
       FROM DonHang 
       WHERE TrangThai = 'DA_GIAO' 
         AND MONTH(NgayDatHang) = MONTH(NOW()) 
         AND YEAR(NgayDatHang) = YEAR(NOW())`
    );
    const totalSales = parseFloat(salesResult[0].totalSales) || 0;

    // 2. SỐ LƯỢNG ĐƠN HÀNG MỚI (Trạng thái DANG_XU_LY)
    const [newOrdersResult] = await pool.query(
      `SELECT COUNT(*) AS newOrdersCount 
       FROM DonHang 
       WHERE TrangThai = 'DANG_XU_LY'`
    );
    const newOrdersCount = newOrdersResult[0].newOrdersCount || 0;

    // 3. SẢN PHẨM TỒN KHO THẤP (Tồn kho <= 10)
    const LOW_STOCK_THRESHOLD = 10;
    const [lowStockResult] = await pool.query(
      `SELECT COUNT(*) AS lowStockCount 
       FROM PhienBanSanPham 
       WHERE SoLuongTonKho <= ?`,
      [LOW_STOCK_THRESHOLD]
    );
    const lowStockCount = lowStockResult[0].lowStockCount || 0;

    // 4. TỔNG SỐ NGƯỜI DÙNG
    const [totalUsersResult] = await pool.query(
      `SELECT COUNT(*) AS totalUsersCount FROM NguoiDung WHERE VaiTro = 'KHACHHANG'`
    );
    const totalUsersCount = totalUsersResult[0].totalUsersCount || 0;

    // 5. DANH SÁCH ĐƠN HÀNG MỚI (5 đơn gần nhất)
    const [latestOrders] = await pool.query(
      `SELECT dh.DonHangID, dh.NgayDatHang, dh.TongThanhToan, dh.TrangThai, nd.HoTen
         FROM DonHang AS dh
         JOIN NguoiDung AS nd ON dh.NguoiDungID = nd.NguoiDungID
         WHERE dh.TrangThai IN ('DANG_XU_LY', 'CHUA_THANH_TOAN') 
         ORDER BY dh.NgayDatHang DESC
         LIMIT 5`
    );

    res.json({
      totalSales: totalSales,
      newOrdersCount: newOrdersCount,
      lowStockCount: lowStockCount,
      totalUsersCount: totalUsersCount, // Thêm vào đây
      latestOrders: latestOrders,
    });
  } catch (error) {
    console.error("Lỗi khi lấy dữ liệu Dashboard:", error);
    res.status(500).json({ message: "Lỗi server khi lấy thống kê" });
  }
};

// @desc    Admin: Lấy TẤT CẢ người dùng (có phân trang, tìm kiếm, lọc)
// @route   GET /api/admin/users
// @access  Private (Admin)
exports.getAllUsers = async (req, res) => {
  try {
    const {
      search,
      role, // KHACHHANG | ADMIN
      status, // ACTIVE | INACTIVE
      sortBy = "DATE_DESC",
      page = 1,
      limit = 10,
    } = req.query;

    let conditions = [];
    let params = [];

    // Điều kiện tìm kiếm (HoTen, Email, DienThoai, GoogleID)
    if (search) {
      conditions.push(`(
        HoTen LIKE ? OR
        Email LIKE ? OR
        DienThoai LIKE ? OR
        GoogleID LIKE ?
      )`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm, searchTerm);
    }

    // Điều kiện vai trò (Role)
    if (role) {
      conditions.push("VaiTro = ?");
      params.push(role);
    }

    // Điều kiện trạng thái (Status)
    if (status) {
      conditions.push("TrangThai = ?");
      params.push(status);
    }

    // Tạo WHERE clause
    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

    // ORDER BY clause
    const sortOrder =
      {
        DATE_DESC: "NgayTao DESC",
        DATE_ASC: "NgayTao ASC",
        NAME_ASC: "HoTen ASC",
        NAME_DESC: "HoTen DESC",
      }[sortBy] || "NgayTao DESC";

    // Tính toán OFFSET
    const offset = (Number(page) - 1) * Number(limit);

    // 1. Đếm tổng số người dùng
    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total FROM NguoiDung ${whereClause}`,
      params
    );

    const total = countResult[0].total;
    const totalPages = Math.ceil(total / Number(limit));

    // 2. Query chính để lấy danh sách người dùng
    const [users] = await pool.query(
      `SELECT 
        NguoiDungID, Email, LoaiXacThuc, HoTen, DienThoai, 
        VaiTro, TrangThai, NgayTao
       FROM NguoiDung
       ${whereClause}
       ORDER BY ${sortOrder}
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      success: true,
      users,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: totalPages,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách người dùng Admin:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải danh sách người dùng",
      error: error.message,
    });
  }
};

// @desc    Admin: Cập nhật trạng thái người dùng (ACTIVE/INACTIVE)
// @route   PUT /api/admin/users/:id/status
// @access  Private (Admin)
exports.updateUserStatus = async (req, res) => {
  try {
    const { id: NguoiDungID } = req.params;
    const { trangThaiMoi } = req.body;
    const AdminID = req.user.NguoiDungID; // Lấy ID Admin từ middleware

    // 1. Kiểm tra trạng thái hợp lệ
    if (!["ACTIVE", "INACTIVE"].includes(trangThaiMoi)) {
      return res.status(400).json({ message: "Trạng thái không hợp lệ." });
    }

    // 2. Không cho phép Admin tự khóa tài khoản của mình
    if (parseInt(NguoiDungID) === AdminID) {
      return res.status(400).json({
        message: "Không thể tự thay đổi trạng thái tài khoản Admin của mình.",
      });
    }

    // 3. Cập nhật trạng thái trong DB
    const [result] = await pool.query(
      `UPDATE NguoiDung SET TrangThai = ? WHERE NguoiDungID = ?`,
      [trangThaiMoi, NguoiDungID]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy người dùng." });
    }

    res.json({
      message: `Đã cập nhật trạng thái người dùng #${NguoiDungID} thành công.`,
      newStatus: trangThaiMoi,
    });
  } catch (error) {
    console.error("Lỗi khi cập nhật trạng thái người dùng:", error);
    res.status(500).json({ message: "Lỗi server khi cập nhật trạng thái" });
  }
};

// @desc    Admin: Cập nhật vai trò người dùng (KHACHHANG/ADMIN)
// @route   PUT /api/admin/users/:id/role
// @access  Private (Admin)
exports.updateUserRole = async (req, res) => {
  try {
    const { id: NguoiDungID } = req.params;
    const { vaiTroMoi } = req.body;
    const AdminID = req.user.NguoiDungID;

    // 1. Kiểm tra vai trò hợp lệ
    if (!["KHACHHANG", "ADMIN"].includes(vaiTroMoi)) {
      return res.status(400).json({ message: "Vai trò không hợp lệ." });
    }

    // 2. Không cho phép Admin tự thay đổi vai trò của mình
    if (parseInt(NguoiDungID) === AdminID) {
      return res
        .status(400)
        .json({ message: "Không thể tự thay đổi vai trò Admin của mình." });
    }

    // 3. Cập nhật vai trò trong DB
    const [result] = await pool.query(
      `UPDATE NguoiDung SET VaiTro = ? WHERE NguoiDungID = ?`,
      [vaiTroMoi, NguoiDungID]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Không tìm thấy người dùng." });
    }

    res.json({
      message: `Đã cập nhật vai trò người dùng #${NguoiDungID} thành ${vaiTroMoi} thành công.`,
      newRole: vaiTroMoi,
    });
  } catch (error) {
    console.error("Lỗi khi cập nhật vai trò người dùng:", error);
    res.status(500).json({ message: "Lỗi server khi cập nhật vai trò" });
  }
};

// @desc    Admin: Lấy doanh thu theo tháng của một năm cụ thể
// @route   GET /api/admin/sales/monthly?year=YYYY
// @access  Private (Admin)
exports.getMonthlySales = async (req, res) => {
  try {
    const targetYear = parseInt(req.query.year) || new Date().getFullYear();

    const [monthlySales] = await pool.query(
      `
      SELECT 
          MONTH(NgayDatHang) AS month,
          SUM(TongThanhToan) AS totalRevenue
      FROM 
          DonHang
      WHERE 
          TrangThai = 'DA_GIAO' AND YEAR(NgayDatHang) = ?
      GROUP BY 
          MONTH(NgayDatHang)
      ORDER BY 
          month ASC
      `,
      [targetYear]
    );

    const formattedSales = Array.from({ length: 12 }, (_, i) => ({
      month: i + 1,
      revenue: 0,
    }));

    monthlySales.forEach((item) => {
      const monthIndex = item.month - 1;
      formattedSales[monthIndex].revenue = parseFloat(item.totalRevenue) || 0;
    });

    res.json({
      year: targetYear,
      salesData: formattedSales,
      message: `Dữ liệu doanh thu năm ${targetYear} đã sẵn sàng.`,
    });
  } catch (error) {
    console.error("Lỗi khi lấy dữ liệu doanh thu theo tháng:", error);
    res.status(500).json({ message: "Lỗi server khi lấy dữ liệu biểu đồ" });
  }
};
exports.getTopSellingProducts = async (req, res) => {
  try {
    const limit = Number(req.query.limit) || 10;
    const year = parseInt(req.query.year) || new Date().getFullYear();

    const [rows] = await pool.query(
      `
      SELECT 
        pbs.PhienBanID,
        sp.TenSanPham,
        pbs.SKU, 
        SUM(ct.SoLuong) AS totalSold,
        SUM(ct.SoLuong * ct.GiaLucMua) AS totalRevenue
      FROM chitietdonhang ct
      JOIN donhang dh ON ct.DonHangID = dh.DonHangID
      JOIN phienbansanpham pbs ON ct.PhienBanID = pbs.PhienBanID
      JOIN sanpham sp ON pbs.SanPhamID = sp.SanPhamID
      WHERE dh.TrangThai = 'DA_GIAO' AND YEAR(dh.NgayDatHang) = ?
      GROUP BY pbs.PhienBanID, sp.TenSanPham, pbs.SKU
      ORDER BY totalSold DESC
      LIMIT ?
      `,
      [year, limit]
    );

    res.json({ success: true, year, products: rows });
  } catch (error) {
    console.error("Lỗi khi lấy sản phẩm bán chạy:", error);
    res.status(500).json({ success: false, message: "Lỗi server khi lấy sản phẩm bán chạy" });
  }
};
exports.getLowStockProducts = async (req, res) => {
  try {
    const threshold = Number(req.query.threshold) || 10;
    const limit = Number(req.query.limit) || 50;

    const [rows] = await pool.query(
      `
      SELECT 
        pbs.PhienBanID,
        sp.TenSanPham,
        pbs.SKU,
        pbs.SoLuongTonKho
      FROM phienbansanpham pbs
      JOIN sanpham sp ON pbs.SanPhamID = sp.SanPhamID
      WHERE pbs.SoLuongTonKho <= ?
      ORDER BY pbs.SoLuongTonKho ASC
      LIMIT ?
      `,
      [threshold, limit]
    );

    res.json({ success: true, threshold, products: rows });
  } catch (error) {
    console.error("Lỗi khi lấy sản phẩm sắp hết hàng:", error);
    res.status(500).json({ success: false, message: "Lỗi server khi lấy sản phẩm sắp hết hàng" });
  }
};
exports.getTopCustomers = async (req, res) => {
  try {
    const limit = Number(req.query.limit) || 10;
    const year = parseInt(req.query.year) || new Date().getFullYear();

    const [rows] = await pool.query(
      `
      SELECT
        nd.NguoiDungID,
        nd.HoTen,
        nd.Email,
        COUNT(dh.DonHangID) AS orderCount,
        SUM(dh.TongThanhToan) AS totalSpent
      FROM donhang dh
      JOIN nguoidung nd ON dh.NguoiDungID = nd.NguoiDungID
      WHERE dh.TrangThai = 'DA_GIAO' AND YEAR(dh.NgayDatHang) = ?
      GROUP BY nd.NguoiDungID, nd.HoTen, nd.Email
      ORDER BY totalSpent DESC
      LIMIT ?
      `,
      [year, limit]
    );

    res.json({ success: true, year, customers: rows });
  } catch (error) {
    console.error("Lỗi khi lấy khách hàng tiềm năng:", error);
    res.status(500).json({ success: false, message: "Lỗi server khi lấy khách hàng tiềm năng" });
  }
};
