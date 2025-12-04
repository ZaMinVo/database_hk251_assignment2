SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Dữ liệu người dùng / tài khoản (gộp flag người bán/người mua)
INSERT INTO NguoiDung (CCCD, Ten, NgaySinh, ThangSinh, NamSinh, SoDienThoaiXacMinh, TaiKhoan, MatKhau, IsSeller, IsBuyer, ThuNhap, TrangThai, CapDoMuaHang) VALUES
('012345678901', 'Nguyen Van A', 15, 6, 1990, '0901234567', 'nguyenvana', 'pass123', 1, 0, 20000000, 'active', NULL),
('123456789012', 'Tran Thi B', 22, 12, 1985, '0912345678', 'tranthib', 'pass456', 1, 0, 25000000, 'active', NULL),
('234567890123', 'Le Van C', 3, 3, 1992, '0923456789', 'levanc', 'pass789', 1, 0, 18000000, 'inactive', NULL),
('345678901234', 'Pham Thi D', 10, 8, 1988, '0934567890', 'phamthid', 'passabc', 1, 0, 22000000, 'active', NULL),
('456789012345', 'Hoang Van E', 30, 1, 1995, '0945678901', 'hoangvane', 'passxyz', 1, 0, 15000000, 'locked', NULL),
('567890123456', 'Nguyen Thi F', 5, 5, 1991, '0956789012', 'nguyenthif', 'pass111', 0, 1, NULL, 'active', 'Đồng'),
('678901234567', 'Tran Van G', 12, 7, 1987, '0967890123', 'tranvang', 'pass222', 0, 1, NULL, 'active', 'Bạc'),
('789012345678', 'Le Thi H', 18, 9, 1993, '0978901234', 'lethih', 'pass333', 0, 1, NULL, 'active', 'Vàng'),
('890123456789', 'Pham Van I', 25, 11, 1989, '0989012345', 'phamvani', 'pass444', 0, 1, NULL, 'active', 'Kim Cương'),
('901234567890', 'Hoang Thi J', 2, 2, 1994, '0990123456', 'hoangthij', 'pass555', 0, 1, NULL, 'active', 'Đồng'),
('111111111111', 'Pham Quang K', 7, 7, 1990, '0900000001', 'phamquangk', 'pass666', 1, 0, 18000000, 'active', NULL),
('222222222222', 'Do Thi L', 9, 8, 1991, '0900000002', 'dothil', 'pass777', 1, 0, 21000000, 'active', NULL),
('333333333333', 'Vu Van M', 12, 3, 1987, '0900000003', 'vuvanM', 'pass888', 1, 0, 16000000, 'inactive', NULL),
('444444444444', 'Ngo Thi N', 1, 9, 1993, '0900000004', 'ngothin', 'pass999', 1, 0, 19000000, 'active', NULL),
('555555555555', 'Le Hoang O', 28, 4, 1989, '0900000005', 'lehoango', 'pass000', 1, 0, 17000000, 'locked', NULL),
('666666666666', 'Tran Minh P', 6, 6, 1996, '0900000006', 'tranminhp', 'passp', 0, 1, NULL, 'active', 'Đồng'),
('777777777777', 'Nguyen Thi Q', 11, 2, 1997, '0900000007', 'nguyenthq', 'passq', 0, 1, NULL, 'active', 'Bạc'),
('888888888888', 'Ho Van R', 19, 10, 1992, '0900000008', 'hovanr', 'passr', 0, 1, NULL, 'active', 'Vàng'),
('999999999999', 'Pham Thi S', 23, 12, 1995, '0900000009', 'phamthis', 'passs', 0, 1, NULL, 'active', 'Kim Cương'),
('101010101010', 'Bui Van T', 30, 5, 1998, '0900000010', 'buivant', 'passt', 0, 1, NULL, 'active', 'Đồng');

