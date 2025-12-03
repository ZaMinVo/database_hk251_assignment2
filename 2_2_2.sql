-- Tính các thuộc tính dẫn xuất:
-- 1) Điểm đánh giá trung bình của Shop (Shop.DanhGiaTB)
-- 2) Tổng giá của GioPhu (GioPhu.TongGia)
-- 3) Tổng giá của DonHang (DonHang.TongGia = SUM TongGia GioPhu + GiaVanChuyen)
-- 4) Thành giá tại ApDungVoucher (ApDungVoucher.ThanhGia = DonHang.TongGia - GiaTri voucher, không âm)

SET NAMES utf8mb4;

-- Bổ sung cột dẫn xuất (chạy một lần; nếu cột đã tồn tại hãy bỏ qua/ comment dòng)
ALTER TABLE Shop ADD COLUMN DanhGiaTB DECIMAL(4,2) DEFAULT NULL;
ALTER TABLE GioPhu ADD COLUMN TongGia INT DEFAULT 0;
ALTER TABLE DonHang ADD COLUMN TongGia INT DEFAULT 0;
ALTER TABLE ApDungVoucher ADD COLUMN ThanhGia INT DEFAULT NULL;

-- Helper: cập nhật tổng giá GioPhu và DonHang
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_giophu_tonggia$$
CREATE PROCEDURE sp_update_giophu_tonggia(IN p_MaGioHang INT, IN p_MaGioPhu INT)
BEGIN
    DECLARE v_MaDonHang INT;

    UPDATE GioPhu gp
    SET TongGia = COALESCE((
        SELECT SUM(gpcs.SoLuong * sp.GiaBan)
        FROM GioPhuChuaSanPham gpcs
        JOIN SanPham sp ON sp.MaSanPham = gpcs.MaSanPham AND sp.MaShop = gpcs.MaShop
        WHERE gpcs.MaGioHang = p_MaGioHang AND gpcs.MaGioPhu = p_MaGioPhu
    ), 0)
    WHERE gp.MaGioHang = p_MaGioHang AND gp.MaGioPhu = p_MaGioPhu;

    SELECT MaDonHang INTO v_MaDonHang
    FROM GioPhu
    WHERE MaGioHang = p_MaGioHang AND MaGioPhu = p_MaGioPhu
    LIMIT 1;

    IF v_MaDonHang IS NOT NULL THEN
        UPDATE DonHang dh
        SET TongGia = COALESCE((
            SELECT SUM(gp2.TongGia) FROM GioPhu gp2 WHERE gp2.MaDonHang = v_MaDonHang
        ), 0) + COALESCE(dh.GiaVanChuyen, 0)
        WHERE dh.MaDonHang = v_MaDonHang;
    END IF;
END$$
DELIMITER ;

-- Helper: cập nhật điểm trung bình của shop
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_shop_rating$$
CREATE PROCEDURE sp_update_shop_rating(IN p_MaShop INT)
BEGIN
    UPDATE Shop s
    SET DanhGiaTB = (
        SELECT COALESCE(AVG(Diem), 0) FROM DanhGia d WHERE d.MaShop = p_MaShop
    )
    WHERE s.MaShop = p_MaShop;
END$$
DELIMITER ;

-- Trigger: cập nhật điểm trung bình Shop sau insert/update/delete DanhGia
DELIMITER $$
DROP TRIGGER IF EXISTS trg_danhgia_ai_shop_rating$$
CREATE TRIGGER trg_danhgia_ai_shop_rating
AFTER INSERT ON DanhGia
FOR EACH ROW
BEGIN
    CALL sp_update_shop_rating(NEW.MaShop);
END$$

DROP TRIGGER IF EXISTS trg_danhgia_au_shop_rating$$
CREATE TRIGGER trg_danhgia_au_shop_rating
AFTER UPDATE ON DanhGia
FOR EACH ROW
BEGIN
    CALL sp_update_shop_rating(NEW.MaShop);
END$$

