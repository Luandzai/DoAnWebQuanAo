// server/src/controllers/orderController.js
const pool = require("../config/db");
// 1. IMPORT TIỆN ÍCH VNPAY VÀ MOMO
const { createPaymentUrl } = require("../utils/vnpay");
const { createPaymentRequest } = require("../utils/momo"); // <-- THÊM DÒNG NÀY

// (Hàm createOrder giữ nguyên)
exports.createOrder = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const {
      shippingInfo,
      paymentMethodId, // ID 701 (COD), 702 (VNPAY), 703 (MOMO)
      notes,
      cartItems,
      MaKhuyenMai,
      PhuongThucID,
    } = req.body;
    const {
      TenNguoiNhan,
      DienThoaiNhan,
      SoNha,
      PhuongXa,
      QuanHuyen,
      TinhThanh,
    } = shippingInfo;
    const DiaChiChiTiet = `${SoNha}, ${PhuongXa}, ${QuanHuyen}, ${TinhThanh}`;
    if (!TenNguoiNhan || !DienThoaiNhan || !SoNha || !PhuongXa) {
      return res
        .status(400)
        .json({ message: "Vui lòng điền đầy đủ thông tin giao hàng." });
    }
    const [addrResult] = await connection.query(
      `INSERT INTO DiaChiGiaoHang (NguoiDungID, TenNguoiNhan, DienThoaiNhan, DiaChiChiTiet, PhuongXa, QuanHuyen, TinhThanh, MacDinh) 
       VALUES (?, ?, ?, ?, ?, ?, ?, 0)`,
      [
        NguoiDungID,
        TenNguoiNhan,
        DienThoaiNhan,
        DiaChiChiTiet,
        PhuongXa,
        QuanHuyen,
        TinhThanh,
      ]
    );
    const newDiaChiID = addrResult.insertId;

    await connection.beginTransaction();

    let TongTienHang = 0;
    const phienBanIDs = cartItems.map((item) => item.PhienBanID);
    if (phienBanIDs.length === 0) {
      await connection.rollback();
      return res.status(400).json({ message: "Giỏ hàng trống." });
    }
    const [dbItems] = await connection.query(
      "SELECT PhienBanID, GiaBan, SoLuongTonKho, SanPhamID FROM PhienBanSanPham WHERE PhienBanID IN (?)",
      [phienBanIDs]
    );
    for (const item of cartItems) {
      const dbItem = dbItems.find((p) => p.PhienBanID === item.PhienBanID);
      if (!dbItem)
        throw new Error(`Sản phẩm ID ${item.PhienBanID} không tồn tại.`);
      if (dbItem.SoLuongTonKho < item.SoLuong)
        throw new Error(`Sản phẩm không đủ tồn kho.`);
      TongTienHang += dbItem.GiaBan * item.SoLuong;
    }

    let PhiVanChuyen = 0;
    if (PhuongThucID) {
      const [shipMethod] = await connection.query(
        "SELECT PhiCoDinh FROM PhuongThucVanChuyen WHERE PhuongThucID = ?",
        [PhuongThucID]
      );
      if (shipMethod.length > 0)
        PhiVanChuyen = parseFloat(shipMethod[0].PhiCoDinh);
    }
    // === PHẦN LOGIC TIÊU THỤ VOUCHER ===
    let GiamGia = 0;
    if (MaKhuyenMai) {
      // 1. Kiểm tra user CÓ voucher này và CHƯA DÙNG
      const [myVoucher] = await connection.query(
        `SELECT * FROM NguoiDung_Voucher 
         WHERE NguoiDungID = ? AND MaKhuyenMai = ? AND TrangThai = 'DA_NHAN'`,
        [NguoiDungID, MaKhuyenMai]
      );
      if (myVoucher.length === 0) {
        throw new Error("Mã giảm giá không hợp lệ hoặc đã được sử dụng.");
      }

      // 2. Kiểm tra voucher (Hạn, Số lượng, Điều kiện)
      const [vouchers] = await connection.query(
        "SELECT * FROM KhuyenMai WHERE MaKhuyenMai = ? AND NgayKetThuc > NOW() AND ApDungToiThieu <= ? AND SoLuongToiDa > 0",
        [MaKhuyenMai, TongTienHang]
      );
      if (vouchers.length === 0) {
        throw new Error(
          "Mã giảm giá đã hết hạn, hết lượt sử dụng hoặc không đủ điều kiện."
        );
      }

      // 3. Tính toán giảm giá
      const voucher = vouchers[0];
      if (voucher.LoaiGiamGia === "SOTIEN")
        GiamGia = parseFloat(voucher.GiaTriGiam);
      if (voucher.LoaiGiamGia === "PHANTRAM")
        GiamGia = (TongTienHang * parseFloat(voucher.GiaTriGiam)) / 100;

      // 4. TIÊU THỤ VOUCHER
      // 4a. Đánh dấu voucher là 'DA_SU_DUNG' cho user này
      await connection.query(
        "UPDATE NguoiDung_Voucher SET TrangThai = 'DA_SU_DUNG' WHERE NguoiDungID = ? AND MaKhuyenMai = ?",
        [NguoiDungID, MaKhuyenMai]
      );
      // 4b. Giảm số lượng tổng trong bảng KhuyenMai
      await connection.query(
        "UPDATE KhuyenMai SET SoLuongToiDa = SoLuongToiDa - 1 WHERE MaKhuyenMai = ?",
        [MaKhuyenMai]
      );
    }
    const TongThanhToan = TongTienHang + PhiVanChuyen - GiamGia;

    // 2. LOGIC TRẠNG THÁI BAN ĐẦU (SỬA LẠI DÒNG NÀY)
    const isOnlinePayment =
      paymentMethodId == "702" || paymentMethodId == "703";
    const initialTrangThai = isOnlinePayment ? "CHUA_THANH_TOAN" : "DANG_XU_LY";
    // ===============================================

    const [orderResult] = await connection.query(
      "INSERT INTO DonHang (NguoiDungID, DiaChiGiaoHangID, MaKhuyenMai, PhuongThucID, TongTienHang, PhiVanChuyen, TongThanhToan, TrangThai, GhiChu) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [
        NguoiDungID,
        newDiaChiID,
        MaKhuyenMai,
        PhuongThucID,
        TongTienHang,
        PhiVanChuyen,
        TongThanhToan,
        initialTrangThai, // <-- SỬ DỤNG TRẠNG THÁI MỚI
        notes,
      ]
    );
    const newDonHangID = orderResult.insertId;

    for (const item of cartItems) {
      const dbItem = dbItems.find((p) => p.PhienBanID === item.PhienBanID);
      await connection.query(
        "INSERT INTO ChiTietDonHang (DonHangID, PhienBanID, SoLuong, GiaLucMua) VALUES (?, ?, ?, ?)",
        [newDonHangID, item.PhienBanID, item.SoLuong, dbItem.GiaBan]
      );
    }
    await connection.query(
      'INSERT INTO ThanhToan (DonHangID, MethodID, SoTienThanhToan, TrangThai) VALUES (?, ?, ?, "PENDING")',
      [newDonHangID, paymentMethodId, TongThanhToan]
    );
    // === SỬA LỖI: CHỈ XÓA NHỮNG SẢN PHẨM ĐÃ ĐẶT HÀNG KHỎI GIỎ HÀNG ===
    const orderedPhienBanIDs = cartItems.map((item) => item.PhienBanID);
    if (orderedPhienBanIDs.length > 0) {
      await connection.query(
        "DELETE FROM ChiTietGioHang WHERE GioHangID = ? AND PhienBanID IN (?)",
        [NguoiDungID, orderedPhienBanIDs]
      );
    }
    // =================================================================

    await connection.commit();

    // 3. LOGIC TRẢ VỀ URL (THÊM MOMO)
    if (paymentMethodId == "702") {
      // Nếu là VNPAY
      const ipAddr =
        req.headers["x-forwarded-for"] ||
        req.connection.remoteAddress ||
        req.socket.remoteAddress ||
        (req.connection.socket ? req.connection.socket.remoteAddress : null);

      const paymentUrl = createPaymentUrl(
        newDonHangID,
        TongThanhToan,
        ipAddr,
        `Thanh toan don hang ${newDonHangID}`
      );

      res.status(201).json({
        message: "Đơn hàng đã được tạo, đang chuyển hướng...",
        DonHangID: newDonHangID,
        paymentUrl: paymentUrl, // <-- Trả về URL
      });
    } else if (paymentMethodId == "703") {
      // Nếu là MOMO
      const momoResponse = await createPaymentRequest(
        newDonHangID,
        TongThanhToan,
        `Thanh toan don hang ${newDonHangID}`
      );

      res.status(201).json({
        message: "Đơn hàng đã được tạo, đang chuyển hướng...",
        DonHangID: newDonHangID,
        paymentUrl: momoResponse.payUrl, // <-- Trả về payUrl của MoMo
      });
    } else {
      // Nếu là COD
      res
        .status(201)
        .json({ message: "Đặt hàng thành công!", DonHangID: newDonHangID });
    }
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi đặt hàng:", error);
    res
      .status(500)
      .json({ message: error.message || "Lỗi server khi đặt hàng" });
  } finally {
    connection.release();
  }
};