-- Tài khoản ngân hàng
INSERT INTO NganHang (CCCD, MaNganHang, SoTaiKhoan) VALUES
('012345678901', 'VCB001', '01234567890101'),
('123456789012', 'ACB002', '12345678901201'),
('234567890123', 'BIDV003', '23456789012301'),
('345678901234', 'TCB004', '34567890123401'),
('456789012345', 'MB005', '45678901234501'),
('567890123456', 'VPB006', '56789012345601'),
('678901234567', 'HDB007', '67890123456701'),
('789012345678', 'SCB008', '78901234567801'),
('890123456789', 'SHB009', '89012345678901'),
('901234567890', 'OCB010', '90123456789001');

-- Ngân hàng cho người dùng mới
INSERT INTO NganHang (CCCD, MaNganHang, SoTaiKhoan) VALUES
('111111111111', 'VPB011', '11111111111101'),
('222222222222', 'TPB012', '22222222222201'),
('333333333333', 'MSB013', '33333333333301'),
('444444444444', 'VIB014', '44444444444401'),
('555555555555', 'SHB015', '55555555555501'),
('666666666666', 'VCB016', '66666666666601'),
('777777777777', 'ACB017', '77777777777701'),
('888888888888', 'BIDV018', '88888888888801'),
('999999999999', 'TCB019', '99999999999901'),
('101010101010', 'MB020', '10101010101001');

-- Shop
INSERT INTO Shop (MaShop, CCCD, Ten, DiaChi, Ngay, Thang, Nam) VALUES
(1, '012345678901', 'Shop A', '123 Nguyễn Huệ, Quận 1, TP.HCM', 1, 1, 2020),
(2, '123456789012', 'Shop B', '456 Lê Lai, Quận 1, TP.HCM', 5, 3, 2021),
(3, '234567890123', 'Shop C', '789 Nguyễn Trãi, Quận 5, TP.HCM', 10, 5, 2022),
(4, '345678901234', 'Shop D', '321 Trần Hưng Đạo, Quận 1, TP.HCM', 15, 7, 2020),
(5, '456789012345', 'Shop E', '654 Phạm Ngũ Lão, Quận 1, TP.HCM', 20, 9, 2021);

INSERT INTO Shop (MaShop, CCCD, Ten, DiaChi, Ngay, Thang, Nam) VALUES
(6, '111111111111', 'Shop F', '12 Hai Ba Trung, Quận 1, TP.HCM', 5, 2, 2022),
(7, '222222222222', 'Shop G', '34 Cach Mang, Quận 3, TP.HCM', 12, 6, 2023),
(8, '333333333333', 'Shop H', '56 Dien Bien Phu, Quận 3, TP.HCM', 18, 9, 2023),
(9, '444444444444', 'Shop I', '78 Ly Thuong Kiet, Quận 10, TP.HCM', 25, 10, 2024),
(10, '555555555555', 'Shop J', '90 Nguyen Van Linh, Quận 7, TP.HCM', 30, 11, 2024);

-- Thương hiệu / danh mục
INSERT INTO ThuongHieu (MaThuongHieu, TenThuongHieu) VALUES
(1, 'Nike'),
(2, 'Adidas'),
(3, 'Puma'),
(4, 'Converse'),
(5, 'New Balance'),
(6, 'Reebok'),
(7, 'Fila'),
(8, 'Asics'),
(9, 'Under Armour'),
(10, 'Pandora');

INSERT INTO DanhMuc (MaDanhMuc, TenDanhMuc) VALUES
(1, 'Thời trang nam'),
(2, 'Thời trang nữ'),
(3, 'Giày dép'),
(4, 'Túi xách'),
(5, 'Phụ kiện'),
(6, 'Thể thao'),
(7, 'Đồ lót'),
(8, 'Đồ ngủ'),
(9, 'Đồ bơi'),
(10, 'Trang sức');

