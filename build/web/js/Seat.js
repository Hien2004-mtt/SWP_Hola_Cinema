let selectedCount = 0;
let selectedType = null;
let totalPrice = 0;

// 🟢 Cập nhật danh sách ghế đã chọn (hiển thị text)
function updateSelectedSeatsText() {
    const selected = document.querySelectorAll('input[name="selectedSeats"]:checked');
    const seatCodes = Array.from(selected).map(cb => cb.value);
    document.getElementById("selectedSeatsText").innerText =
            seatCodes.length > 0 ? seatCodes.join(", ") : "Chưa chọn";
}

// 🟢 Xử lý khi click chọn / bỏ chọn ghế
function toggleSeat(seatCode, checkboxId, divId, seatType) {
    const checkbox = document.getElementById(checkboxId);
    const div = document.getElementById(divId);
    const basePriceInput = document.getElementById("basePrice");

    if (!checkbox || !div || !basePriceInput) {
        console.error("❌ Không tìm thấy phần tử HTML cần thiết!");
        return;
    }

    const basePrice = parseFloat(basePriceInput.value);
    if (isNaN(basePrice)) {
        console.error("❌ Base price không hợp lệ:", basePriceInput.value);
        return;
    }

    // Nếu ghế bị disable → bỏ qua
    if (checkbox.disabled)
        return;

    const isSelecting = !checkbox.checked;
    let seatPrice = basePrice;

    // Tính giá theo loại ghế
    if (seatType.toLowerCase() === "vip") {
        seatPrice += 70000;
    } else if (seatType.toLowerCase() === "sweetbox") {
        seatPrice += 100000;
    }

    // ✅ Chọn ghế
    if (isSelecting) {
        if (selectedCount >= 8) {
            alert("Bạn chỉ được chọn tối đa 8 ghế.");
            return;
        }

        if (selectedType && selectedType !== seatType) {
            alert("Bạn chỉ được chọn ghế cùng loại: " + selectedType);
            return;
        }

        checkbox.checked = true;
        div.classList.add("selected");
        selectedCount++;
        selectedType = seatType;
        totalPrice += seatPrice;
    }
    // ❌ Bỏ chọn ghế
    else {
        checkbox.checked = false;
        div.classList.remove("selected");
        selectedCount--;
        totalPrice -= seatPrice;

        if (selectedCount === 0) {
            selectedType = null;
        }
    }

    // 🟢 Cập nhật giao diện
    updateUI();
}

// 🟢 Hàm cập nhật giao diện tổng tiền và ghế đã chọn
function updateUI() {
    const totalDisplay = document.getElementById("totalPrice");
    const totalInput = document.getElementById("totalPriceInput");

    totalDisplay.innerText = totalPrice.toLocaleString() + " VND";
    totalInput.value = totalPrice;

    updateSelectedSeatsText();
}

// 🟢 Kiểm tra trước khi submit form
function validateSelection() {
    if (selectedCount === 0) {
        alert("Bạn chưa chọn ghế nào.");
        return false;
    }

    const totalInput = document.getElementById("totalPriceInput");
    if (parseFloat(totalInput.value) <= 0) {
        alert("Tổng tiền không hợp lệ. Vui lòng chọn lại ghế!");
        return false;
    }

    return true;
}