// (Hàm getMyOrders giữ nguyên)
exports.getMyOrders = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;

    // 1. CẬP NHẬT CÂU QUERY: Thêm Subquery (EXISTS)
    const [orders] = await pool.query(
      `SELECT 
         dh.DonHangID, dh.NgayDatHang, dh.TongThanhToan, dh.TrangThai,
         (EXISTS (SELECT 1 FROM Returns r WHERE r.DonHangID = dh.DonHangID)) AS DaYeuCauTraHang
       FROM DonHang AS dh
       WHERE dh.NguoiDungID = ? 
       ORDER BY dh.NgayDatHang DESC`,
      [NguoiDungID]
    );

    // 2. Dùng Promise.all để lấy 'items' cho TỪNG đơn hàng
    const orderDetails = await Promise.all(
      orders.map(async (order) => {
        const [items] = await pool.query(
          `SELECT 
           ctdh.PhienBanID, ctdh.SoLuong, ctdh.GiaLucMua, 
           sp.TenSanPham, 
           (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
            FROM ChiTietPhienBan AS ctpb
            JOIN GiaTriThuocTinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
            JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
            WHERE ctpb.PhienBanID = ctdh.PhienBanID
           ) AS ThuocTinh,
           (SELECT HinhAnh.URL FROM HinhAnhSanPham AS HinhAnh 
            WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
            LIMIT 1) as HinhAnh,
            
           -- === SỬA ĐỔI: THÊM CỜ ĐÃ ĐÁNH GIÁ ===
           (EXISTS (
             SELECT 1 FROM DanhGia dg 
             WHERE dg.PhienBanID = ctdh.PhienBanID AND dg.NguoiDungID = ?
           )) AS DaDanhGia
           -- =====================================

         FROM ChiTietDonHang AS ctdh
         JOIN PhienBanSanPham AS pb ON ctdh.PhienBanID = pb.PhienBanID
         JOIN SanPham AS sp ON pb.SanPhamID = sp.SanPhamID
         WHERE ctdh.DonHangID = ?`,
          [NguoiDungID, order.DonHangID] // Thêm NguoiDungID vào query
        );
        // 3. Gắn mảng 'items' vào mỗi object 'order'
        return { ...order, items: items };
      })
    );

    res.json(orderDetails); // 4. Trả về mảng đơn hàng đã có items
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đơn hàng:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// (Hàm getOrderById giữ nguyên)
exports.getOrderById = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const DonHangID = req.params.id;
    const [orderRows] = await pool.query(
      `SELECT dh.*, dc.TenNguoiNhan, dc.DienThoaiNhan, dc.DiaChiChiTiet, ptt.TenPhuongThuc AS TenPhuongThucThanhToan
       FROM DonHang AS dh
       LEFT JOIN DiaChiGiaoHang AS dc ON dh.DiaChiGiaoHangID = dc.DiaChiID
       LEFT JOIN ThanhToan AS tt ON dh.DonHangID = tt.DonHangID
       LEFT JOIN PaymentMethods AS ptt ON tt.MethodID = ptt.MethodID
       WHERE dh.DonHangID = ? AND dh.NguoiDungID = ?`,
      [DonHangID, NguoiDungID]
    );
    if (orderRows.length === 0) {
      return res.status(404).json({ message: "Không tìm thấy đơn hàng" });
    }
    const order = orderRows[0];

    // 6. SỬA LỖI CÂU QUERY NÀY (giống như trên)
    const [items] = await pool.query(
      `SELECT 
         ctdh.*, sp.TenSanPham, sp.Slug, pb.SKU, 
         (SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
            FROM ChiTietPhienBan AS ctpb
            JOIN GiaTriThuocTinh AS gtt ON ctpb.GiaTriID = gtt.GiaTriID
            JOIN ThuocTinh AS tt ON gtt.ThuocTinhID = tt.ThuocTinhID
            WHERE ctpb.PhienBanID = ctdh.PhienBanID
           ) AS ThuocTinh,
         (SELECT HinhAnh.URL FROM HinhAnhSanPham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnh
       FROM ChiTietDonHang AS ctdh
       JOIN PhienBanSanPham AS pb ON ctdh.PhienBanID = pb.PhienBanID
       JOIN SanPham AS sp ON pb.SanPhamID = sp.SanPhamID
       WHERE ctdh.DonHangID = ?`,
      [DonHangID]
    );

    res.json({ ...order, items });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết đơn hàng:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// (Hàm cancelOrder giữ nguyên)