-- Sản phẩm
INSERT INTO SanPham (MaShop, MaSanPham, Ten, SoLuong, GiaBan, DaXoa) VALUES
(1, 1, 'Áo Thun Nam', 50, 200000, 0),
(2, 1, 'Đầm Nữ', 40, 450000, 0),
(3, 1, 'Áo Polo Nam', 45, 250000, 0),
(4, 1, 'Áo Len Nữ', 35, 400000, 0),
(5, 1, 'Giày Thể Thao Unisex', 45, 700000, 0),
(1, 2, 'Quần Jeans Nam', 30, 350000, 0),
(2, 2, 'Giày Nữ', 25, 500000, 0),
(3, 2, 'Quần Short Nam', 50, 200000, 0),
(4, 2, 'Chân Váy Nữ', 30, 300000, 0),
(5, 2, 'Mũ Lưỡi Trai', 50, 150000, 0),
(1, 3, 'Áo Sơ Mi Nam', 40, 300000, 0),
(2, 3, 'Túi Xách Nữ', 30, 600000, 0),
(3, 3, 'Giày Thể Thao Nam', 40, 400000, 0),
(4, 3, 'Giày Cao Gót', 25, 550000, 0),
(5, 3, 'Áo Hoodie', 40, 300000, 0),
(1, 4, 'Giày Nam', 25, 500000, 0),
(2, 4, 'Áo Khoác Nữ', 35, 550000, 0),
(3, 4, 'Ví Nam', 30, 350000, 0),
(4, 4, 'Túi Xách Nữ', 20, 500000, 0),
(5, 4, 'Quần Jogger', 35, 250000, 0),
(1, 5, 'Mũ Nam', 60, 150000, 0),
(2, 5, 'Váy Dài', 20, 650000, 0),
(3, 5, 'Nón Nam', 60, 150000, 0),
(4, 5, 'Khăn Choàng', 50, 200000, 0),
(5, 5, 'Balo', 30, 400000, 0),
(1, 6, 'TEST', 100, 100000, 0);

-- Sản phẩm mới cho các shop 6-10
INSERT INTO SanPham (MaShop, MaSanPham, Ten, SoLuong, GiaBan, DaXoa) VALUES
(6, 1, 'Áo Thể Thao Nam', 40, 280000, 0),
(6, 2, 'Quần Thể Thao Nam', 35, 320000, 0),
(7, 1, 'Giày Chạy Bộ Nữ', 30, 650000, 0),
(7, 2, 'Áo Khoác Thể Thao Nữ', 25, 550000, 0),
(8, 1, 'Bộ Đồ Ngủ Lụa', 28, 420000, 0),
(8, 2, 'Bikini Biển', 32, 380000, 0),
(9, 1, 'Áo Bra Thể Thao', 45, 250000, 0),
(9, 2, 'Quần Leggings', 50, 300000, 0),
(10, 1, 'Vòng Tay Bạc', 20, 750000, 0),
(10, 2, 'Dây Chuyền Ngọc Trai', 18, 1250000, 0);

-- Mapping sản phẩm ↔ thương hiệu/danh mục
INSERT INTO SanPhamThuocVao (MaSanPham, MaShop, MaThuongHieu, MaDanhMuc) VALUES
(1, 1, 1, 1),
(2, 1, 1, 1),
(3, 1, 2, 1),
(4, 1, 3, 3),
(5, 1, 4, 5),
(6, 1, 1, 1),
(1, 2, 2, 2),
(2, 2, 2, 3),
(3, 2, 3, 4),
(4, 2, 4, 2),
(5, 2, 5, 2),
(1, 3, 1, 1),
(2, 3, 1, 1),
(3, 3, 2, 3),
(4, 3, 3, 3),
(5, 3, 4, 5),
(1, 4, 2, 2),
(2, 4, 2, 2),
(3, 4, 3, 3),
(4, 4, 4, 4),
(5, 4, 5, 5),
(1, 5, 1, 3),
(2, 5, 2, 5),
(3, 5, 3, 1),
(4, 5, 4, 1),
(5, 5, 5, 5);

