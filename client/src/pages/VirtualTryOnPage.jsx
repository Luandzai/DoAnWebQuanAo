import React, { useState } from 'react';
import axios from 'axios';
import './VirtualTryOnPage.css'; // File CSS tùy chỉnh

const VirtualTryOnPage = () => {
  const [personImage, setPersonImage] = useState(null);
  const [personPreview, setPersonPreview] = useState(null);
  const [clothImage, setClothImage] = useState(null);
  const [clothPreview, setClothPreview] = useState(null);

  const [loading, setLoading] = useState(false);
  const [resultImage, setResultImage] = useState(null);
  const [error, setError] = useState('');

  const handleImageChange = (e, type) => {
    const file = e.target.files[0];
    if (file) {
      if (type === 'person') {
        setPersonImage(file);
        setPersonPreview(URL.createObjectURL(file));
      } else {
        setClothImage(file);
        setClothPreview(URL.createObjectURL(file));
      }
      setResultImage(null); // Clear previous result when a new image is selected
      setError('');
    }
  };

  const handleTryOn = async () => {
    if (!personImage) {
      setError('Vui lòng tải lên ảnh của bạn.');
      return;
    }
    if (!clothImage) {
      setError('Vui lòng tải lên ảnh trang phục.');
      return;
    }

    const formData = new FormData();
    formData.append('personImage', personImage);
    formData.append('clothImage', clothImage);

    setLoading(true);
    setError('');
    setResultImage(null);

    try {
      const response = await axios.post('http://localhost:5000/api/try-on', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      if (response.data.resultUrl) {
        setResultImage(response.data.resultUrl);
      } else {
        setError('Không nhận được ảnh kết quả từ server.');
      }
    } catch (err) {
      const errorMessage = err.response?.data?.message || 'Đã có lỗi xảy ra. Vui lòng thử lại.';
      setError(errorMessage);
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container mt-5 mb-5">
      <div className="text-center mb-4">
        <h1 className="fw-bold">Virtual Try-On</h1>
        <p className="text-muted">Thử trang phục ảo với công nghệ AI</p>
      </div>

      <div className="row g-4">
        {/* Cột 1: Tải ảnh người */}
        <div className="col-lg-4">
          <div className="card h-100">
            <div className="card-body text-center d-flex flex-column">
              <h5 className="card-title mb-3">1. Tải Lên Ảnh Của Bạn</h5>
              <div className="image-container-person mb-3 flex-grow-1">
                 {personPreview ? (
                    <img src={personPreview} alt="Người mẫu" className="img-fluid rounded" />
                 ) : (
                    <div className="placeholder-image d-flex align-items-center justify-content-center">
                        <span>Ảnh của bạn sẽ hiện ở đây</span>
                    </div>
                 )}
              </div>
              <label htmlFor="person-upload" className="btn btn-secondary">
                {personPreview ? 'Thay đổi ảnh' : 'Tải ảnh lên'}
              </label>
              <input id="person-upload" type="file" accept="image/*" onChange={(e) => handleImageChange(e, 'person')} className="d-none" />
            </div>
          </div>
        </div>

        {/* Cột 2: Tải ảnh trang phục */}
        <div className="col-lg-4">
          <div className="card h-100">
            <div className="card-body text-center d-flex flex-column">
              <h5 className="card-title mb-3">2. Tải Lên Ảnh Trang Phục</h5>
              <div className="image-container-cloth mb-3 flex-grow-1">
                {clothPreview ? (
                    <img src={clothPreview} alt="Trang phục" className="img-fluid rounded" />
                ) : (
                    <div className="placeholder-image d-flex align-items-center justify-content-center">
                        <span>Ảnh trang phục bạn tải lên</span>
                    </div>
                )}
              </div>
              <label htmlFor="cloth-upload" className="btn btn-secondary">
                {clothPreview ? 'Thay đổi ảnh' : 'Tải ảnh trang phục'}
              </label>
              <input id="cloth-upload" type="file" accept="image/*" onChange={(e) => handleImageChange(e, 'cloth')} className="d-none" />
            </div>
          </div>
        </div>
        
        {/* Cột 3: Kết quả */}
        <div className="col-lg-4">
            <div className="card h-100">
                <div className="card-body text-center d-flex flex-column">
                    <h5 className="card-title mb-3">3. Kết Quả</h5>
                    <div className="image-container-person mb-3 flex-grow-1"> {/* Re-using class for style consistency */}
                        {loading ? (
                            <div className="placeholder-image d-flex align-items-center justify-content-center h-100">
                                <span className="spinner-border text-primary" role="status">
                                    <span className="visually-hidden">Loading...</span>
                                </span>
                            </div>
                        ) : resultImage ? (
                            <img src={resultImage} alt="Kết quả" className="img-fluid rounded" />
                        ) : (
                            <div className="placeholder-image d-flex align-items-center justify-content-center">
                                <span>Ảnh ghép sẽ hiện ở đây</span>
                            </div>
                        )}
                    </div>
                     {/* Can add a download button here later if needed */}
                </div>
            </div>
        </div>
      </div>

      {/* Nút Action */}
      <div className="text-center mt-4">
        {error && <div className="alert alert-danger">{error}</div>}
        <button onClick={handleTryOn} className="btn btn-primary btn-lg" disabled={loading}>
          {loading ? (
            <>
              <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
              {' '}Đang xử lý...
            </>
          ) : 'Bắt Đầu Thử Đồ'}
        </button>
      </div>
    </div>
  );
};

export default VirtualTryOnPage;