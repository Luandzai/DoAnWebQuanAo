// server/src/controllers/userController.js
const pool = require("../config/db");

// @desc    Lấy thông tin tài khoản
// @route   GET /api/user/profile
// @access  Private
exports.getUserProfile = async (req, res) => {
  // Vì middleware "protect" đã lấy thông tin user và gắn vào req.user,
  // chúng ta chỉ cần trả nó về (trừ mật khẩu)
  const userProfile = {
    NguoiDungID: req.user.NguoiDungID,
    HoTen: req.user.HoTen,
    Email: req.user.Email,
    DienThoai: req.user.DienThoai,
    NgaySinh: req.user.NgaySinh,
    GioiTinh: req.user.GioiTinh,
  };
  res.json(userProfile);
};

// @desc    Cập nhật thông tin tài khoản
// @route   PUT /api/user/profile
// @access  Private
exports.updateUserProfile = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;
    const { HoTen, DienThoai, NgaySinh, GioiTinh } = req.body;

    await pool.query(
      "UPDATE NguoiDung SET HoTen = ?, DienThoai = ?, NgaySinh = ?, GioiTinh = ? WHERE NguoiDungID = ?",
      [HoTen, DienThoai, NgaySinh, GioiTinh, NguoiDungID]
    );

    res.json({ message: "Cập nhật thông tin thành công" });
  } catch (error) {
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Lấy danh sách yêu thích
// @route   GET /api/user/wishlist
// @access  Private
exports.getWishlist = async (req, res) => {
  try {
    const NguoiDungID = req.user.NguoiDungID;

    // Query JOIN 3 bảng: YeuThich -> PhienBanSanPham -> SanPham
    const [wishlistItems] = await pool.query(
      `SELECT 
         sp.SanPhamID, 
         sp.TenSanPham, 
         sp.Slug, 
         sp.GiaGoc,
         pb.PhienBanID, 
         pb.GiaBan,
         (SELECT HinhAnh.URL 
          FROM HinhAnhSanPham AS HinhAnh 
          WHERE HinhAnh.SanPhamID = sp.SanPhamID AND HinhAnh.LaAnhChinh = 1 
          LIMIT 1) as HinhAnhChinh
       FROM YeuThich AS yt
       JOIN PhienBanSanPham AS pb ON yt.PhienBanID = pb.PhienBanID
       JOIN SanPham AS sp ON pb.SanPhamID = sp.SanPhamID
       WHERE yt.NguoiDungID = ?`,
      [NguoiDungID]
    );

    res.json(wishlistItems);
  } catch (error) {
    console.error("Lỗi khi lấy wishlist:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// @desc    Lấy các voucher MÀ NGƯỜI DÙNG ĐÃ LƯU (và CHƯA SỬ DỤNG)
// @route   GET /api/user/my-vouchers
// @access  Private
exports.getMyVouchers = async (req, res) => {
  const { NguoiDungID } = req.user;
  try {
    // THÊM: AND ndv.TrangThai = 'DA_NHAN'
    const [myVouchers] = await pool.query(
      `SELECT km.* FROM NguoiDung_Voucher AS ndv
       JOIN KhuyenMai AS km ON ndv.MaKhuyenMai = km.MaKhuyenMai
       WHERE ndv.NguoiDungID = ? 
         AND km.NgayKetThuc > NOW() 
         AND ndv.TrangThai = 'DA_NHAN'`, // Chỉ lấy voucher còn hạn và CHƯA DÙNG
      [NguoiDungID]
    );
    res.json(myVouchers);
  } catch (error) {
    console.error("Lỗi khi lấy voucher của tôi:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
// @desc    Lấy danh sách yêu cầu đổi/trả của người dùng
// @route   GET /api/user/returns
// @access  Private
exports.getMyReturns = async (req, res) => {
  const { NguoiDungID } = req.user;
  try {
    // Lấy tất cả phiếu Returns của user
    const [returns] = await pool.query(
      `SELECT r.ReturnID, r.DonHangID, r.Reason, r.Status, r.NgayYeuCau
       FROM Returns AS r
       JOIN DonHang AS dh ON r.DonHangID = dh.DonHangID
       WHERE dh.NguoiDungID = ?
       ORDER BY r.NgayYeuCau DESC`,
      [NguoiDungID]
    );

    res.json(returns);
  } catch (error) {
    console.error("Lỗi khi lấy danh sách đổi/trả:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