-- Mapping sản phẩm ↔ thương hiệu/danh mục cho shop 6-10
INSERT INTO SanPhamThuocVao (MaSanPham, MaShop, MaThuongHieu, MaDanhMuc) VALUES
(1, 6, 6, 6),
(2, 6, 6, 6),
(1, 7, 7, 6),
(2, 7, 7, 6),
(1, 8, 8, 8),
(2, 8, 8, 9),
(1, 9, 9, 7),
(2, 9, 9, 6),
(1, 10, 10, 10),
(2, 10, 10, 10);

-- Hồ sơ liên lạc (địa chỉ nhận hàng)
INSERT INTO HoSoLienLac (CCCD, MaHoSo, Ten, SDT, DiaChi) VALUES
('567890123456', 1, 'Nguyen Thi F - Nhà', '0956789012', '123 Đường A, Quận 1, TP.HCM'),
('567890123456', 2, 'Nguyen Thi F - Cơ quan', '0956789012', '456 Đường B, Quận 3, TP.HCM'),
('678901234567', 1, 'Tran Van G - Nhà', '0967890123', '789 Đường C, Quận 5, TP.HCM'),
('678901234567', 2, 'Tran Van G - Cơ quan', '0967890123', '101 Đường D, Quận 7, TP.HCM'),
('789012345678', 1, 'Le Thi H - Nhà', '0978901234', '202 Đường E, Quận 10, TP.HCM'),
('789012345678', 2, 'Le Thi H - Cơ quan', '0978901234', '303 Đường F, Quận 4, TP.HCM'),
('890123456789', 1, 'Pham Van I - Nhà', '0989012345', '404 Đường G, Quận 2, TP.HCM'),
('890123456789', 2, 'Pham Van I - Cơ quan', '0989012345', '505 Đường H, Quận 6, TP.HCM'),
('901234567890', 1, 'Hoang Thi J - Nhà', '0990123456', '606 Đường I, Quận 9, TP.HCM'),
('901234567890', 2, 'Hoang Thi J - Cơ quan', '0990123456', '707 Đường K, Quận 12, TP.HCM');

-- Hồ sơ liên lạc cho người mua mới
INSERT INTO HoSoLienLac (CCCD, MaHoSo, Ten, SDT, DiaChi) VALUES
('666666666666', 1, 'Tran Minh P - Nhà', '0900000006', '12 Đường L, Quận 4, TP.HCM'),
('666666666666', 2, 'Tran Minh P - Cơ quan', '0900000006', '34 Đường M, Quận 5, TP.HCM'),
('777777777777', 1, 'Nguyen Thi Q - Nhà', '0900000007', '56 Đường N, Quận 6, TP.HCM'),
('777777777777', 2, 'Nguyen Thi Q - Cơ quan', '0900000007', '78 Đường O, Quận 7, TP.HCM'),
('888888888888', 1, 'Ho Van R - Nhà', '0900000008', '90 Đường P, Quận 8, TP.HCM'),
('888888888888', 2, 'Ho Van R - Cơ quan', '0900000008', '11 Đường Q, Quận 10, TP.HCM'),
('999999999999', 1, 'Pham Thi S - Nhà', '0900000009', '22 Đường R, Quận 11, TP.HCM'),
('999999999999', 2, 'Pham Thi S - Cơ quan', '0900000009', '33 Đường S, Quận 12, TP.HCM'),
('101010101010', 1, 'Bui Van T - Nhà', '0900000010', '44 Đường T, TP.Thủ Đức'),
('101010101010', 2, 'Bui Van T - Cơ quan', '0900000010', '55 Đường U, TP.Thủ Đức');

-- Giỏ hàng
INSERT INTO GioHang (MaGioHang, CCCD) VALUES
(1, '567890123456'),
(2, '678901234567'),
(3, '789012345678'),
(4, '890123456789'),
(5, '901234567890'),
(6, '666666666666'),
(7, '777777777777'),
(8, '888888888888'),
(9, '999999999999'),
(10, '101010101010');