exports.cancelOrder = async (req, res) => {
  const connection = await pool.getConnection();
  try {
    const { id: DonHangID } = req.params;
    const { NguoiDungID } = req.user;
    await connection.beginTransaction();
    const [orderRows] = await connection.query(
      "SELECT * FROM DonHang WHERE DonHangID = ? AND NguoiDungID = ?",
      [DonHangID, NguoiDungID]
    );
    if (orderRows.length === 0) throw new Error("Không tìm thấy đơn hàng.");
    const order = orderRows[0];
    // SỬA: Cho phép hủy cả CHUA_THANH_TOAN
    if (
      order.TrangThai !== "DANG_XU_LY" &&
      order.TrangThai !== "CHUA_THANH_TOAN"
    ) {
      throw new Error(
        "Chỉ có thể hủy đơn hàng ở trạng thái 'Đang xử lý' hoặc 'Chưa thanh toán'."
      );
    }
    await connection.query(
      "UPDATE DonHang SET TrangThai = 'DA_HUY' WHERE DonHangID = ?",
      [DonHangID]
    );
    await connection.query(
      "UPDATE ThanhToan SET TrangThai = 'CANCELLED' WHERE DonHangID = ?",
      [DonHangID]
    );
    await connection.commit();
    res.json({ message: "Đã hủy đơn hàng thành công!" });
  } catch (error) {
    await connection.rollback();
    console.error("Lỗi khi hủy đơn hàng:", error);
    res.status(400).json({ message: error.message || "Lỗi server" });
  } finally {
    connection.release();
  }
};

