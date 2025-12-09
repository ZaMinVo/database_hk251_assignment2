-- Kiểm tra thêm sản phẩm mới thành công
START TRANSACTION;
SAVEPOINT sp_add_ok;

CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamTest',       -- Ten
    'img.jpg',           -- AnhUrl
    50,                  -- SoLuong
    200000,              -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);

-- Kiểm tra sản phẩm vừa thêm
SELECT *
FROM SanPham;

ROLLBACK TO SAVEPOINT sp_add_ok;
COMMIT;



-- Kiểm tra thêm sản phẩm với tên trùng trong shop
START TRANSACTION;
SAVEPOINT sp_add_duplicate_name;

CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamTest',       -- Ten
    'img.jpg',           -- AnhUrl
    50,                  -- SoLuong
    200000,              -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);

CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamTest',       -- Ten
    'img2.jpg',          -- AnhUrl
    30,                  -- SoLuong
    150000,              -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);

ROLLBACK TO SAVEPOINT sp_add_duplicate_name;
COMMIT;



-- Kiểm tra thêm sản phẩm với số lượng âm
START TRANSACTION;
SAVEPOINT sp_add_negative_quantity;
CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamAm',        -- Ten
    'img3.jpg',         -- AnhUrl
    -10,                 -- SoLuong
    100000,             -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);
ROLLBACK TO SAVEPOINT sp_add_negative_quantity;
COMMIT;


-- Kiểm tra thêm sản phẩm với giá bán <= 0
START TRANSACTION;
SAVEPOINT sp_add_zero_price;
CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamGiaKhong',       -- Ten
    'img4.jpg',          -- AnhUrl
    20,                  -- SoLuong
    0,                   -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);
ROLLBACK TO SAVEPOINT sp_add_zero_price;
COMMIT;



-- Kiểm tra thêm sản phẩm với tên chứa ký tự không hợp lệ
START TRANSACTION;
SAVEPOINT sp_add_invalid_name;
CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPham@123',      -- Ten
    'img5.jpg',         -- AnhUrl
    15,                 -- SoLuong
    120000,             -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);
ROLLBACK TO SAVEPOINT sp_add_invalid_name;
COMMIT;



-- Kiểm tra thêm sản phẩm với shop không tồn tại
START TRANSACTION;
SAVEPOINT sp_add_nonexistent_shop;
CALL sp_ThemSanPham(
    999,                 -- MaShop
    'SanPhamKhongTonTai', -- Ten
    'img6.jpg',          -- AnhUrl
    10,                  -- SoLuong
    130000,              -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);
ROLLBACK TO SAVEPOINT sp_add_nonexistent_shop;
COMMIT;



-- Kiểm tra thêm sản phẩm với thương hiệu không tồn tại
START TRANSACTION;
SAVEPOINT sp_add_nonexistent_category;
CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamKhongTonTaiDM', -- Ten
    'img7.jpg',          -- AnhUrl
    10,                  -- SoLuong
    130000,              -- GiaBan
    1,                   -- MaDanhMuc
    999                  -- MaThuongHieu
);
ROLLBACK TO SAVEPOINT sp_add_nonexistent_category;
COMMIT;



-- Kiểm tra thêm sản phẩm với danh mục không tồn tại
START TRANSACTION;
SAVEPOINT sp_add_nonexistent_brand;
CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamKhongTonTaiTH', -- Ten
    'img8.jpg',          -- AnhUrl
    10,                  -- SoLuong
    130000,              -- GiaBan
    999,                 -- MaDanhMuc
    2                    -- MaThuongHieu
);
ROLLBACK TO SAVEPOINT sp_add_nonexistent_brand;
COMMIT;



-- Kiểm tra sửa sản phẩm thành công
START TRANSACTION;
SAVEPOINT sp_update_ok;

CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamTest',       -- Ten
    'img.jpg',           -- AnhUrl
    50,                  -- SoLuong
    200000,              -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);

CALL sp_SuaSanPham(
    10,                  -- MaShop
    3,                   -- MaSanPham
    'SanPhamDaCapNhat', -- Ten
    'img_updated.jpg',   -- AnhUrl
    100,                 -- SoLuong
    250000,               -- GiaBan,
    NULL,                 -- MaDanhMuc
    NULL                  -- MaThuongHieu
);

SELECT * FROM SanPham;

ROLLBACK TO SAVEPOINT sp_update_ok;
COMMIT;



-- Kiểm tra xóa san phẩm không thuộc đơn hàng nào (hard delete)
START TRANSACTION;
SAVEPOINT sp_delete_hard;
CALL sp_ThemSanPham(
    10,                  -- MaShop
    'SanPhamCanXoa',    -- Ten
    'img_delete.jpg',    -- AnhUrl
    20,                  -- SoLuong
    150000,              -- GiaBan
    1,                   -- MaDanhMuc
    2                    -- MaThuongHieu
);

CALL sp_XoaSanPham(
    10,                  -- MaShop
    4                    -- MaSanPham
);

-- Kiểm tra sản phẩm đã bị xóa chưa
SELECT * FROM SanPham WHERE MaShop = 10 AND MaSanPham = 4;
ROLLBACK TO SAVEPOINT sp_delete_hard;
COMMIT;




-- Kiểm tra xóa sản phẩm thuộc đơn hàng (soft delete)
START TRANSACTION;
SAVEPOINT sp_delete_soft;

DELETE FROM DonHang WHERE MaDonHang = 33;
DELETE FROM GioPhu WHERE MaGioHang = 10 AND MaGioPhu = 3;
DELETE FROM GioPhuChuaSanPham WHERE MaGioHang = 10 AND MaGioPhu = 3;

INSERT INTO DonHang (MaDonHang, GiaVanChuyen, TrangThaiDonHang, MaDonViVanChuyen, CCCD, MaHoSo, MaGioHang, MaGioPhu) VALUES
(33, 33000, 'Đã giao cho đơn vị vận chuyển', 'GHTK', '101010101010', 2, 10, 3);

INSERT INTO GioPhu (MaGioHang, MaGioPhu) VALUES
(10, 3);

INSERT INTO GioPhuChuaSanPham (MaGioHang, MaGioPhu, MaSanPham, MaShop, SoLuong) VALUES
(10, 3, 1, 10, 10);

CALL sp_XoaSanPham(
    10,                  -- MaShop
    1                    -- MaSanPham
);

-- Kiểm tra sản phẩm đã bị soft delete
SELECT * FROM SanPham WHERE MaShop = 10 AND MaSanPham = 1;
ROLLBACK TO SAVEPOINT sp_delete_soft;
COMMIT;