-- Đơn hàng
INSERT INTO DonHang (MaDonHang, GiaVanChuyen, TrangThaiDonHang, MaDonViVanChuyen, CCCD, MaHoSo, MaGioHang, MaGioPhu) VALUES
(12, 30000, 'Đơn hàng đã đặt', 'GHN', '567890123456', 1, 1, 1),
(13, 35000, 'Đơn hàng đã thanh toán', 'GHTK', '567890123456', 2, 1, 2),
(14, 25000, 'Đơn hàng đã đặt', 'GHN', '678901234567', 1, 2, 1),
(15, 27000, 'Đơn hàng đã thanh toán', 'GHTK', '678901234567', 2, 2, 2),
(16, 29000, 'Đã giao cho đơn vị vận chuyển', 'VNPost', '678901234567', 1, 2, 3),
(17, 32000, 'Đơn hàng đã đặt', 'GHTK', '789012345678', 1, 3, 1),
(18, 31000, 'Đơn hàng đã thanh toán', 'GHN', '789012345678', 2, 3, 2),
(19, 30000, 'Đơn hàng đã đặt', 'VNPost', '890123456789', 1, 4, 1),
(20, 33000, 'Đơn hàng đã thanh toán', 'GHN', '890123456789', 2, 4, 2),
(21, 35000, 'Đơn hàng đã đặt', 'GHTK', '901234567890', 1, 5, 1),
(22, 36000, 'Đơn hàng đã thanh toán', 'GHN', '901234567890', 2, 5, 2),
(23, 28000, 'Đơn hàng đã đặt', 'GHN', '666666666666', 1, 6, 1),
(24, 30000, 'Đơn hàng đã thanh toán', 'GHTK', '666666666666', 2, 6, 2),
(25, 26000, 'Đơn hàng đã đặt', 'GHN', '777777777777', 1, 7, 1),
(26, 29000, 'Đã giao cho đơn vị vận chuyển', 'VNPost', '777777777777', 2, 7, 2),
(27, 25000, 'Đơn hàng đã đặt', 'GHN', '888888888888', 1, 8, 1),
(28, 31000, 'Đơn hàng đã thanh toán', 'GHTK', '888888888888', 2, 8, 2),
(29, 30000, 'Đơn hàng đã đặt', 'VNPost', '999999999999', 1, 9, 1),
(30, 32000, 'Đơn hàng đã thanh toán', 'GHN', '999999999999', 2, 9, 2),
(31, 27000, 'Đơn hàng đã đặt', 'GHN', '101010101010', 1, 10, 1),
(32, 33000, 'Đơn hàng đã thanh toán', 'GHTK', '101010101010', 2, 10, 2);

-- Giỏ phụ gắn đơn hàng
INSERT INTO GioPhu (MaGioHang, MaGioPhu, MaDonHang) VALUES
(1, 1, 12),
(1, 2, 13),
(2, 1, 14),
(2, 2, 15),
(2, 3, 16),
(3, 1, 17),
(3, 2, 18),
(4, 1, 19),
(4, 2, 20),
(5, 1, 21),
(5, 2, 22),
(6, 1, 23),
(6, 2, 24),
(7, 1, 25),
(7, 2, 26),
(8, 1, 27),
(8, 2, 28),
(9, 1, 29),
(9, 2, 30),
(10, 1, 31),
(10, 2, 32);

