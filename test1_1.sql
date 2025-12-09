-- Kiểm tra tuổi người dùng khi đăng ký (phải >= 14 tuổi)
START TRANSACTION;
SAVEPOINT sp_check_age;

INSERT INTO NguoiDung 
(CCCD, Ten, NgaySinh, ThangSinh, NamSinh, SoDienThoaiXacMinh, TaiKhoan, MatKhau, IsSeller, IsBuyer)
VALUES 
('000000000001', 'Nguyen Van A', 1, 1, 2015, '0912345678', 'testage', 'pass', 0, 1);

ROLLBACK TO SAVEPOINT sp_check_age;
COMMIT;



-- Kiểm tra tên người dùng khi đăng ký (chỉ chứa chữ cái tiếng Việt và khoảng trắng)
START TRANSACTION;
SAVEPOINT sp_check_name;

INSERT INTO NguoiDung 
(CCCD, Ten, NgaySinh, ThangSinh, NamSinh, SoDienThoaiXacMinh, TaiKhoan, MatKhau)
VALUES 
('000000000002', 'Tên@@Sai', 1, 1, 2000, '0912345679', 'accname', 'pass');

ROLLBACK TO SAVEPOINT sp_check_name;
COMMIT;



-- Kiểm tra số lượng sản phẩm âm khi thêm sản phẩm
START TRANSACTION;
SAVEPOINT sp_check_soluong;

INSERT INTO SanPham (MaShop, MaSanPham, Ten, AnhUrl, SoLuong, GiaBan)
VALUES (1, 999, 'SanPham Test', NULL, -5, 10000);

ROLLBACK TO SAVEPOINT sp_check_soluong;
COMMIT;



-- Kiểm tra đánh giá sản phẩm khi chưa mua sản phẩm
START TRANSACTION;
SAVEPOINT sp_check_review;

INSERT INTO DanhGia (CCCD, MaSanPham, MaShop, Diem, NoiDung, Ngay, Thang, Nam)
VALUES ('123456789012', 1, 1, 5, 'Good', 1, 1, 2024);

ROLLBACK TO SAVEPOINT sp_check_review;
COMMIT;



-- Kiểm tra không cho người dùng follow chính mình
START TRANSACTION;
SAVEPOINT sp_check_follow_self;

INSERT INTO TheoDoi (FollowerCCCD, FollowedCCCD)
VALUES ('123456789012', '123456789012');

ROLLBACK TO SAVEPOINT sp_check_follow_self;
COMMIT;



-- Kiểm tra trạng thái đơn hàng hợp lệ khi cập nhật (theo tuần tự)
DELETE FROM DonHang WHERE MaDonHang = 1;
INSERT INTO DonHang (MaDonHang, MaGioHang, MaGioPhu, CCCD, TrangThaiDonHang)
VALUES (1, 1, 1, '123456789012', 'Đơn hàng đã đặt');

START TRANSACTION;
SAVEPOINT sp_order_state;

UPDATE DonHang
SET TrangThaiDonHang = 'Đã nhận được hàng'
WHERE MaDonHang = 1;

ROLLBACK TO SAVEPOINT sp_order_state;
COMMIT;



-- Kiểm tra tự động ghi ngày giao hàng khi trạng thái đơn hàng chuyển sang "Đã nhận được hàng"

START TRANSACTION;
SAVEPOINT sp_set_date;

DELETE FROM DonHang WHERE MaDonHang = 1;
INSERT INTO DonHang (MaDonHang, GiaVanChuyen, MaGioHang, MaGioPhu, CCCD, TrangThaiDonHang)
VALUES (1, 15000, 10, 1, '101010101010', 'Đã giao cho đơn vị vận chuyển');


UPDATE DonHang
SET TrangThaiDonHang = 'Đã nhận được hàng'
WHERE MaDonHang = 1;

SELECT NgayGiao, ThangGiao, NamGiao FROM DonHang WHERE MaDonHang = 1;

ROLLBACK TO SAVEPOINT sp_set_date;
COMMIT;



-- Kiểm tra chỉ cho đổi trả hàng trong vòng 7 ngày kể từ ngày giao hàng & phải giao hàng rồi mới được đổi trả

START TRANSACTION;
SAVEPOINT sp_return_7days;

DELETE FROM DonHang WHERE MaDonHang = 1;
INSERT INTO DonHang (MaDonHang, GiaVanChuyen, MaGioHang, MaGioPhu, CCCD, TrangThaiDonHang, NgayGiao, ThangGiao, NamGiao)
VALUES (1, 15000, 10, 1, '101010101010', 'Đã nhận được hàng', 1, 1, 2024);

INSERT INTO YeuCauDoiTra (CCCD, MaDonHang, LyDoDoiTra, Ngay, Thang, Nam)
VALUES ('101010101010', 1, 'Lý do test', 1, 1, 2026); -- quá xa ngày giao

ROLLBACK TO SAVEPOINT sp_return_7days;
COMMIT;



-- Kiểm tra cập nhật cấp độ mua hàng khi đơn hàng thay đổi trạng thái thành "Đã nhận được hàng"
START TRANSACTION;
SAVEPOINT sp_capdo;

DELETE FROM DonHang WHERE MaDonHang = 33;
DELETE FROM GioPhu WHERE MaGioHang = 10 AND MaGioPhu = 3;
DELETE FROM GioPhuChuaSanPham WHERE MaGioHang = 10 AND MaGioPhu = 3;

INSERT INTO DonHang (MaDonHang, GiaVanChuyen, TrangThaiDonHang, MaDonViVanChuyen, CCCD, MaHoSo, MaGioHang, MaGioPhu) VALUES
(33, 33000, 'Đã giao cho đơn vị vận chuyển', 'GHTK', '101010101010', 2, 10, 3);

INSERT INTO GioPhu (MaGioHang, MaGioPhu) VALUES
(10, 3);

INSERT INTO GioPhuChuaSanPham (MaGioHang, MaGioPhu, MaSanPham, MaShop, SoLuong) VALUES
(10, 3, 1, 10, 10);

-- LẤY GIÁ TRỊ TRƯỚC UPDATE
SET @CapDo_Truoc = (
    SELECT ND.CapDoMuaHang
    FROM NguoiDung ND
    WHERE ND.CCCD = (SELECT CCCD FROM DonHang WHERE MaDonHang = 33)
);

-- UPDATE TRẠNG THÁI
UPDATE DonHang
SET TrangThaiDonHang = 'Đã nhận được hàng'
WHERE MaDonHang = 33;

-- LẤY GIÁ TRỊ SAU UPDATE
SET @CapDo_Sau = (
    SELECT ND.CapDoMuaHang
    FROM NguoiDung ND
    WHERE ND.CCCD = (SELECT CCCD FROM DonHang WHERE MaDonHang = 33)
);

SET @TongGia = (
	SELECT TongGia 
    FROM DonHang
    WHERE MaDonHang = 33
);

-- TRẢ VỀ 1 BẢNG DUY NHẤT
SELECT 
    @CapDo_Truoc AS CapDo_TruocUpdate,
    @TongGia AS TongGia,
    @CapDo_Sau AS CapDo_SauUpdate;

ROLLBACK TO SAVEPOINT sp_capdo;
COMMIT;