DROP TRIGGER IF EXISTS trg_danhgia_ad_shop_rating$$
CREATE TRIGGER trg_danhgia_ad_shop_rating
AFTER DELETE ON DanhGia
FOR EACH ROW
BEGIN
    CALL sp_update_shop_rating(OLD.MaShop);
END$$
DELIMITER ;

-- Trigger: cập nhật tổng giá GioPhu/DonHang khi thay đổi giỏ phụ chứa sản phẩm
DELIMITER $$
DROP TRIGGER IF EXISTS trg_gpcs_ai_totals$$
CREATE TRIGGER trg_gpcs_ai_totals
AFTER INSERT ON GioPhuChuaSanPham
FOR EACH ROW
BEGIN
    CALL sp_update_giophu_tonggia(NEW.MaGioHang, NEW.MaGioPhu);
END$$

DROP TRIGGER IF EXISTS trg_gpcs_au_totals$$
CREATE TRIGGER trg_gpcs_au_totals
AFTER UPDATE ON GioPhuChuaSanPham
FOR EACH ROW
BEGIN
    CALL sp_update_giophu_tonggia(NEW.MaGioHang, NEW.MaGioPhu);
END$$

DROP TRIGGER IF EXISTS trg_gpcs_ad_totals$$
CREATE TRIGGER trg_gpcs_ad_totals
AFTER DELETE ON GioPhuChuaSanPham
FOR EACH ROW
BEGIN
    CALL sp_update_giophu_tonggia(OLD.MaGioHang, OLD.MaGioPhu);
END$$
DELIMITER ;

-- Trigger: nếu phí vận chuyển thay đổi -> cập nhật DonHang.TongGia
DELIMITER $$
DROP TRIGGER IF EXISTS trg_donhang_au_totals$$
CREATE TRIGGER trg_donhang_au_totals
AFTER UPDATE ON DonHang
FOR EACH ROW
BEGIN
    IF NOT (OLD.GiaVanChuyen <=> NEW.GiaVanChuyen) THEN
        UPDATE DonHang dh
        SET TongGia = COALESCE((
            SELECT SUM(gp.TongGia) FROM GioPhu gp WHERE gp.MaDonHang = NEW.MaDonHang
        ), 0) + COALESCE(NEW.GiaVanChuyen, 0)
        WHERE dh.MaDonHang = NEW.MaDonHang;
    END IF;
END$$
DELIMITER ;

-- Trigger: tính ThanhGia ngay trong BEFORE để tránh cập nhật lại bảng
DELIMITER $$
DROP TRIGGER IF EXISTS trg_apdungvoucher_bi_thanhgia$$
CREATE TRIGGER trg_apdungvoucher_bi_thanhgia
BEFORE INSERT ON ApDungVoucher
FOR EACH ROW
BEGIN
    DECLARE v_tonggia INT DEFAULT 0;
    DECLARE v_giatri INT DEFAULT 0;
    SELECT COALESCE(TongGia, 0) INTO v_tonggia FROM DonHang WHERE MaDonHang = NEW.MaDonHang;
    SELECT COALESCE(GiaTri, 0) INTO v_giatri FROM Voucher WHERE MaVoucher = NEW.MaVoucher;
    SET NEW.ThanhGia = GREATEST(0, v_tonggia - v_giatri);
END$$

DROP TRIGGER IF EXISTS trg_apdungvoucher_bu_thanhgia$$
CREATE TRIGGER trg_apdungvoucher_bu_thanhgia
BEFORE UPDATE ON ApDungVoucher
FOR EACH ROW
BEGIN
    DECLARE v_tonggia INT DEFAULT 0;
    DECLARE v_giatri INT DEFAULT 0;
    SELECT COALESCE(TongGia, 0) INTO v_tonggia FROM DonHang WHERE MaDonHang = NEW.MaDonHang;
    SELECT COALESCE(GiaTri, 0) INTO v_giatri FROM Voucher WHERE MaVoucher = NEW.MaVoucher;
    SET NEW.ThanhGia = GREATEST(0, v_tonggia - v_giatri);
END$$
DELIMITER ;
