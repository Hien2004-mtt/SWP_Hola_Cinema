package Controllers.Services;

import DAO.VoucherDAO;
import Models.Voucher;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;

public class VoucherService {

    private final VoucherDAO voucherDAO;

    public VoucherService(Connection conn) {
        this.voucherDAO = new VoucherDAO(conn);
    }

    public Voucher getVoucherByCode(String code) throws Exception {
        if (code == null || code.trim().isEmpty()) {
            throw new Exception("Vui lòng nhập mã voucher!");
        }

        Voucher voucher = voucherDAO.getVoucherByCode(code.trim());
        if (voucher == null) {
            throw new Exception("Voucher không tồn tại hoặc đã bị vô hiệu hóa!");
        }
        return voucher;
    }

    public double applyVoucher(String code, double originalTotal) throws Exception {
        Voucher voucher = getVoucherByCode(code);

        Date now = new Date();
        

        double discount = 0;
        switch (voucher.getType().toLowerCase()) {
            case "percent":
                discount = originalTotal * (voucher.getValue() / 100.0);
                break;
            case "fixed":
                discount = voucher.getValue();
                break;
            default:
                throw new Exception("Loại voucher không hợp lệ!");
        }

        double discountedTotal = Math.max(0, originalTotal - discount);

        try {
            voucherDAO.decreaseUsage(code);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Lỗi khi cập nhật lượt sử dụng voucher!");
        }

        return discountedTotal;
    }
}
