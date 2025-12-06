SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Dữ liệu người dùng / tài khoản (gộp flag người bán/người mua)
INSERT INTO NguoiDung
(CCCD, Ten, NgaySinh, ThangSinh, NamSinh, SoDienThoaiXacMinh, TaiKhoan, MatKhau, IsSeller, IsBuyer, ThuNhap, TrangThai, CapDoMuaHang)
VALUES
('000000000001','Nguyen Van A',1,1,1990,'0900000001','user1','pass',1,1,10000000,'active','Đồng'),
('000000000002','Tran Thi B',2,2,1995,'0900000002','user2','pass',0,1,5000000,'active','Bạc'),
('000000000003','Le Van C',3,3,1988,'0900000003','user3','pass',1,1,7000000,'active','Vàng'),
('000000000004','Pham Thi D',4,4,1999,'0900000004','user4','pass',0,1,3000000,'inactive',NULL),
('000000000005','Nguyen Van E',5,5,1980,'0900000005','user5','pass',1,1,20000000,'active','Kim Cương'),
('000000000006','Do Thi F',6,6,1992,'0900000006','user6','pass',0,1,4000000,'locked',NULL),
('000000000007','Hoang Van G',7,7,1998,'0900000007','user7','pass',1,1,6000000,'active','Đồng'),
('000000000008','Tran Thi H',8,8,1997,'0900000008','user8','pass',0,1,3500000,'active','Bạc'),
('000000000009','Nguyen Van I',9,9,1985,'0900000009','user9','pass',1,1,15000000,'active','Vàng'),
('000000000010','Le Thi K',10,10,1993,'0900000010','user10','pass',1,1,4200000,'active','Đồng'),
('000000000011','Vu Van L',11,11,1984,'0900000011','user11','pass',1,1,10000000,'active','Vàng'),
('000000000012','Nguyen Thi M',12,12,1991,'0900000012','user12','pass',1,1,9000000,'active','Đồng'),
('000000000013','Do Van N',13,1,1989,'0900000013','user13','pass',1,1,8000000,'active','Bạc'),
('000000000014','Pham Thi O',14,2,1994,'0900000014','user14','pass',1,1,7500000,'active','Đồng'),
('000000000015','Ngo Van P',15,3,1983,'0900000015','user15','pass',1,1,12000000,'active','Vàng'),
('000000000016','Tran Thi Q',16,4,1990,'0900000016','user16','pass',1,1,6500000,'active','Đồng'),
('000000000017','Ho Van R',17,5,1987,'0900000017','user17','pass',1,1,7200000,'active','Bạc'),
('000000000018','Le Thi S',18,6,1996,'0900000018','user18','pass',1,1,4300000,'active','Đồng'),
('000000000019','Ngo Van T',19,7,1982,'0900000019','user19','pass',1,1,11000000,'active','Vàng'),
('000000000020','Do Thi U',20,8,1991,'0900000020','user20','pass',1,1,5500000,'active','Đồng');


-- Tài khoản ngân hàng
INSERT INTO NganHang (CCCD, MaNganHang, SoTaiKhoan) VALUES
('000000000001','VCB','111111'),
('000000000003','ACB','222222'),
('000000000005','TCB','333333'),
('000000000007','BIDV','444444'),
('000000000009','VPB','555555'),
('000000000011','MB','666666'),
('000000000013','OCB','777777'),
('000000000015','SCB','888888'),
('000000000017','SHB','999999'),
('000000000019','VTB','101010');


-- Ngân hàng cho người dùng mới
INSERT INTO Shop (CCCD, Ten, DiaChi, Ngay, Thang, Nam)
VALUES
('000000000001','Shop A','Ha Noi',1,1,2020),
('000000000003','Shop B','HCM',2,1,2020),
('000000000005','Shop C','Da Nang',3,1,2020),
('000000000007','Shop D','Hue',4,1,2020),
('000000000009','Shop E','Ha Noi',5,1,2020),
('000000000011','Shop F','HCM',6,1,2020),
('000000000013','Shop G','Da Nang',7,1,2020),
('000000000015','Shop H','Ha Noi',8,1,2020),
('000000000017','Shop I','HCM',9,1,2020),
('000000000019','Shop J','Da Nang',10,1,2020);

-- Thương hiệu / danh mục
INSERT INTO ThuongHieu (MaThuongHieu, TenThuongHieu) VALUES
(1,'Thương Hiệu a'),
(2,'Thương Hiệu b'),
(3,'Thương Hiệu c'),
(4,'Thương Hiệu d'),
(5,'Thương Hiệu e'),
(6,'Thương Hiệu f'),
(7,'Thương Hiệu g'),
(8,'Thương Hiệu h'),
(9,'Thương Hiệu i'),
(10,'Thương Hiệu k');


