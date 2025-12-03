-- Thủ tục 1: Liệt kê sản phẩm theo shop & danh mục
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_LietKeSanPhamTheoShopDanhMuc$$
CREATE PROCEDURE sp_LietKeSanPhamTheoShopDanhMuc(
    IN p_MaShop INT,
    IN p_MaDanhMuc INT
)
BEGIN
    SELECT
        s.MaShop,
        s.Ten AS TenShop,
        dm.MaDanhMuc,
        dm.TenDanhMuc,
        sp.MaSanPham,
        sp.Ten AS TenSanPham,
        sp.SoLuong,
        sp.GiaBan,
        sp.DaXoa
    FROM SanPham sp
    JOIN SanPhamThuocVao stv ON stv.MaSanPham = sp.MaSanPham AND stv.MaShop = sp.MaShop
    JOIN DanhMuc dm ON dm.MaDanhMuc = stv.MaDanhMuc
    JOIN Shop s ON s.MaShop = sp.MaShop
    WHERE sp.MaShop = p_MaShop
      AND dm.MaDanhMuc = p_MaDanhMuc
      AND sp.DaXoa = 0
    ORDER BY sp.Ten ASC, sp.MaSanPham ASC;
END$$
DELIMITER ;

-- Thủ tục 2: Thống kê tổng số lượng tồn theo danh mục trong 1 shop
-- Thỏa: JOIN SanPham + SanPhamThuocVao + DanhMuc, có SUM, COUNT, GROUP BY, HAVING, WHERE, ORDER BY
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_ThongKeTonTheoDanhMuc$$
CREATE PROCEDURE sp_ThongKeTonTheoDanhMuc(
    IN p_MaShop INT,
    IN p_MinTotal INT
)
BEGIN
    SELECT
        dm.MaDanhMuc,
        dm.TenDanhMuc,
        COUNT(*) AS SoSanPham,
        SUM(sp.SoLuong) AS TongSoLuong
    FROM SanPham sp
    JOIN SanPhamThuocVao stv ON stv.MaSanPham = sp.MaSanPham AND stv.MaShop = sp.MaShop
    JOIN DanhMuc dm ON dm.MaDanhMuc = stv.MaDanhMuc
    WHERE sp.MaShop = p_MaShop
      AND sp.DaXoa = 0
    GROUP BY dm.MaDanhMuc, dm.TenDanhMuc
    HAVING SUM(sp.SoLuong) >= p_MinTotal
    ORDER BY TongSoLuong DESC, dm.TenDanhMuc ASC;
END$$
DELIMITER ;
