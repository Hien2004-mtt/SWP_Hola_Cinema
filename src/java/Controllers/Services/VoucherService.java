package Controllers.Services;

import DAO.VoucherDAO;
import Models.Voucher;
import java.sql.Connection;
import java.util.Date;

public class VoucherService {

    private final VoucherDAO voucherDAO;

    public VoucherService(Connection conn) {
        this.voucherDAO = new VoucherDAO(conn);
    }

    /**
     * Lấy voucher theo code
     */
    public Voucher getVoucherByCode(String code) throws Exception {
        return voucherDAO.getVoucherByCode(code);
    }

    /**
     * Áp dụng voucher, có kiểm tra:
     * - Trạng thái isActive
     * - Thời hạn validFrom / validTo
     * - usageLimit > 0
     * Sau khi dùng, tự giảm usageLimit.
     */
    public double applyVoucher(String code, double originalTotal) throws Exception {
        Voucher voucher = voucherDAO.getVoucherByCode(code);

        if (voucher == null)
            throw new Exception(" Voucher không tồn tại hoặc đã bị xóa!");

        if (!voucher.isIsValid())
            throw new Exception("️ Voucher đã bị vô hiệu hóa!");

        Date now = new Date();
        if (voucher.getValidFrom() != null && now.before(voucher.getValidFrom()))
            throw new Exception("️ Voucher chưa đến thời gian sử dụng!");

        if (voucher.getValidTo() != null && now.after(voucher.getValidTo()))
            throw new Exception("️ Voucher đã hết hạn sử dụng!");

        if (voucher.getUsageLimit() <= 0)
            throw new Exception("️ Voucher đã hết lượt sử dụng!");

        double discount = 0;
        switch (voucher.getType().toLowerCase()) {
            case "percent":
                discount = originalTotal * (voucher.getValue() / 100.0);
                break;
            case "fixed":
                discount = voucher.getValue();
                break;
            default:
                throw new Exception(" Loại voucher không hợp lệ!");
        }

        double discountedTotal = originalTotal - discount;
        if (discountedTotal < 0) discountedTotal = 0;

        // Giảm lượt sử dụng nếu thành công
        voucherDAO.decreaseUsage(code);

        return discountedTotal;
    }
}
