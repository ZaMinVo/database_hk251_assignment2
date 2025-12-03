-- Thiết lập chung
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Reset schema
DROP TRIGGER IF EXISTS check_follow_self;

DROP TABLE IF EXISTS ApDungVoucher;
DROP TABLE IF EXISTS Voucher;
DROP TABLE IF EXISTS ThanhToan;
DROP TABLE IF EXISTS YeuCauDoiTra;
DROP TABLE IF EXISTS GioPhuChuaSanPham;
DROP TABLE IF EXISTS GioPhu;
DROP TABLE IF EXISTS DonHang;
DROP TABLE IF EXISTS GioHang;
DROP TABLE IF EXISTS SanPhamThuocVao;
DROP TABLE IF EXISTS DanhGia;
DROP TABLE IF EXISTS SanPham;
DROP TABLE IF EXISTS Shop;
DROP TABLE IF EXISTS DanhMuc;
DROP TABLE IF EXISTS ThuongHieu;
DROP TABLE IF EXISTS TheoDoi;
DROP TABLE IF EXISTS HoSoLienLac;
DROP TABLE IF EXISTS NganHang;
DROP TABLE IF EXISTS NguoiDung;

-- Nhóm người dùng / tài khoản
CREATE TABLE NguoiDung (
    CCCD VARCHAR(12) NOT NULL,
    Ten VARCHAR(255) NOT NULL,
    NgaySinh INT,
    ThangSinh INT,
    NamSinh INT,
    SoDienThoaiXacMinh VARCHAR(10) NOT NULL,
    TaiKhoan VARCHAR(255) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    IsSeller TINYINT(1) NOT NULL DEFAULT 1,
    IsBuyer TINYINT(1) NOT NULL DEFAULT 0,
    ThuNhap INT DEFAULT NULL,
    TrangThai ENUM('active', 'inactive', 'locked') DEFAULT 'active',
    CapDoMuaHang ENUM('Đồng', 'Bạc', 'Vàng', 'Kim Cương') DEFAULT NULL,
    PRIMARY KEY (CCCD),
    UNIQUE KEY uniq_cccd (CCCD),
    -- UNIQUE KEY uniq_ten (Ten),
    UNIQUE KEY uniq_sdt (SoDienThoaiXacMinh),
    UNIQUE KEY uniq_taikhoan (TaiKhoan)
);

