-- Không cho phép thêm sản phẩm vào giỏ với số lượng > tồn kho
DELIMITER $$
DROP TRIGGER IF EXISTS trg_gpcs_check_stock$$
CREATE TRIGGER trg_gpcs_check_stock
BEFORE INSERT ON GioPhuChuaSanPham
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;
    SELECT SoLuong INTO v_stock
    FROM SanPham
    WHERE MaSanPham = NEW.MaSanPham AND MaShop = NEW.MaShop;

    IF v_stock IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Sản phẩm không tồn tại hoặc đã bị xóa.';
    END IF;

    IF NEW.SoLuong > v_stock THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Số lượng vượt quá tồn kho.';
    END IF;
END$$
DELIMITER ;

-- Voucher chỉ được áp dụng khi còn tồn kho
DELIMITER $$
DROP TRIGGER IF EXISTS trg_apdungvoucher_check_stock$$
CREATE TRIGGER trg_apdungvoucher_check_stock
BEFORE INSERT ON ApDungVoucher
FOR EACH ROW
BEGIN
    DECLARE v_qty INT;

    SELECT SoLuongTonKho INTO v_qty
    FROM Voucher
    WHERE MaVoucher = NEW.MaVoucher
    FOR UPDATE;

    IF v_qty IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Voucher không tồn tại.';
    END IF;

    IF v_qty <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lỗi: Voucher đã hết tồn kho.';
    END IF;

    UPDATE Voucher
    SET SoLuongTonKho = SoLuongTonKho - 1
    WHERE MaVoucher = NEW.MaVoucher;
END$$
DELIMITER ;