// ... (Các hàm Admin giữ nguyên) ...
// @desc    Admin: Lấy TẤT CẢ đơn hàng (có phân trang)
// @route   GET /api/admin/orders
// @access  Private (Admin)
exports.getAllOrders = async (req, res) => {
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

    // Điều kiện tìm kiếm
    if (search) {
      conditions.push(`(
        dh.DonHangID LIKE ? OR
        nd.HoTen LIKE ? OR
        nd.Email LIKE ?
      )`);
      const searchTerm = `%${search}%`;
      params.push(searchTerm, searchTerm, searchTerm);
    }

    // Điều kiện trạng thái
    if (status) {
      conditions.push("dh.TrangThai = ?");
      params.push(status);
    }

    // Tạo WHERE clause
    const whereClause =
      conditions.length > 0 ? "WHERE " + conditions.join(" AND ") : "";

    // ORDER BY clause
    const sortOrder =
      {
        DATE_DESC: "dh.NgayDatHang DESC",
        DATE_ASC: "dh.NgayDatHang ASC",
        TOTAL_DESC: "dh.TongThanhToan DESC",
        TOTAL_ASC: "dh.TongThanhToan ASC",
      }[sortBy] || "dh.NgayDatHang DESC";

    // Đếm tổng số đơn hàng
    const [countResult] = await pool.query(
      `SELECT COUNT(*) as total 
       FROM DonHang dh
       JOIN NguoiDung nd ON dh.NguoiDungID = nd.NguoiDungID
       ${whereClause}`,
      params
    );

    const total = countResult[0].total;
    const offset = (page - 1) * limit;

    // Query chính để lấy danh sách đơn hàng
    const [orders] = await pool.query(
      `SELECT 
        dh.*,
        nd.HoTen,
        nd.Email,
        dc.TenNguoiNhan,
        dc.DienThoaiNhan,
        dc.DiaChiChiTiet
       FROM DonHang dh
       JOIN NguoiDung nd ON dh.NguoiDungID = nd.NguoiDungID
       LEFT JOIN DiaChiGiaoHang dc ON dh.DiaChiGiaoHangID = dc.DiaChiID
       ${whereClause}
       ORDER BY ${sortOrder}
       LIMIT ? OFFSET ?`,
      [...params, Number(limit), offset]
    );

    res.json({
      orders,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đơn hàng:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải danh sách đơn hàng",
      error: error.message,
    });
  }
};

