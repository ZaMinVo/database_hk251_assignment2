-- Test thao tác để kích hoạt trigger

-- 1) Thử thêm sản phẩm vượt tồn kho (kỳ vọng trigger chặn, nhưng không bắt lỗi ở đây)
START TRANSACTION;
SAVEPOINT sp_over_stock;
SELECT SoLuong FROM SanPham WHERE MaSanPham = 1 AND MaShop = 6;
INSERT INTO GioPhuChuaSanPham (MaGioHang, MaGioPhu, MaSanPham, MaShop, SoLuong)
VALUES (6, 1, 1, 6, 100);
SELECT SoLuong FROM SanPham WHERE MaSanPham = 1 AND MaShop = 6;
ROLLBACK TO SAVEPOINT sp_over_stock;
COMMIT;

-- 2) Thêm sản phẩm với số lượng hợp lệ
START TRANSACTION;
SAVEPOINT sp_valid_stock;
SELECT SoLuong FROM SanPham WHERE MaSanPham = 1 AND MaShop = 6;
INSERT INTO GioPhuChuaSanPham (MaGioHang, MaGioPhu, MaSanPham, MaShop, SoLuong)
VALUES (6, 1, 1, 6, 2);
SELECT SoLuong FROM SanPham WHERE MaSanPham = 1 AND MaShop = 6;
ROLLBACK TO SAVEPOINT sp_valid_stock;
COMMIT;

-- 3) Áp dụng voucher còn tồn kho (voucher 11) - tồn kho sẽ giảm trong transaction
START TRANSACTION;
SAVEPOINT sp_voucher_ok;
SELECT SoLuongTonKho FROM Voucher WHERE MaVoucher = 11;
INSERT INTO ApDungVoucher (MaDonHang, MaVoucher) VALUES (22, 11);
SELECT SoLuongTonKho FROM Voucher WHERE MaVoucher = 11;
ROLLBACK TO SAVEPOINT sp_voucher_ok;
COMMIT;

-- 4) Đặt voucher về 0 và áp dụng (kỳ vọng trigger chặn)
START TRANSACTION;
SAVEPOINT sp_voucher_out;
UPDATE Voucher SET SoLuongTonKho = 0 WHERE MaVoucher = 12;
INSERT INTO ApDungVoucher (MaDonHang, MaVoucher) VALUES (24, 12);
ROLLBACK TO SAVEPOINT sp_voucher_out;
COMMIT;