-- Chi tiết sản phẩm trong giỏ phụ
INSERT INTO GioPhuChuaSanPham (MaGioHang, MaGioPhu, MaSanPham, MaShop, SoLuong) VALUES
(1, 1, 1, 1, 2),
(1, 1, 3, 1, 1),
(1, 2, 2, 1, 1),
(1, 2, 5, 1, 2),
(2, 1, 1, 2, 1),
(2, 1, 4, 2, 1),
(2, 2, 2, 2, 2),
(2, 2, 3, 2, 1),
(2, 3, 5, 2, 1),
(3, 1, 1, 3, 1),
(3, 1, 3, 3, 1),
(3, 2, 2, 3, 2),
(3, 2, 5, 3, 1),
(4, 1, 1, 4, 1),
(4, 1, 2, 4, 1),
(4, 2, 3, 4, 1),
(4, 2, 4, 4, 1),
(5, 1, 1, 5, 1),
(5, 1, 2, 5, 1),
(5, 2, 3, 5, 1),
(5, 2, 4, 5, 1),
(6, 1, 1, 7, 1),
(6, 1, 2, 6, 1),
(6, 2, 1, 7, 1),
(6, 2, 2, 7, 1),
(7, 1, 1, 8, 1),
(7, 1, 2, 8, 1),
(7, 2, 2, 9, 1),
(8, 1, 1, 9, 1),
(8, 1, 2, 9, 1),
(8, 2, 1, 10, 1),
(9, 1, 2, 10, 2),
(9, 2, 2, 8, 2),
(10, 1, 1, 7, 1),
(10, 2, 1, 10, 1);

-- Voucher
INSERT INTO Voucher (MaVoucher, SoLuongTonKho, MoTa, GiaTri, KieuVoucher) VALUES
(6, 100, 'Giảm 50k cho đơn hàng từ 500k', 50000, 'hanghoa'),
(7, 50, 'Miễn phí vận chuyển cho đơn hàng từ 200k', 35000, 'vanchuyen'),
(8, 200, 'Giảm 10% tất cả sản phẩm', 10, 'hanghoa'),
(9, 150, 'Giảm 30k cho đơn hàng từ 300k', 30000, 'hanghoa'),
(10, 75, 'Miễn phí vận chuyển cho đơn hàng từ 100k', 35000, 'vanchuyen'),
(11, 120, 'Giảm 15% đơn thể thao', 15, 'hanghoa'),
(12, 80, 'Giảm 70k đơn từ 400k', 70000, 'hanghoa'),
(13, 60, 'Free ship nội thành', 30000, 'vanchuyen'),
(14, 90, 'Giảm 20% đồ ngủ', 20, 'hanghoa'),
(15, 50, 'Giảm 100k trang sức', 100000, 'hanghoa');

-- Áp dụng voucher cho đơn hàng
INSERT INTO ApDungVoucher (MaDonHang, MaVoucher) VALUES
(12, 6),
(15, 7),
(17, 8),
(20, 9),
(22, 10),
(23, 11),
(24, 12),
(25, 13),
(27, 14),
(30, 15);

-- Thanh toán
INSERT INTO ThanhToan (MaThanhToan, PhuongThucThanhToan, MoTa, MaDonHang, Ngay, Gio, Thang, Nam) VALUES
(1, 'Tiền mặt', 'Thanh toán tại nhà', 12, 20, 14, 11, 2025),
(2, 'Ví điện tử', 'Thanh toán qua MoMo', 13, 20, 15, 11, 2025),
(3, 'Thẻ ngân hàng', 'Thanh toán qua thẻ ATM', 14, 21, 10, 11, 2025),
(4, 'Ví điện tử', 'Thanh toán qua ZaloPay', 15, 22, 11, 11, 2025),
(5, 'Tiền mặt', 'Thanh toán tại cửa hàng', 16, 22, 12, 11, 2025),
(6, 'Tiền mặt', 'Thanh toán tại nhà', 17, 23, 14, 11, 2025),
(7, 'Ví điện tử', 'Thanh toán qua MoMo', 18, 23, 15, 11, 2025),
(8, 'Thẻ ngân hàng', 'Thanh toán qua thẻ ATM', 19, 24, 10, 11, 2025),
(9, 'Tiền mặt', 'Thanh toán tại cửa hàng', 20, 24, 11, 11, 2025),
(10, 'Ví điện tử', 'Thanh toán qua ZaloPay', 21, 25, 14, 11, 2025),
(11, 'Tiền mặt', 'Thanh toán tại nhà', 22, 25, 15, 11, 2025),
(12, 'Ví điện tử', 'Thanh toán MoMo', 23, 26, 13, 11, 2025),
(13, 'Thẻ ngân hàng', 'Thanh toán qua thẻ', 24, 26, 14, 11, 2025),
(14, 'Tiền mặt', 'Thanh toán khi nhận', 25, 27, 10, 11, 2025),
(15, 'Ví điện tử', 'Thanh toán ZaloPay', 26, 27, 11, 11, 2025),
(16, 'Tiền mặt', 'Thanh toán tại nhà', 27, 28, 12, 11, 2025),
(17, 'Thẻ ngân hàng', 'Thanh toán qua thẻ', 28, 28, 13, 11, 2025),
(18, 'Ví điện tử', 'Thanh toán MoMo', 29, 29, 14, 11, 2025),
(19, 'Tiền mặt', 'Thanh toán khi nhận', 30, 29, 15, 11, 2025),
(20, 'Thẻ ngân hàng', 'Thanh toán qua thẻ', 31, 30, 16, 11, 2025),
(21, 'Ví điện tử', 'Thanh toán ZaloPay', 32, 30, 17, 11, 2025);

