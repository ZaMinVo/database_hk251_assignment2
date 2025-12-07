
-- Thủ tục hỗ trợ CRUD sản phẩm (sửa/xóa/thêm mới kèm kiểm tra dữ liệu)
DELIMITER $$

-- Cập nhật sản phẩm và mapping danh mục/thuong hieu (có kiểm tra tồn tại, ràng buộc giá/số lượng)
DROP PROCEDURE IF EXISTS sp_SuaSanPham$$
CREATE PROCEDURE sp_SuaSanPham(
    IN p_MaShop INT,
    IN p_MaSanPham INT,
    IN p_Ten VARCHAR(255),
    IN p_AnhUrl VARCHAR(512),
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
        IF p_Ten NOT REGEXP '^[A-Za-zÀ-Ỵà-ỵĂăÂâĐđÊêÔôƠơƯư\\s]+$' THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Lỗi: Tên sản phẩm chỉ được chứa ký tự chữ cái tiếng Việt và khoảng trắng.';
        END IF;

        UPDATE SanPham
        SET Ten = p_Ten
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
    END IF;

    IF p_AnhUrl IS NOT NULL THEN
        UPDATE SanPham
        SET AnhUrl = p_AnhUrl
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

-- Xử lí xóa sản phẩm (soft delete nếu sản phẩm đã thuộc GioPhu trong DonHang, ngược lại xóa cứng)
DROP PROCEDURE IF EXISTS sp_XoaSanPham$$
CREATE PROCEDURE sp_XoaSanPham(
    IN p_MaShop INT,
    IN p_MaSanPham INT
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_ErrorMsg VARCHAR(255);

    -- Kiểm tra sản phẩm có tồn tại
    IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham) THEN
        SET v_ErrorMsg = CONCAT('Lỗi: Không tìm thấy sản phẩm MaSanPham = ', p_MaSanPham, ' tại Shop = ', p_MaShop);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_ErrorMsg;
    END IF;

    -- Kiểm tra sản phẩm có thuộc GioPhu mà GioPhu đó đã có trong DonHang không
    SELECT COUNT(*)
    INTO v_count
    FROM GioPhuChuaSanPham gps
    JOIN GioPhu gp 
        ON gps.MaGioHang = gp.MaGioHang
        AND gps.MaGioPhu  = gp.MaGioPhu
    JOIN DonHang dh
        ON dh.MaGioHang = gp.MaGioHang 
        AND dh.MaGioPhu  = gp.MaGioPhu
    WHERE gps.MaSanPham = p_MaSanPham
    AND gps.MaShop = p_MaShop;

    IF v_count > 0 THEN
        -- Soft delete: đánh dấu DaXoa
        UPDATE SanPham
        SET DaXoa = TRUE
        WHERE MaShop = p_MaShop AND MaSanPham = p_MaSanPham;
    ELSE
        -- Hard delete: xóa các dữ liệu liên quan

        -- 1. Xóa thông tin sản phẩm trong bảng SanPhamThuocVao
        DELETE FROM SanPhamThuocVao
        WHERE MaSanPham = p_MaSanPham AND MaShop = p_MaShop;

        -- 2. Xóa sản phẩm khỏi GioPhuChuaSanPham nếu GioPhu chưa thuộc đơn hàng nào
        DELETE gps
        FROM GioPhuChuaSanPham gps
        LEFT JOIN GioPhu gp 
            ON gps.MaGioHang = gp.MaGioHang 
           AND gps.MaGioPhu = gp.MaGioPhu
        LEFT JOIN DonHang dh 
            ON dh.MaGioHang = gp.MaGioHang
           AND dh.MaGioPhu  = gp.MaGioPhu
        WHERE gps.MaSanPham = p_MaSanPham
          AND gps.MaShop = p_MaShop
          AND dh.MaDonHang IS NULL;

        -- 3. Xóa sản phẩm
        DELETE FROM SanPham
        WHERE MaSanPham = p_MaSanPham AND MaShop = p_MaShop;
    END IF;
END $$

-- Thêm mới sản phẩm kèm mapping danh mục/thuong hieu, sinh MaSanPham tự tăng theo shop
DROP PROCEDURE IF EXISTS sp_ThemSanPham$$
CREATE PROCEDURE sp_ThemSanPham(
    IN p_MaShop INT,
    IN p_Ten VARCHAR(255),
    IN p_AnhUrl VARCHAR(512),
    IN p_SoLuong INT,
    IN p_GiaBan INT,
    IN p_MaDanhMuc INT,
    IN p_MaThuongHieu INT
)
BEGIN
    DECLARE v_MaxMaSanPham INT;

    -- Kiểm tra shop tồn tại
    IF NOT EXISTS (SELECT 1 FROM Shop WHERE MaShop = p_MaShop) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Shop không tồn tại.';
    END IF;

    -- Kiểm tra danh mục tồn tại
    IF NOT EXISTS (SELECT 1 FROM DanhMuc WHERE MaDanhMuc = p_MaDanhMuc) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Danh mục không tồn tại.';
    END IF;

    -- Kiểm tra thương hiệu tồn tại
    IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE MaThuongHieu = p_MaThuongHieu) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Thương hiệu không tồn tại.';
    END IF;

    -- Kiểm tra tên sản phẩm trùng trong shop
    IF EXISTS (SELECT 1 FROM SanPham WHERE MaShop = p_MaShop AND Ten = p_Ten) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Tên sản phẩm bị trùng trong shop.';
    END IF;

    -- Kiểm tra định dạng tên sản phẩm (chữ cái tiếng Việt + khoảng trắng)
    IF p_Ten NOT REGEXP '^[A-Za-zÀ-Ỵà-ỵĂăÂâĐđÊêÔôƠơƯư\\s]+$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Tên sản phẩm chỉ được chứa ký tự chữ cái tiếng Việt và khoảng trắng.';
    END IF;

    -- Kiểm tra số lượng
    IF p_SoLuong < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: SoLuong phải >= 0.';
    END IF;

    -- Kiểm tra giá bán
    IF p_GiaBan <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: GiaBan phải > 0.';
    END IF;

    -- Lấy mã sản phẩm kế tiếp trong shop
    SELECT COALESCE(MAX(MaSanPham), 0) + 1 INTO v_MaxMaSanPham
    FROM SanPham
    WHERE MaShop = p_MaShop;

    -- Thêm sản phẩm
    INSERT INTO SanPham (MaShop, MaSanPham, Ten, AnhUrl, SoLuong, GiaBan)
    VALUES (p_MaShop, v_MaxMaSanPham, p_Ten, p_AnhUrl, p_SoLuong, p_GiaBan);

    -- Thêm vào bảng mapping
    INSERT INTO SanPhamThuocVao (MaShop, MaSanPham, MaThuongHieu, MaDanhMuc)
    VALUES (p_MaShop, v_MaxMaSanPham, p_MaThuongHieu, p_MaDanhMuc);
END$$


DELIMITER ;
