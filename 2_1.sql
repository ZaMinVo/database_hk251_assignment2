
-- Thủ tục hỗ trợ CRUD sản phẩm (sửa/xóa/thêm mới kèm kiểm tra dữ liệu)
DELIMITER $$

-- Cập nhật sản phẩm và mapping danh mục/thuong hieu (có kiểm tra tồn tại, ràng buộc giá/số lượng)
DROP PROCEDURE IF EXISTS sp_SuaSanPham$$
CREATE PROCEDURE sp_SuaSanPham(
    IN p_MaShop INT,
    IN p_MaSanPham INT,
    IN p_Ten VARCHAR(255),
    IN p_SoLuong INT,
    IN p_GiaBan INT,
    IN p_MaThuongHieu INT,
    IN p_MaDanhMuc INT
)
BEGIN
    DECLARE v_ErrorMsg VARCHAR(255);

    -- Kiểm tra sản phẩm cần sửa có tồn tại
    IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham) THEN
        SET v_ErrorMsg = CONCAT('Lỗi: Không tìm thấy sản phẩm MaSanPham = ', p_MaSanPham);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_ErrorMsg;
    END IF;

    IF p_Ten IS NOT NULL THEN
        UPDATE SanPham
        SET Ten = p_Ten
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
    END IF;

    IF p_SoLuong IS NOT NULL THEN
        IF p_SoLuong < 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Số lượng phải >= 0.';
        END IF;
        UPDATE SanPham
        SET SoLuong = p_SoLuong
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
    END IF;

    IF p_GiaBan IS NOT NULL THEN
        IF p_GiaBan <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Giá bán phải > 0.';
        END IF;
        UPDATE SanPham
        SET GiaBan = p_GiaBan
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM SanPhamThuocVao WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Thiếu bản ghi SanPhamThuocVao để cập nhật.';
    END IF;

    IF p_MaThuongHieu IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE MaThuongHieu = p_MaThuongHieu) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã thương hiệu không tồn tại.';
        END IF;
        UPDATE SanPhamThuocVao
        SET MaThuongHieu = p_MaThuongHieu
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
    END IF;

    IF p_MaDanhMuc IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE MaDanhMuc = p_MaDanhMuc) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã danh mục không tồn tại.';
        END IF;
        UPDATE SanPhamThuocVao
        SET MaDanhMuc = p_MaDanhMuc
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
    END IF;
END$$

-- Đánh dấu sản phẩm đã xóa (soft delete)
DROP PROCEDURE IF EXISTS sp_XoaSanPham$$
CREATE PROCEDURE sp_XoaSanPham(
    IN p_MaShop INT,
    IN p_MaSanPham INT
)
BEGIN
    DECLARE v_ErrorMsg VARCHAR(255);

    -- Kiểm tra sản phẩm tồn tại trước khi đánh dấu xóa
    IF NOT EXISTS (
        SELECT 1
        FROM SanPham
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham
    ) THEN
        SET v_ErrorMsg = CONCAT(
            'Lỗi: Không tìm thấy sản phẩm MaSanPham = ',
            p_MaSanPham,
            ' tại Shop = ',
            p_MaShop
        );
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_ErrorMsg;
    END IF;

    UPDATE SanPham
    SET DaXoa = 1
    WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
END$$

-- Thêm mới sản phẩm kèm mapping danh mục/thuong hieu, sinh MaSanPham tự tăng theo shop
DROP PROCEDURE IF EXISTS InsertSanPhamFull$$
CREATE PROCEDURE InsertSanPhamFull(
    IN p_MaShop INT,
    IN p_Ten VARCHAR(255),
    IN p_SoLuong INT,
    IN p_GiaBan INT,
    IN p_MaDanhMuc INT,
    IN p_MaThuongHieu INT
)
BEGIN
    DECLARE v_MaxMaSanPham INT;

    -- Kiểm tra FK và ràng buộc nghiệp vụ
    IF NOT EXISTS (SELECT 1 FROM Shop WHERE MaShop = p_MaShop) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Shop không tồn tại.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE MaDanhMuc = p_MaDanhMuc) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Danh mục không tồn tại.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE MaThuongHieu = p_MaThuongHieu) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Thương hiệu không tồn tại.';
    END IF;

    IF EXISTS (SELECT 1 FROM SanPham WHERE MaShop = p_MaShop AND Ten = p_Ten) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Tên sản phẩm bị trùng trong shop.';
    END IF;

    IF p_SoLuong < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: SoLuong phải >= 0.';
    END IF;

    IF p_GiaBan <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: GiaBan phải > 0.';
    END IF;

    -- Lấy mã sản phẩm kế tiếp trong shop
    SELECT COALESCE(MAX(MaSanPham), 0) + 1 INTO v_MaxMaSanPham
    FROM SanPham
    WHERE MaShop = p_MaShop;

    -- Thêm sản phẩm mới
    INSERT INTO SanPham (MaShop, MaSanPham, Ten, SoLuong, GiaBan)
    VALUES (p_MaShop, v_MaxMaSanPham, p_Ten, p_SoLuong, p_GiaBan);

    -- Thêm mapping danh mục/thuong hieu
    INSERT INTO SanPhamThuocVao (MaShop, MaSanPham, MaThuongHieu, MaDanhMuc)
    VALUES (p_MaShop, v_MaxMaSanPham, p_MaThuongHieu, p_MaDanhMuc);
END$$

DELIMITER ;