// @desc    Admin: Xem chi tiết đơn hàng
// @route   GET /api/admin/orders/:id
// @access  Private (Admin)
exports.getAdminOrderDetail = async (req, res) => {
  try {
    const orderId = req.params.id;

    // 1. Lấy thông tin đơn hàng, khách hàng, địa chỉ, thanh toán, khuyến mãi và NGƯỜI CẬP NHẬT
    const [orders] = await pool.query(
      `SELECT 
        dh.*,
        nd.HoTen AS TenKhachHang, nd.Email AS EmailKhachHang,
        dc.TenNguoiNhan, dc.DienThoaiNhan, dc.DiaChiChiTiet,
        ptvc.TenPhuongThuc,
        km.MaKhuyenMai, km.TenKhuyenMai, km.GiaTriGiam, km.LoaiGiamGia,
        uc.HoTen AS NguoiCapNhatTen -- Tên Admin cập nhật cuối
      FROM DonHang dh
      JOIN NguoiDung nd ON dh.NguoiDungID = nd.NguoiDungID
      LEFT JOIN DiaChiGiaoHang dc ON dh.DiaChiGiaoHangID = dc.DiaChiID
      LEFT JOIN PhuongThucVanChuyen ptvc ON dh.PhuongThucID = ptvc.PhuongThucID
      LEFT JOIN KhuyenMai km ON dh.MaKhuyenMai = km.MaKhuyenMai
      LEFT JOIN NguoiDung uc ON dh.NguoiCapNhat = uc.NguoiDungID -- JOIN NguoiCapNhat
      WHERE dh.DonHangID = ?`,
      [orderId]
    );

    if (orders.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "Không tìm thấy đơn hàng" });
    }

    const order = orders[0];

    // 2. Lấy chi tiết sản phẩm (Giữ nguyên Query phức tạp của bạn)
    const [items] = await pool.query(
      `SELECT 
        ctdh.*,
        sp.TenSanPham,
        sp.Slug,
        pb.SKU,
        (
          SELECT GROUP_CONCAT(CONCAT(tt.TenThuocTinh, ': ', gtt.GiaTri) SEPARATOR ', ')
          FROM ChiTietPhienBan ctpb
          JOIN GiaTriThuocTinh gtt ON ctpb.GiaTriID = gtt.GiaTriID
          JOIN ThuocTinh tt ON gtt.ThuocTinhID = tt.ThuocTinhID
          WHERE ctpb.PhienBanID = ctdh.PhienBanID
        ) AS ThuocTinh,
        (
          SELECT ha.URL 
          FROM HinhAnhSanPham ha
          WHERE ha.SanPhamID = sp.SanPhamID AND ha.LaAnhChinh = 1
          LIMIT 1
        ) AS HinhAnh
      FROM ChiTietDonHang ctdh
      JOIN PhienBanSanPham pb ON ctdh.PhienBanID = pb.PhienBanID
      JOIN SanPham sp ON pb.SanPhamID = sp.SanPhamID
      WHERE ctdh.DonHangID = ?`,
      [orderId]
    );

    // 3. Lấy lịch sử đơn hàng
    const [history] = await pool.query(
      `SELECT *
       FROM LichSuDonHang
       WHERE DonHangID = ?
       ORDER BY ThoiGian DESC`,
      [orderId]
    );

    res.json({
      success: true,
      data: {
        ...order,
        items,
        history,
      },
    });
  } catch (error) {
    console.error("Lỗi khi lấy chi tiết đơn hàng:", error);
    res.status(500).json({
      success: false,
      message: "Lỗi khi tải chi tiết đơn hàng",
      error: error.message,
    });
  }
};

