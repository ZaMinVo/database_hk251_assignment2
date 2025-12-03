-- Demo thao tác cho trigger2_4 (các cột dẫn xuất)
-- Chạy sau khi đã load create_table.sql, insert_data.sql, trigger2_4.sql
-- Dùng TRANSACTION + ROLLBACK để không làm bẩn dữ liệu.

-- 1) Tính lại điểm trung bình Shop khi thêm đánh giá mới
START TRANSACTION;
SELECT DanhGiaTB FROM Shop WHERE MaShop = 6;
INSERT INTO DanhGia (CCCD, MaSanPham, MaShop, Diem, NoiDung, Ngay, Thang, Nam)
VALUES ('666666666667', 1, 6, 5, 'Test rating trigger', 1, 1, 2026);
SELECT DanhGiaTB FROM Shop WHERE MaShop = 6;
ROLLBACK;

-- 2) Tính lại TongGia của GioPhu và DonHang khi thêm chi tiết giỏ
START TRANSACTION;
SELECT TongGia FROM GioPhu WHERE MaGioHang = 6 AND MaGioPhu = 1;
SELECT TongGia FROM DonHang WHERE MaDonHang = 23;

SELECT * FROM GioPhuChuaSanPham WHERE MaGioHang = 6 AND MaGioPhu = 1;
INSERT INTO GioPhuChuaSanPham (MaGioHang, MaGioPhu, MaSanPham, MaShop, SoLuong)
VALUES (6, 1, 2, 2, 3); -- thêm sản phẩm mới vào giỏ phụ
SELECT TongGia FROM GioPhu WHERE MaGioHang = 6 AND MaGioPhu = 1;
SELECT TongGia FROM DonHang WHERE MaDonHang = 23;
SELECT * FROM GioPhuChuaSanPham WHERE MaGioHang = 6 AND MaGioPhu = 1;
ROLLBACK;

-- 3) Tính lại TongGia DonHang khi đổi phí vận chuyển
START TRANSACTION;
SELECT GiaVanChuyen, TongGia FROM DonHang WHERE MaDonHang = 23;
UPDATE DonHang SET GiaVanChuyen = GiaVanChuyen + 5000 WHERE MaDonHang = 23;
SELECT GiaVanChuyen, TongGia FROM DonHang WHERE MaDonHang = 23;
ROLLBACK;

-- 4) Tính ThanhGia tại ApDungVoucher (áp dụng voucher 11 cho đơn 23)
START TRANSACTION;
SELECT SoLuongTonKho FROM Voucher WHERE MaVoucher = 11;
SELECT TongGia FROM DonHang WHERE MaDonHang = 23;
INSERT INTO ApDungVoucher (MaDonHang, MaVoucher) VALUES (23, 11);
SELECT ThanhGia FROM ApDungVoucher WHERE MaDonHang = 23 AND MaVoucher = 11;
SELECT SoLuongTonKho FROM Voucher WHERE MaVoucher = 11;
ROLLBACK;
