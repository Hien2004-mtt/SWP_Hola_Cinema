package Models;

import java.math.BigDecimal;

public class Food {
    private int foodId;
    private String name;
    private String type;
    private BigDecimal price;
    private boolean status;

    public Food() {}

    public Food(int foodId, String name, String type, BigDecimal price, boolean status) {
        this.foodId = foodId;
        this.name = name;
        this.type = type;
        this.price = price;
        this.status = status;
    }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}