INSERT INTO DanhMuc (MaDanhMuc, TenDanhMuc) VALUES
(1,'Danh Mục a'),
(2,'Danh Mục b'),
(3,'Danh Mục c'),
(4,'Danh Mục d'),
(5,'Danh Mục e'),
(6,'Danh Mục f'),
(7,'Danh Mục g'),
(8,'Danh Mục h'),
(9,'Danh Mục i'),
(10,'Danh Mục k');


-- Sản phẩm
INSERT INTO SanPham (MaShop, MaSanPham, Ten, AnhUrl, SoLuong, GiaBan, DaXoa) VALUES
(1,1,'Sản phẩm','/images/p1.jpg',50,100000,0),
(2,2,'Sản phẩm','/images/p2.jpg',30,200000,0),
(3,3,'Sản phẩm','/images/p3.jpg',20,150000,0),
(4,4,'Sản phẩm','/images/p4.jpg',40,120000,0),
(5,5,'Sản phẩm','/images/p5.jpg',25,250000,0),
(6,6,'Sản phẩm','/images/p6.jpg',60,80000,0),
(7,7,'Sản phẩm','/images/p7.jpg',10,300000,0),
(8,8,'Sản phẩm','/images/p8.jpg',35,90000,0),
(9,9,'Sản phẩm','/images/p9.jpg',45,110000,0),
(10,10,'Sản phẩm','/images/p10.jpg',15,400000,0);


-- Mapping sản phẩm ↔ thương hiệu/danh mục
INSERT INTO SanPhamThuocVao (MaSanPham, MaShop, MaThuongHieu, MaDanhMuc) VALUES
(1,1,1,1),
(2,2,2,2),
(3,3,3,3),
(4,4,4,4),
(5,5,5,5),
(6,6,6,6),
(7,7,7,7),
(8,8,8,8),
(9,9,9,9),
(10,10,10,10);


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
('000000000002',1,'Người nhận','0900000022','123 Đường A'),
('000000000004',2,'Người nhận','0900000044','456 Đường B'),
('000000000006',3,'Người nhận','0900000066','789 Đường C'),
('000000000008',4,'Người nhận','0900000088','12 Đường D'),
('000000000010',5,'Người nhận','0900000100','34 Đường E'),
('000000000012',6,'Người nhận','0900000122','56 Đường F'),
('000000000014',7,'Người nhận','0900000144','78 Đường G'),
('000000000016',8,'Người nhận','0900000166','90 Đường H'),
('000000000018',9,'Người nhận','0900000188','11 Đường I'),
('000000000020',10,'Người nhận','0900000200','22 Đường J');

-- Giỏ hàng
INSERT INTO GioHang (MaGioHang, CCCD) VALUES
(1,'000000000002'),
(2,'000000000004'),
(3,'000000000006'),
(4,'000000000008'),
(5,'000000000010'),
(6,'000000000012'),
(7,'000000000014'),
(8,'000000000016'),
(9,'000000000018'),
(10,'000000000020');

-- Đơn hàng
INSERT INTO DonHang (MaDonHang, GiaVanChuyen, TrangThaiDonHang, MaDonViVanChuyen, CCCD, MaHoSo, MaGioHang, MaGioPhu, NgayGiao, ThangGiao, NamGiao)
VALUES
(1,20000,'Đơn hàng đã đặt',NULL,'000000000002',1,1,1,NULL,NULL,NULL),
(2,15000,'Đã nhận được hàng','Viettel','000000000004',2,2,1,25,11,2025),
(3,30000,'Đơn hàng đã thanh toán','GHTK','000000000006',3,3,1,NULL,NULL,NULL),
(4,25000,'Đã nhận được hàng','VNPost','000000000008',4,4,1,26,11,2025),
(5,10000,'Đơn hàng đã đặt',NULL,'000000000010',5,5,1,NULL,NULL,NULL),
(6,18000,'Đã nhận được hàng','Viettel','000000000012',6,6,1,24,11,2025),
(7,22000,'Đơn hàng đã thanh toán','GHTK','000000000014',7,7,1,NULL,NULL,NULL),
(8,12000,'Đã nhận được hàng','VNPost','000000000016',8,8,1,23,11,2025),
(9,50000,'Đơn hàng đã đặt',NULL,'000000000018',9,9,1,NULL,NULL,NULL),
(10,16000,'Đã nhận được hàng','Viettel','000000000020',10,10,1,22,11,2025);


-- Giỏ phụ gắn đơn hàng
INSERT INTO GioPhu (MaGioHang, MaGioPhu) VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1),
(6,1),
(7,1),
(8,1),
(9,1),
(10,1);


