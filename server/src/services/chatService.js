// server/src/services/chatService.js
const pool = require("../config/db");

/**
 * Tìm kiếm sản phẩm thông minh dựa trên độ khớp từ khóa (Relevance Scoring)
 * Giải quyết vấn đề từ thừa (stop words) tự động.
 */
const searchProductsForAI = async (userMessage) => {
  try {
    // 1. XỬ LÝ CHUỖI
    // - Chuyển về chữ thường, bỏ ký tự đặc biệt
    let cleanMsg = userMessage
      .toLowerCase()
      .replace(/[^\w\sà-ỹ]/g, " ")
      .trim();

    // - Tách thành mảng các từ đơn (tokens)
    // Ví dụ: "áo sơ mi nữ lụa những" -> ["áo", "sơ", "mi", "nữ", "lụa", "những"]
    const tokens = cleanMsg.split(/\s+/).filter((w) => w.length > 1); // Bỏ từ 1 ký tự

    if (tokens.length === 0) return "";

    console.log("🔍 AI đang quét các từ khóa:", tokens);

    // 2. TẠO CÂU QUERY ĐỘNG (OR LOGIC)
    // Tìm sản phẩm chứa ÍT NHẤT 1 trong các từ khóa
    const likeClauses = tokens
      .map(() => `(LOWER(sp.TenSanPham) LIKE ? OR LOWER(dm.TenDanhMuc) LIKE ?)`)
      .join(" OR ");
    const queryParams = [];
    tokens.forEach((token) => {
      queryParams.push(`%${token}%`, `%${token}%`);
    });

    // 3. QUERY DATABASE
    const [products] = await pool.query(
      `
      SELECT 
        sp.SanPhamID,
        sp.TenSanPham, 
        sp.Slug, 
        MIN(pb.GiaBan) as GiaTu,
        SUM(pb.SoLuongTonKho) as TongTonKho,
        dm.TenDanhMuc,
        GROUP_CONCAT(DISTINCT gtt.GiaTri SEPARATOR ', ') as CacThuocTinh
      FROM SanPham sp
      LEFT JOIN DanhMuc dm ON sp.DanhMucID = dm.DanhMucID
      LEFT JOIN PhienBanSanPham pb ON sp.SanPhamID = pb.SanPhamID
      LEFT JOIN ChiTietPhienBan ctpb ON pb.PhienBanID = ctpb.PhienBanID
      LEFT JOIN GiaTriThuocTinh gtt ON ctpb.GiaTriID = gtt.GiaTriID
      WHERE 
        sp.TrangThai = 'ACTIVE'
        AND (${likeClauses}) -- Chỉ cần khớp 1 từ là lấy về để chấm điểm
      GROUP BY sp.SanPhamID
      `,
      queryParams
    );

    // 4. THUẬT TOÁN CHẤM ĐIỂM (SCORING)
    // Tính xem mỗi sản phẩm khớp bao nhiêu từ trong câu của khách
    const scoredProducts = products.map((p) => {
      let score = 0;
      const nameLower = p.TenSanPham.toLowerCase();
      const catLower = p.TenDanhMuc.toLowerCase();

      tokens.forEach((token) => {
        // Nếu tên sản phẩm hoặc danh mục chứa từ khóa -> cộng điểm
        if (nameLower.includes(token) || catLower.includes(token)) {
          score += 1;
        }
      });

      return { ...p, score };
    });

    // 5. LỌC VÀ SẮP XẾP
    // - Sắp xếp theo điểm cao xuống thấp
    scoredProducts.sort((a, b) => b.score - a.score);

    // - Chỉ lấy những sản phẩm có độ khớp cao nhất
    // (Ví dụ: Nếu câu có 5 từ, sản phẩm phải khớp ít nhất 2 từ hoặc 50% số từ quan trọng)
    const bestMatches = scoredProducts.filter((p) => p.score >= 1).slice(0, 5);

    console.log(
      `✅ Tìm thấy ${products.length} ứng viên. Sau khi chấm điểm giữ lại ${bestMatches.length} sản phẩm tốt nhất.`
    );

    if (bestMatches.length === 0) return "";

    // 6. FORMAT KẾT QUẢ CHO AI
    let contextText = `Dưới đây là danh sách sản phẩm thực tế có độ khớp cao nhất với yêu cầu của khách:\n`;

    bestMatches.forEach((p, index) => {
      const status = p.TongTonKho > 0 ? "Còn hàng" : "Hết hàng";
      const price = new Intl.NumberFormat("vi-VN", {
        style: "currency",
        currency: "VND",
      }).format(p.GiaTu || 0);
      const attributes = p.CacThuocTinh ? `(Có: ${p.CacThuocTinh})` : "";

      contextText += `${index + 1}. ${p.TenSanPham} (${
        p.TenDanhMuc
      }) - Giá: ${price} ${attributes} - ${status}\n`;
    });

    return contextText;
  } catch (error) {
    console.error("❌ Lỗi tìm kiếm sản phẩm cho AI:", error);
    return "";
  }
};

module.exports = { searchProductsForAI };