-- Quan hệ theo dõi giữa người dùng
INSERT INTO TheoDoi (FollowerCCCD, FollowedCCCD) VALUES
('567890123456', '678901234567'),
('567890123456', '789012345678'),
('678901234567', '567890123456'),
('678901234567', '890123456789'),
('789012345678', '567890123456'),
('789012345678', '901234567890'),
('890123456789', '678901234567'),
('890123456789', '901234567890'),
('901234567890', '567890123456'),
('901234567890', '789012345678'),
('666666666666', '111111111111'),
('777777777777', '222222222222'),
('888888888888', '333333333333'),
('999999999999', '444444444444'),
('101010101010', '555555555555'),
('111111111111', '666666666666'),
('222222222222', '777777777777'),
('333333333333', '888888888888'),
('444444444444', '999999999999'),
('555555555555', '101010101010');


-- Cập nhật trạng thái đơn hàng thành 'Đã nhận được hàng'
UPDATE DonHang
SET TrangThaiDonHang = 'Đã nhận được hàng'
WHERE MaDonHang IN (12, 13, 14, 15, 16);

-- Đánh giá sản phẩm
INSERT INTO DanhGia (CCCD, MaSanPham, MaShop, Diem, NoiDung, Ngay, Thang, Nam) VALUES
('567890123456', 1, 1, 5, 'Sản phẩm tốt, giao hàng nhanh', 4, 12, 2025),
('567890123456', 2, 1, 4, 'Hàng ổn, đóng gói chắc chắn', 5, 12, 2025),
('678901234567', 1, 2, 5, 'Rất hài lòng, dùng tốt', 6, 12, 2025),
('678901234567', 2, 2, 4, 'Sản phẩm đúng mô tả', 7, 12, 2025),
('678901234567', 5, 2, 5, 'Chất lượng vượt mong đợi', 8, 12, 2025);

-- Yêu cầu đổi trả
INSERT INTO YeuCauDoiTra (CCCD, MaDonHang, LyDoDoiTra, Ngay, Thang, Nam, TrangThai) VALUES
('567890123456', 12, 'Sản phẩm bị lỗi kỹ thuật', 5, 12, 2025, 'Chờ xác nhận'),
('567890123456', 13, 'Giao sai màu sắc', 5, 12, 2025, 'Chờ xác nhận'),
('678901234567', 14, 'Sản phẩm không đúng mô tả', 5, 12, 2025, 'Chờ xác nhận'),
('678901234567', 15, 'Bao bì hư hỏng, nghi ngờ va đập', 5, 12, 2025, 'Chờ xác nhận'),
('678901234567', 16, 'Không còn nhu cầu sử dụng', 5, 12, 2025, 'Chờ xác nhận');