-- Chi tiết sản phẩm trong giỏ phụ
INSERT INTO GioPhuChuaSanPham (MaGioHang, MaGioPhu, MaSanPham, MaShop, SoLuong) VALUES
(1,1,1,1,1),
(2,1,2,2,2),
(3,1,3,3,1),
(4,1,4,4,1),
(5,1,5,5,2),
(6,1,6,6,1),
(7,1,7,7,1),
(8,1,8,8,2),
(9,1,9,9,1),
(10,1,10,10,1);


-- Voucher
INSERT INTO Voucher (MaVoucher, SoLuongTonKho, MoTa, GiaTri, KieuVoucher) VALUES
(1,100,'Voucher vận chuyển 10k',10000,'vanchuyen'),
(2,50,'Giảm 50k hàng hóa',50000,'hanghoa'),
(3,20,'Voucher 20k',20000,'hanghoa'),
(4,10,'Voucher free ship',30000,'vanchuyen'),
(5,200,'Voucher 5k',5000,'hanghoa'),
(6,15,'Voucher khuyến mãi',15000,'hanghoa'),
(7,30,'Voucher 10%',10000,'hanghoa'),
(8,40,'Voucher 30k',30000,'hanghoa'),
(9,5,'Voucher đặc biệt',100000,'hanghoa'),
(10,80,'Voucher ship 15k',15000,'vanchuyen');


-- Áp dụng voucher cho đơn hàng
INSERT INTO ApDungVoucher (MaDonHang, MaVoucher) VALUES
(2,1),
(4,4),
(6,2),
(8,10),
(10,3),
(1,5),
(3,6),
(5,7),
(7,8),
(9,9);


-- Thanh toán
INSERT INTO ThanhToan (MaThanhToan, PhuongThucThanhToan, MoTa, MaDonHang, Ngay, Gio, Thang, Nam) VALUES
(1,'Ví điện tử','Momo',1,1,1000,11,2025),
(2,'Tiền mặt','Thanh toán khi nhận',2,25,1400,11,2025),
(3,'Thẻ ngân hàng','Visa',3,2,900,11,2025),
(4,'Ví điện tử','ZaloPay',4,26,1600,11,2025),
(5,'Tiền mặt','COD',5,3,1100,11,2025),
(6,'Thẻ ngân hàng','MasterCard',6,24,1500,11,2025),
(7,'Ví điện tử','Momo',7,4,1300,11,2025),
(8,'Tiền mặt','COD',8,23,1000,11,2025),
(9,'Thẻ ngân hàng','Visa',9,5,1030,11,2025),
(10,'Ví điện tử','ZaloPay',10,22,1700,11,2025);

-- Quan hệ theo dõi giữa người dùng
INSERT INTO TheoDoi (FollowerCCCD, FollowedCCCD) VALUES
('000000000002','000000000001'),
('000000000004','000000000003'),
('000000000006','000000000005'),
('000000000008','000000000007'),
('000000000010','000000000009'),
('000000000012','000000000011'),
('000000000014','000000000013'),
('000000000016','000000000015'),
('000000000018','000000000017'),
('000000000020','000000000019');



-- Cập nhật trạng thái đơn hàng thành 'Đã nhận được hàng'
UPDATE DonHang
SET TrangThaiDonHang = 'Đã nhận được hàng'
WHERE MaDonHang IN (12, 13, 14, 15, 16);

INSERT INTO DanhGia (CCCD, MaSanPham, MaShop, Diem, NoiDung, Ngay, Thang, Nam) VALUES
('000000000004', 2, 2, 5, 'Sản phẩm tốt, đóng gói chắc chắn.', 25, 11, 2025),
('000000000008', 4, 4, 4, 'Hài lòng, giao hàng nhanh.', 26, 11, 2025),
('000000000012', 6, 6, 5, 'Chất lượng vượt mong đợi.', 24, 11, 2025),
('000000000016', 8, 8, 3, 'Tạm ổn, cần cải thiện.', 23, 11, 2025),
('000000000020', 10, 10, 4, 'Giá hợp lý, đáng mua.', 22, 11, 2025);


-- Yêu cầu đổi trả
INSERT INTO YeuCauDoiTra (CCCD, MaDonHang, LyDoDoiTra, Ngay, Thang, Nam) VALUES
('000000000004', 2, 'Sản phẩm bị lỗi nhẹ', 27, 11, 2025),   -- 2 ngày sau giao (OK)
('000000000008', 4, 'Không đúng mô tả', 28, 11, 2025),      -- 2 ngày sau giao (OK)
('000000000012', 6, 'Hàng giao sai màu', 25, 11, 2025),     -- 1 ngày sau giao (OK)
('000000000016', 8, 'Muốn đổi kích thước', 24, 11, 2025),   -- 1 ngày sau giao (OK)
('000000000020', 10, 'Thiếu phụ kiện', 24, 11, 2025);       -- 2 ngày sau giao (OK)