-- Test thủ tục 2_3 (chạy sau khi đã load create_table.sql, insert_data.sql, 2_3.sql)

-- Test 1: Liệt kê sản phẩm của Shop 1 trong danh mục 1
CALL sp_LietKeSanPhamTheoShopDanhMuc(1, 1);

-- Test 2: Liệt kê sản phẩm của Shop 2 trong danh mục 3
CALL sp_LietKeSanPhamTheoShopDanhMuc(2, 3);

-- Test 3: Thống kê tồn danh mục của Shop 1, ngưỡng tối thiểu 10 sản phẩm
CALL sp_ThongKeTonTheoDanhMuc(1, 10);

-- Test 4: Thống kê tồn danh mục của Shop 2, ngưỡng tối thiểu 5 sản phẩm
CALL sp_ThongKeTonTheoDanhMuc(2, 5);