// @desc    Admin: Cập nhật trạng thái đơn hàng
// @route   PUT /api/admin/orders/:id/status
// @access  Private (Admin)
// Quy tắc chuyển trạng thái đơn hàng
const STATUS_TRANSITIONS = {
  CHUA_THANH_TOAN: ["DANG_XU_LY", "DA_HUY"],
  DANG_XU_LY: ["DANG_GIAO", "DA_HUY"],
  DANG_GIAO: ["DA_GIAO", "DA_HUY"],
  DA_GIAO: [], // Trạng thái cuối
  DA_HUY: [], // Trạng thái cuối
};

exports.updateOrderStatus = async (req, res) => {
  let connection;
  try {
    const { id } = req.params;
    const { trangThaiMoi } = req.body;
    const adminId = req.user?.NguoiDungID;

    console.log("=== DEBUG UPDATE STATUS ===");
    console.log("Order ID:", id);
    console.log("New Status:", trangThaiMoi);
    console.log("Admin ID:", adminId);
    console.log("Status Type:", typeof trangThaiMoi);
    console.log("Status Length:", trangThaiMoi?.length);

    // 1. Validate đầu vào
    if (!id || !trangThaiMoi || !adminId) {
      return res.status(400).json({
        success: false,
        message: "Thiếu thông tin cập nhật trạng thái",
        details: {
          orderId: id || "missing",
          status: trangThaiMoi || "missing",
          adminId: adminId || "missing",
        },
      });
    }

    const orderId = parseInt(id);
    if (isNaN(orderId) || orderId <= 0) {
      return res.status(400).json({
        success: false,
        message: "Mã đơn hàng không hợp lệ",
        details: { provided: id },
      });
    }

    // 2. Validate trạng thái hợp lệ
    const validStatuses = [
      "CHUA_THANH_TOAN",
      "DANG_XU_LY",
      "DANG_GIAO",
      "DA_GIAO",
      "DA_HUY",
    ];

    if (!validStatuses.includes(trangThaiMoi)) {
      return res.status(400).json({
        success: false,
        message: "Trạng thái không hợp lệ",
        details: {
          receivedStatus: trangThaiMoi,
          validStatuses: validStatuses,
        },
      });
    }

    // 3. Bắt đầu transaction
    connection = await pool.getConnection();
    await connection.beginTransaction();

    try {
      // 4. Kiểm tra và lấy thông tin đơn hàng
      const [orders] = await connection.query(
        `SELECT 
          dh.DonHangID,
          dh.TrangThai,
          dh.TongThanhToan,
          kh.HoTen as TenKhachHang,
          kh.Email as EmailKhachHang
        FROM DonHang dh
        JOIN NguoiDung kh ON dh.NguoiDungID = kh.NguoiDungID
        WHERE dh.DonHangID = ?`,
        [orderId]
      );

      if (orders.length === 0) {
        throw new Error(`Không tìm thấy đơn hàng #${orderId}`);
      }

      const order = orders[0];
      const currentStatus = order.TrangThai;

      console.log("Current Status:", currentStatus);
      console.log("Allowed Transitions:", STATUS_TRANSITIONS[currentStatus]);

      // 5. Kiểm tra quy tắc chuyển trạng thái
      if (currentStatus === trangThaiMoi) {
        throw new Error("Đơn hàng đã ở trạng thái này");
      }

      const allowedTransitions = STATUS_TRANSITIONS[currentStatus] || [];
      if (!allowedTransitions.includes(trangThaiMoi)) {
        throw new Error(
          `Không thể chuyển từ trạng thái ${currentStatus} sang ${trangThaiMoi}. Chỉ có thể chuyển sang: ${
            allowedTransitions.length > 0
              ? allowedTransitions.join(", ")
              : "không thể chuyển (trạng thái cuối)"
          }`
        );
      }

      // 6. Cập nhật trạng thái đơn hàng - ĐÂY LÀ PHẦN QUAN TRỌNG
      const [updateResult] = await connection.query(
        `UPDATE DonHang 
         SET TrangThai = ?
         WHERE DonHangID = ?`,
        [trangThaiMoi, orderId]
      );

      console.log("Update Result:", updateResult);

      if (updateResult.affectedRows === 0) {
        throw new Error("Không thể cập nhật trạng thái đơn hàng");
      }

      // 7. Xử lý các tác vụ đặc biệt theo trạng thái
      if (trangThaiMoi === "DA_HUY") {
        // 7a. Cập nhật trạng thái thanh toán
        await connection.query(
          `UPDATE ThanhToan 
           SET TrangThai = 'FAILED'
           WHERE DonHangID = ?`,
          [orderId]
        );

        // 7b. Hoàn trả tồn kho
        const [items] = await connection.query(
          `SELECT 
            ctdh.PhienBanID,
            ctdh.SoLuong,
            pb.SoLuongTonKho,
            sp.TenSanPham
          FROM ChiTietDonHang ctdh
          JOIN PhienBanSanPham pb ON ctdh.PhienBanID = pb.PhienBanID
          JOIN SanPham sp ON pb.SanPhamID = sp.SanPhamID
          WHERE ctdh.DonHangID = ?`,
          [orderId]
        );

        for (const item of items) {
          console.log("Hoàn trả tồn kho:", {
            sanPham: item.TenSanPham,
            soLuong: item.SoLuong,
            tonKhoHienTai: item.SoLuongTonKho,
          });

          await connection.query(
            `UPDATE PhienBanSanPham 
             SET SoLuongTonKho = SoLuongTonKho + ?
             WHERE PhienBanID = ?`,
            [item.SoLuong, item.PhienBanID]
          );
        }
      }

      // 8. Ghi log lịch sử
      await connection.query(
        `INSERT INTO LichSuDonHang (
          DonHangID, 
          TrangThaiCu,
          TrangThaiMoi,
          ThoiGian,
          GhiChu
        ) VALUES (?, ?, ?, NOW(), ?)`,
        [
          orderId,
          currentStatus,
          trangThaiMoi,
          `Đơn hàng được chuyển từ trạng thái ${currentStatus} sang ${trangThaiMoi}`,
        ]
      );

      // 9. Commit transaction
      await connection.commit();

      console.log("=== UPDATE SUCCESS ===");

      // 10. Trả về kết quả thành công
      res.json({
        success: true,
        message: `Đã cập nhật trạng thái đơn hàng thành công`,
        data: {
          orderId: orderId,
          previousStatus: currentStatus,
          newStatus: trangThaiMoi,
          customer: {
            name: order.TenKhachHang,
            email: order.EmailKhachHang,
          },
        },
      });
    } catch (error) {
      // Rollback nếu có lỗi
      await connection.rollback();
      throw error;
    }
  } catch (error) {
    console.error("=== ERROR UPDATE STATUS ===");
    console.error("Error:", error);
    console.error("Error Message:", error.message);
    console.error("Error Stack:", error.stack);

    res.status(error.message.includes("Không tìm thấy") ? 404 : 400).json({
      success: false,
      message: error.message,
    });
  } finally {
    if (connection) {
      connection.release();
    }
  }
};
