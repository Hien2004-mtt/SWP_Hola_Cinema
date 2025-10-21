package Models;

import java.util.Date;

public class Voucher {
    private int voucherId;
    private String code;
    private String type; // percent | fixed | gift
    private double value;
    private Date validFrom;
    private Date validTo;
    private int usageLimit;
    private int perUserLimit;
    private boolean isActive;

    public Voucher() {
    }

    public Voucher(int voucherId, String code, String type, double value,
                   Date validFrom, Date validTo, int usageLimit, int perUserLimit, boolean isActive) {
        this.voucherId = voucherId;
        this.code = code;
        this.type = type;
        this.value = value;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.usageLimit = usageLimit;
        this.perUserLimit = perUserLimit;
        this.isActive = isActive;
    }

    // Getter
    public int getVoucherId() { return voucherId; }
    public String getCode() { return code; }
    public String getType() { return type; }
    public double getValue() { return value; }
    public Date getValidFrom() { return validFrom; }
    public Date getValidTo() { return validTo; }
    public int getUsageLimit() { return usageLimit; }
    public int getPerUserLimit() { return perUserLimit; }

    public void setVoucherId(int voucherId) {
        this.voucherId = voucherId;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public void setValidFrom(Date validFrom) {
        this.validFrom = validFrom;
    }

    public void setValidTo(Date validTo) {
        this.validTo = validTo;
    }

    public void setUsageLimit(int usageLimit) {
        this.usageLimit = usageLimit;
    }

    public void setPerUserLimit(int perUserLimit) {
        this.perUserLimit = perUserLimit;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

   
    
}