CREATE TABLE NganHang (
    CCCD VARCHAR(12) NOT NULL,
    MaNganHang VARCHAR(19) NOT NULL,
    SoTaiKhoan VARCHAR(255) NOT NULL,
    PRIMARY KEY (CCCD, MaNganHang, SoTaiKhoan),
    CONSTRAINT fk_nganhang_nguoidung FOREIGN KEY (CCCD)
        REFERENCES NguoiDung (CCCD)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Shop & sản phẩm
CREATE TABLE Shop (
    CCCD VARCHAR(12) NOT NULL,
    MaShop INT NOT NULL AUTO_INCREMENT,
    Ten VARCHAR(255),
    DiaChi VARCHAR(255),
    Ngay INT,
    Thang INT,
    Nam INT,
    PRIMARY KEY (MaShop),
    UNIQUE KEY uniq_shop_cccd (CCCD),
    CONSTRAINT fk_shop_nguoidung FOREIGN KEY (CCCD)
        REFERENCES NguoiDung (CCCD)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE SanPham (
    MaShop INT NOT NULL,
    MaSanPham INT NOT NULL,
    Ten VARCHAR(255),
    SoLuong INT,
    GiaBan INT,
    DaXoa TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (MaSanPham, MaShop),
    KEY idx_sanpham_mashop (MaShop),
    CONSTRAINT chk_sanpham_soluong CHECK (SoLuong >= 0),
    CONSTRAINT chk_sanpham_giaban CHECK (GiaBan > 0),
    CONSTRAINT fk_sanpham_shop FOREIGN KEY (MaShop)
        REFERENCES Shop (MaShop)
        ON DELETE RESTRICT
);

-- Đánh giá & hồ sơ liên lạc
CREATE TABLE DanhGia (
    CCCD VARCHAR(12) NOT NULL,
    MaSanPham INT NOT NULL,
    MaShop INT NOT NULL,
    Diem TINYINT NOT NULL DEFAULT 0,
    NoiDung VARCHAR(255),
    Ngay INT,
    Thang INT,
    Nam INT,
    PRIMARY KEY (CCCD, MaSanPham, Mashop),
    CONSTRAINT fk_danhgia_sanpham FOREIGN KEY (MaSanPham, Mashop)
        REFERENCES SanPham (MaSanPham, Mashop),
    CONSTRAINT fk_danhgia_nguoidung FOREIGN KEY (CCCD)
        REFERENCES NguoiDung (CCCD),
    CONSTRAINT chk_danhgia_diem CHECK (Diem IN (0, 1, 2, 3, 4, 5))
);

CREATE TABLE HoSoLienLac (
    CCCD VARCHAR(12) NOT NULL,
    MaHoSo INT NOT NULL,
    Ten VARCHAR(255),
    SDT VARCHAR(10),
    DiaChi VARCHAR(255),
    PRIMARY KEY (MaHoSo, CCCD),
    KEY idx_hosolienlac_cccd (CCCD),
    CONSTRAINT fk_hosolienlac_nguoidung FOREIGN KEY (CCCD)
        REFERENCES NguoiDung (CCCD)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE TheoDoi (
    FollowerCCCD VARCHAR(12) NOT NULL,
    FollowedCCCD VARCHAR(12) NOT NULL,
    PRIMARY KEY (FollowerCCCD, FollowedCCCD),
    KEY idx_theodoi_followed (FollowedCCCD),
    CONSTRAINT fk_theodoi_follower FOREIGN KEY (FollowerCCCD)
        REFERENCES NguoiDung (CCCD)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_theodoi_followed FOREIGN KEY (FollowedCCCD)
        REFERENCES NguoiDung (CCCD)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Ràng buộc nghiệp vụ: không cho phép tự follow chính mình
DELIMITER $$
CREATE TRIGGER check_follow_self
BEFORE INSERT ON TheoDoi
FOR EACH ROW
BEGIN
    IF NEW.FollowerCCCD = NEW.FollowedCCCD THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FollowerCCCD cannot be the same as FollowedCCCD';
    END IF;
END$$
DELIMITER ;

-- Thương hiệu / danh mục / mapping sản phẩm
CREATE TABLE ThuongHieu (
    MaThuongHieu INT NOT NULL,
    TenThuongHieu VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (MaThuongHieu),
    UNIQUE KEY uniq_thuonghieu_ten (TenThuongHieu)
);

CREATE TABLE DanhMuc (
    MaDanhMuc INT NOT NULL,
    TenDanhMuc VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (MaDanhMuc),
    UNIQUE KEY uniq_danhmuc_ten (TenDanhMuc)
);

CREATE TABLE SanPhamThuocVao (
    MaSanPham INT NOT NULL,
    MaShop INT NOT NULL,
    MaThuongHieu INT NOT NULL,
    MaDanhMuc INT NOT NULL,
    PRIMARY KEY (MaSanPham, Mashop),
    KEY idx_sanphamthuocvao_thuonghieu (MaThuongHieu),
    KEY idx_sanphamthuocvao_danhmuc (MaDanhMuc),
    CONSTRAINT fk_sanphamthuocvao_sanpham FOREIGN KEY (MaSanPham, Mashop)
        REFERENCES SanPham (MaSanPham, Mashop)
        ON DELETE CASCADE,
    CONSTRAINT fk_sanphamthuocvao_thuonghieu FOREIGN KEY (MaThuongHieu)
        REFERENCES ThuongHieu (MaThuongHieu),
    CONSTRAINT fk_sanphamthuocvao_danhmuc FOREIGN KEY (MaDanhMuc)
        REFERENCES DanhMuc (MaDanhMuc)
);

-- Giỏ hàng & đơn hàng
CREATE TABLE GioHang (
    MaGioHang INT NOT NULL AUTO_INCREMENT,
    CCCD VARCHAR(12) NOT NULL,
    PRIMARY KEY (MaGioHang),
    UNIQUE KEY uniq_giohang_cccd (CCCD),
    CONSTRAINT fk_giohang_nguoidung FOREIGN KEY (CCCD)
        REFERENCES NguoiDung (CCCD)
        ON DELETE RESTRICT
);

CREATE TABLE DonHang (
    MaDonHang INT NOT NULL AUTO_INCREMENT,
    GiaVanChuyen INT,
    TrangThaiDonHang ENUM('Đơn hàng đã đặt', 'Đơn hàng đã thanh toán', 'Đã giao cho đơn vị vận chuyển', 'Đã nhận được hàng', 'Đánh giá') DEFAULT 'Đơn hàng đã đặt',
    MaDonViVanChuyen VARCHAR(255),
    CCCD VARCHAR(12),
    MaHoSo INT,
    MaGioHang INT NOT NULL,
    MaGioPhu INT NOT NULL,
    PRIMARY KEY (MaDonHang),
    KEY idx_donhang_ho_so (MaHoSo, CCCD),
    KEY idx_donhang_giohang (MaGioHang),
    CONSTRAINT fk_donhang_hosolienlac FOREIGN KEY (MaHoSo, CCCD)
        REFERENCES HoSoLienLac (MaHoSo, CCCD)
        ON DELETE SET NULL
        ON UPDATE RESTRICT,
    CONSTRAINT fk_donhang_giohang FOREIGN KEY (MaGioHang)
        REFERENCES GioHang (MaGioHang)
        ON DELETE RESTRICT,
    CONSTRAINT chk_donhang_giavanchuyen CHECK (GiaVanChuyen >= 0)
);

-- Liên kết giỏ phụ với đơn hàng và sản phẩm
CREATE TABLE GioPhu (
    MaGioHang INT NOT NULL,
    MaGioPhu INT NOT NULL,
    MaDonHang INT NOT NULL,
    PRIMARY KEY (MaGioHang, MaGioPhu),
    KEY idx_giophu_donhang (MaDonHang),
    CONSTRAINT fk_giophu_donhang FOREIGN KEY (MaDonHang)
        REFERENCES DonHang (MaDonHang)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_giophu_giohang FOREIGN KEY (MaGioHang)
        REFERENCES GioHang (MaGioHang)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE GioPhuChuaSanPham (
    MaGioHang INT NOT NULL,
    MaGioPhu INT NOT NULL,
    MaSanPham INT NOT NULL,
    MaShop INT NOT NULL,
    SoLuong INT,
    PRIMARY KEY (MaGioPhu, MaSanPham, MaGioHang, MaShop),
    KEY idx_gpcs_sanpham (MaSanPham, MaShop),
    KEY idx_gpcs_giophu (MaGioHang, MaGioPhu),
    CONSTRAINT fk_gpcs_sanpham FOREIGN KEY (MaSanPham, MaShop)
        REFERENCES SanPham (MaSanPham, MaShop),
    CONSTRAINT fk_gpcs_giophu FOREIGN KEY (MaGioHang, MaGioPhu)
        REFERENCES GioPhu (MaGioHang, MaGioPhu),
    CONSTRAINT chk_gpcs_soluong CHECK (SoLuong > 0)
);

-- Đổi trả, thanh toán, voucher
CREATE TABLE YeuCauDoiTra (
    CCCD VARCHAR(12) NOT NULL,
    MaDonHang INT NOT NULL,
    LyDoDoiTra VARCHAR(255),
    Ngay INT,
    Thang INT,
    Nam INT,
    TrangThai ENUM('Chờ xác nhận', 'Đã xác nhận', 'Không hợp lệ') DEFAULT 'Chờ xác nhận',
    PRIMARY KEY (CCCD, MaDonHang),
    KEY idx_ycdr_donhang (MaDonHang),
    CONSTRAINT fk_ycdr_nguoidung FOREIGN KEY (CCCD)
        REFERENCES NguoiDung (CCCD)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_ycdr_donhang FOREIGN KEY (MaDonHang)
        REFERENCES DonHang (MaDonHang)
);

CREATE TABLE ThanhToan (
    MaThanhToan INT NOT NULL AUTO_INCREMENT,
    PhuongThucThanhToan ENUM('Tiền mặt', 'Ví điện tử', 'Thẻ ngân hàng') DEFAULT 'Tiền mặt',
    MoTa VARCHAR(255),
    MaDonHang INT NOT NULL,
    Ngay INT,
    Gio INT,
    Thang INT,
    Nam INT,
    PRIMARY KEY (MaThanhToan),
    KEY idx_thanhtoan_donhang (MaDonHang),
    CONSTRAINT fk_thanhtoan_donhang FOREIGN KEY (MaDonHang)
        REFERENCES DonHang (MaDonHang)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

CREATE TABLE Voucher (
    MaVoucher INT NOT NULL AUTO_INCREMENT,
    SoLuongTonKho INT,
    MoTa VARCHAR(255),
    GiaTri INT,
    KieuVoucher ENUM('vanchuyen', 'hanghoa') DEFAULT NULL,
    PRIMARY KEY (MaVoucher),
    CONSTRAINT chk_voucher_soluong CHECK (SoLuongTonKho >= 0),
    CONSTRAINT chk_voucher_giatri CHECK (GiaTri > 0)
);

CREATE TABLE ApDungVoucher (
    MaDonHang INT NOT NULL,
    MaVoucher INT NOT NULL,
    PRIMARY KEY (MaDonHang, MaVoucher),
    KEY idx_apdungvoucher_voucher (MaVoucher),
    CONSTRAINT fk_apdungvoucher_donhang FOREIGN KEY (MaDonHang)
        REFERENCES DonHang (MaDonHang)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    CONSTRAINT fk_apdungvoucher_voucher FOREIGN KEY (MaVoucher)
        REFERENCES Voucher (MaVoucher)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

SET FOREIGN_KEY_CHECKS = 1;
