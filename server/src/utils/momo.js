// server/src/utils/momo.js
const crypto = require("crypto");
const axios = require("axios"); // Đảm bảo bạn đã cài: npm install axios
require("dotenv").config();

// Hàm tạo chữ ký HMAC-SHA256
function createSignature(rawSignature, secretKey) {
  return crypto
    .createHmac("sha256", secretKey)
    .update(rawSignature)
    .digest("hex");
}

// Hàm sắp xếp (giống VNPAY)
function sortObject(obj) {
  let sorted = {};
  let str = [];
  let key;
  // Sửa lỗi hasOwnProperty
  str = Object.keys(obj);

  str.sort(); // Sắp xếp mảng các key

  for (key = 0; key < str.length; key++) {
    const sortedKey = str[key];
    sorted[sortedKey] = encodeURIComponent(obj[sortedKey]).replace(/%20/g, "+");
  }
  return sorted;
}

/**
 * @param {string} DonHangID Mã đơn hàng
 * @param {number} TongThanhToan Tổng số tiền
 * @param {string} orderInfo Mô tả đơn hàng
 */
exports.createPaymentRequest = async (
  DonHangID,
  TongThanhToan,
  orderInfo = "Thanh toan don hang"
) => {
  const partnerCode = process.env.MOMO_PARTNER_CODE;
  const accessKey = process.env.MOMO_ACCESS_KEY;
  const secretKey = process.env.MOMO_SECRET_KEY;
  const apiEndpoint = process.env.MOMO_API_ENDPOINT;

  // URL backend của bạn (dùng cho IPN và Return)
  // (Sử dụng ngrok hoặc domain thật khi deploy)
  const backendUrl = process.env.BACKEND_URL || "http://localhost:5000";

  const redirectUrl = `${backendUrl}/api/payment/momo_return`;
  const ipnUrl = `${backendUrl}/api/payment/momo_ipn`;
  const amount = TongThanhToan.toString();
  const orderId = DonHangID.toString() + "_" + new Date().getTime(); // MoMo yêu cầu orderId duy nhất
  const requestId = orderId;
  const requestType = "captureWallet"; // Loại thanh toán QR
  const extraData = ""; // Có thể để trống

  // 1. Chuỗi (string) để tạo chữ ký
  const rawSignature =
    `accessKey=${accessKey}` +
    `&amount=${amount}` +
    `&extraData=${extraData}` +
    `&ipnUrl=${ipnUrl}` +
    `&orderId=${orderId}` +
    `&orderInfo=${orderInfo}` +
    `&partnerCode=${partnerCode}` +
    `&redirectUrl=${redirectUrl}` +
    `&requestId=${requestId}` +
    `&requestType=${requestType}`;

  // 2. Tạo chữ ký
  const signature = createSignature(rawSignature, secretKey);

  // 3. Body của request
  const requestBody = {
    partnerCode: partnerCode,
    accessKey: accessKey,
    requestId: requestId,
    amount: amount,
    orderId: orderId,
    orderInfo: orderInfo,
    redirectUrl: redirectUrl,
    ipnUrl: ipnUrl,
    requestType: requestType,
    extraData: extraData,
    signature: signature,
    lang: "vi",
  };

  try {
    const response = await axios.post(apiEndpoint, requestBody);
    // Trả về payUrl từ MoMo
    return response.data;
  } catch (error) {
    console.error("Lỗi khi tạo yêu cầu MoMo:", error.response.data);
    throw new Error("Không thể tạo yêu cầu thanh toán MoMo.");
  }
};

/**
 * @param {object} body Body của IPN request
 */
// === LỖI ĐÃ ĐƯỢC SỬA Ở DÒNG NÀY (XÓA DẤU '_') ===
exports.verifyIpnSignature = (body) => {
  const secretKey = process.env.MOMO_SECRET_KEY;
  const { signature } = body;

  // Xóa chữ ký ra khỏi body
  delete body.signature;

  // Sắp xếp các key còn lại theo alphabet
  const sortedBody = {};
  Object.keys(body)
    .sort()
    .forEach((key) => {
      sortedBody[key] = body[key];
    });

  // Tạo rawSignature từ các key đã sắp xếp
  const rawSignature = Object.keys(sortedBody)
    .map((key) => `${key}=${sortedBody[key]}`)
    .join("&");

  // Tạo chữ ký mới
  const expectedSignature = createSignature(rawSignature, secretKey);

  // So sánh
  return signature === expectedSignature;
};

/**
 * @param {object} queryParams Query params từ MoMo trả về (Return URL)
 */
exports.verifyReturnSignature = (queryParams) => {
  const secretKey = process.env.MOMO_SECRET_KEY;
  const { signature } = queryParams;

  // Xóa chữ ký
  delete queryParams.signature;

  // Sắp xếp
  const sortedParams = {};
  Object.keys(queryParams)
    .sort()
    .forEach((key) => {
      sortedParams[key] = queryParams[key];
    });

  // Tạo rawSignature
  const rawSignature = Object.keys(sortedParams)
    .map((key) => `${key}=${sortedParams[key]}`)
    .join("&");

  const expectedSignature = createSignature(rawSignature, secretKey);

  return signature === expectedSignature;
};
