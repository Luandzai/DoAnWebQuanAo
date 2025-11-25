import React, { useState, useRef, useEffect } from 'react';
import './Chatbot.css';
// Import các icon
import { BiCommentDetail, BiSend, BiX } from 'react-icons/bi'; 
import axios from 'axios';

const Chatbot = () => {
    const [isOpen, setIsOpen] = useState(false); // Trạng thái mở/đóng cửa sổ chat
    const [inputStr, setInputStr] = useState(""); // Nội dung ô nhập liệu
    const [isLoading, setIsLoading] = useState(false); // Trạng thái AI đang trả lời
    
    // Danh sách tin nhắn ban đầu
    const [messages, setMessages] = useState([
        { text: "Chào bạn! Mình là Stylist ảo của Blank Canvas. Bạn cần tư vấn chọn đồ gì hôm nay nhỉ? ✨", isBot: true }
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

        // 1. Thêm tin nhắn người dùng vào danh sách hiển thị ngay lập tức
        const userMsg = { text: inputStr, isBot: false };
        setMessages(prev => [...prev, userMsg]);
        setInputStr(""); // Xóa ô nhập
        setIsLoading(true); // Bật trạng thái chờ

        try {
            // 2. Gọi API xuống Server Node.js của bạn
            // LƯU Ý: Đảm bảo port 5000 đúng với port server bạn đang chạy
            const response = await axios.post('http://localhost:5000/api/chat', {
                message: inputStr
            });

            // 3. Nhận phản hồi và hiển thị
            const botMsg = { text: response.data.reply, isBot: true };
            setMessages(prev => [...prev, botMsg]);

        } catch (error) {
            console.error("Lỗi gửi tin nhắn:", error);
            const errorMsg = { text: "⚠️ Mất kết nối tới server stylist.", isBot: true };
            setMessages(prev => [...prev, errorMsg]);
        } finally {
            setIsLoading(false); // Tắt trạng thái chờ
        }
    };

    // Xử lý khi nhấn Enter
    const handleKeyPress = (e) => {
        if (e.key === 'Enter' && !isLoading) handleSend();
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
                        <BiX size={24} style={{cursor:'pointer'}} onClick={() => setIsOpen(false)} />
                    </div>

                    <div className="chatbot-messages">
                        {messages.map((msg, index) => (
                            <div key={index} className={`message ${msg.isBot ? 'bot' : 'user'}`}>
                                {msg.text}
                            </div>
                        ))}
                        {/* Hiệu ứng đang gõ */}
                        {isLoading && <div className="typing">Stylist đang soạn tin...</div>}
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
                        <button onClick={handleSend} disabled={isLoading || !inputStr.trim()}>
                            <BiSend />
                        </button>
                    </div>
                </div>
            )}
        </>
    );
};

export default Chatbot;
