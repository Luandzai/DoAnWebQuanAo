// client/src/hooks/useProductDetail.js
import { useState, useEffect, useContext, useCallback, useMemo } from 'react';
import { toast } from 'react-toastify';
import AuthContext from '../context/AuthContext';
import CartContext from '../context/CartContext';

export const useProductDetail = (slug) => {
    // Main data states
    const [product, setProduct] = useState(null);
    const [relatedProducts, setRelatedProducts] = useState([]);
    const [vouchers, setVouchers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    // Variant and selection states
    const [availableAttributes, setAvailableAttributes] = useState([]);
    const [selectedOptions, setSelectedOptions] = useState({});
    const [selectedVariant, setSelectedVariant] = useState(null);
    const [quantity, setQuantity] = useState(1);

    // Image gallery states
    const [currentImageIndex, setCurrentImageIndex] = useState(0);
    const [selectedImage, setSelectedImage] = useState('');

    // Voucher claiming state
    const [claimingVoucher, setClaimingVoucher] = useState(false);

    // Contexts
    const { api, user } = useContext(AuthContext);
    const { addToCart } = useContext(CartContext);

    // Fetch all product-related data
    const fetchProductData = useCallback(async () => {
        setLoading(true);
        try {
            const productResponse = await api.get(`/products/${slug}`);
            const mainProduct = productResponse.data;
            if (!mainProduct) throw new Error("404 - Không tìm thấy sản phẩm");
            
            setProduct(mainProduct);

            const voucherPromise = api.get(`/vouchers/product/${mainProduct.SanPhamID}`);
            const relatedPromise = mainProduct.DanhMucSlug
                ? api.get(`/products?danhMuc=${mainProduct.DanhMucSlug}`)
                : Promise.resolve({ data: { products: [] } });

            const [voucherResponse, relatedResponse] = await Promise.all([voucherPromise, relatedPromise]);
            
            setVouchers(voucherResponse.data);
            setRelatedProducts(relatedResponse.data.products || []);

            if (mainProduct.HinhAnh?.length > 0) {
                setSelectedImage(mainProduct.HinhAnh[0].URL);
                setCurrentImageIndex(0);
            }
        } catch (err) {
            setError(err.message || "Không thể tải chi tiết sản phẩm.");
        } finally {
            setLoading(false);
        }
    }, [api, slug]);

    useEffect(() => {
        window.scrollTo(0, 0);
        fetchProductData();
    }, [slug, fetchProductData]);

    // Parse attributes and set default selections when product data is loaded
    useEffect(() => {
        if (product?.PhienBan?.length > 0) {
            const attributesMap = new Map();
            product.PhienBan.forEach((variant) => {
                if (variant.options) {
                    Object.entries(variant.options).forEach(([name, value]) => {
                        if (!attributesMap.has(name)) attributesMap.set(name, new Set());
                        attributesMap.get(name).add(value);
                    });
                }
            });
            
            const parsedAttributes = Array.from(attributesMap.entries()).map(([name, valueSet]) => ({
                name: name,
                values: [...valueSet],
            }));
            setAvailableAttributes(parsedAttributes);

            // Set default options from the first variant
            const defaultVariant = product.PhienBan[0];
            if (defaultVariant.options) {
                setSelectedOptions(defaultVariant.options);
            }
        }
    }, [product]);

    // Update selected variant when options change
    useEffect(() => {
        if (product && availableAttributes.length > 0 && Object.keys(selectedOptions).length > 0) {
            const newVariant = product.PhienBan.find((variant) => {
                if (!variant.options) return false;
                return availableAttributes.every((attr) => {
                    const selectedValue = selectedOptions[attr.name];
                    return variant.options[attr.name] === selectedValue;
                });
            });
            setSelectedVariant(newVariant || null);
            setQuantity(1); // Reset quantity when variant changes
        }
    }, [product, selectedOptions, availableAttributes]);

    // Update main image when index changes
    useEffect(() => {
        if (product?.HinhAnh?.length > 0) {
            setSelectedImage(product.HinhAnh[currentImageIndex].URL);
        }
    }, [currentImageIndex, product]);

    // Handlers
    const handleOptionSelect = (name, value) => {
        // 1. Find all variants that have this specific option value
        const compatibleVariants = product.PhienBan.filter(v => 
            v.options && v.options[name] === value
        );

        if (compatibleVariants.length === 0) return;

        // 2. Find the "best" variant among them
        // We score them based on how many OTHER currently selected options they match
        let bestVariant = compatibleVariants[0];
        let maxMatchCount = -1;

        compatibleVariants.forEach(variant => {
            let matchCount = 0;
            Object.entries(selectedOptions).forEach(([currentKey, currentValue]) => {
                if (currentKey !== name && variant.options[currentKey] === currentValue) {
                    matchCount++;
                }
            });

            if (matchCount > maxMatchCount) {
                maxMatchCount = matchCount;
                bestVariant = variant;
            }
        });

        // 3. Select that variant's options entirely
        // This automatically clears incompatible keys (like "Kích Cỡ Chung" vs "Kích Cỡ")
        if (bestVariant && bestVariant.options) {
            setSelectedOptions(bestVariant.options);
        }
    };

    const handleQuantityChange = (amount) => {
        setQuantity((prev) => Math.max(1, prev + amount));
    };

    const handleAddToCart = () => {
        if (!user) {
            toast.error("Vui lòng đăng nhập để thêm vào giỏ hàng");
            return;
        }
        if (selectedVariant) {
            if (quantity > selectedVariant.SoLuongTonKho) {
                toast.error("Số lượng vượt quá tồn kho!");
                return;
            }
            addToCart(selectedVariant.PhienBanID, quantity);
        } else {
            toast.warn("Vui lòng chọn đầy đủ các thuộc tính");
        }
    };

    const handleClaimVoucher = async (maKhuyenMai) => {
        if (!user) {
            toast.error("Vui lòng đăng nhập để nhận voucher");
            return;
        }

        setClaimingVoucher(true);
        try {
            const response = await api.post('/vouchers/collect', { MaKhuyenMai: maKhuyenMai });
            toast.success(response.data.message || "Đã lưu voucher!");
            // Optionally refetch vouchers to update UI
            if (product?.SanPhamID) {
                const voucherResponse = await api.get(`/vouchers/product/${product.SanPhamID}`);
                setVouchers(voucherResponse.data);
            }
        } catch (err) {
            const errorMsg = err.response?.data?.message || "Không thể nhận voucher";
            toast.error(errorMsg);
        } finally {
            setClaimingVoucher(false);
        }
    };
    
    // Memoized derived values
    const avgRating = useMemo(() => {
        if (product?.DanhGia?.length > 0) {
            return product.DanhGia.reduce((acc, item) => acc + item.DiemSo, 0) / product.DanhGia.length;
        }
        return 0;
    }, [product]);
    
    const reviewCount = useMemo(() => product?.DanhGia?.length || 0, [product]);
    const totalSold = useMemo(() => parseFloat(product?.TotalSold) || 0, [product]);

    return {
        product,
        loading,
        error,
        relatedProducts,
        vouchers,
        availableAttributes,
        selectedOptions,
        selectedVariant,
        quantity,
        selectedImage,
        currentImageIndex,
        avgRating,
        reviewCount,
        totalSold,
        handleOptionSelect,
        handleQuantityChange,
        setCurrentImageIndex,
        handleAddToCart,
        handleClaimVoucher,
        claimingVoucher,
    };
};
