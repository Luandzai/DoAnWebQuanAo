// client/src/components/Chatbot.jsx
import React, { useState, useRef, useEffect } from "react";
import "./Chatbot.css";
import { BiCommentDetail, BiSend, BiX } from "react-icons/bi";
import axios from "axios";

const Chatbot = () => {
  const [isOpen, setIsOpen] = useState(false); // Trạng thái mở/đóng cửa sổ chat
  const [inputStr, setInputStr] = useState(""); // Nội dung ô nhập liệu
  const [isLoading, setIsLoading] = useState(false); // Trạng thái AI đang trả lời

  // Danh sách tin nhắn ban đầu
  const [messages, setMessages] = useState([
    {
      text: "Chào bạn! Mình là Stylist ảo của Blank Canvas. Bạn cần tư vấn chọn đồ gì hôm nay nhỉ? ✨",
      isBot: true,
    },
  ]);

  // Ref để tự động cuộn xuống tin nhắn mới nhất
  const messagesEndRef = useRef(null);
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };
  useEffect(scrollToBottom, [messages]);

  // Hàm gửi tin nhắn
  const handleSend = async () => {
    if (!inputStr.trim()) return;

    // 1. Lưu lại tin nhắn người dùng vừa nhập để hiển thị ngay
    const currentUserMessage = inputStr;
    const userMsgObj = { text: currentUserMessage, isBot: false };

    // Cập nhật UI ngay lập tức
    setMessages((prev) => [...prev, userMsgObj]);
    setInputStr("");
    setIsLoading(true);

    try {
      // 2. Chuẩn bị lịch sử chat để gửi lên Server
      // Map danh sách messages hiện tại sang format chuẩn API (role: 'user' | 'assistant')
      const historyPayload = messages.map((msg) => ({
        role: msg.isBot ? "assistant" : "user",
        content: msg.text,
      }));

      // LƯU Ý: 'historyPayload' ở đây CHƯA BAO GỒM tin nhắn mới nhất vừa nhập (currentUserMessage)
      // vì state 'messages' cập nhật là bất đồng bộ (async).
      // Tuy nhiên, Backend của chúng ta đã thiết kế để nhận:
      // - history: Các tin nhắn CŨ
      // - message: Tin nhắn MỚI NHẤT
      // => Nên logic này là hoàn toàn chính xác.

      const response = await axios.post("http://localhost:5000/api/chat", {
        message: currentUserMessage, // Tin nhắn mới
        history: historyPayload, // Lịch sử cũ
      });

      // 3. Nhận phản hồi và hiển thị
      const botMsg = { text: response.data.reply, isBot: true };
      setMessages((prev) => [...prev, botMsg]);
    } catch (error) {
      console.error("Lỗi gửi tin nhắn:", error);
      const errorMsg = {
        text: "⚠️ Mất kết nối tới server stylist.",
        isBot: true,
      };
      setMessages((prev) => [...prev, errorMsg]);
    } finally {
      setIsLoading(false);
    }
  };

  // Xử lý khi nhấn Enter
  const handleKeyPress = (e) => {
    if (e.key === "Enter" && !isLoading) handleSend();
  };

  return (
    <>
      {/* Nút tròn để mở chat */}
      {!isOpen && (
        <div className="chatbot-bubble" onClick={() => setIsOpen(true)}>
          <BiCommentDetail />
        </div>
      )}

      {/* Cửa sổ chat */}
      {isOpen && (
        <div className="chatbot-window">
          <div className="chatbot-header">
            <span>Blank Canvas Stylist AI ✨</span>
            <BiX
              size={24}
              style={{ cursor: "pointer" }}
              onClick={() => setIsOpen(false)}
            />
          </div>

          <div className="chatbot-messages">
            {messages.map((msg, index) => (
              <div
                key={index}
                className={`message ${msg.isBot ? "bot" : "user"}`}
              >
                {msg.text}
              </div>
            ))}
            {/* Hiệu ứng đang gõ */}
            {isLoading && (
              <div className="typing">Stylist đang soạn tin...</div>
            )}
            {/* Phần tử ẩn để cuộn xuống đáy */}
            <div ref={messagesEndRef} />
          </div>

          <div className="chatbot-input">
            <input
              type="text"
              placeholder="Nhập tin nhắn..."
              value={inputStr}
              onChange={(e) => setInputStr(e.target.value)}
              onKeyDown={handleKeyPress}
              disabled={isLoading}
            />
            <button
              onClick={handleSend}
              disabled={isLoading || !inputStr.trim()}
            >
              <BiSend />
            </button>
          </div>
        </div>
      )}
    </>
  );
};

export default Chatbot;
