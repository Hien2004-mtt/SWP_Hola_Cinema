let selectedCount = 0;
let selectedType = null;
let totalPrice = 0;

// Cập nhật danh sách ghế đã chọn
function updateSelectedSeatsText() {
    const selected = document.querySelectorAll('input[name="selectedSeats"]:checked');
    const seatCodes = Array.from(selected).map(cb => cb.value);
    document.getElementById("selectedSeatsText").innerText =
            seatCodes.length > 0 ? seatCodes.join(", ") : "Chưa chọn";
}

// Xử lý click ghế
function toggleSeat(seatCode, checkboxId, divId, seatType) {
    const checkbox = document.getElementById(checkboxId);
    const div = document.getElementById(divId);
    const basePriceInput = document.getElementById("basePrice");
    if (!checkbox || !div || !basePriceInput)
        return;

    const basePrice = parseFloat(basePriceInput.value);
    if (isNaN(basePrice))
        return;

    // Nếu ghế bị vô hiệu → bỏ qua
    if (checkbox.disabled)
        return;

    const isSelecting = !checkbox.checked;
    let seatPrice = basePrice;

    // Cộng thêm theo loại ghế
    if (seatType.toLowerCase() === "vip")
        seatPrice += 70000;
    else if (seatType.toLowerCase() === "sweetbox")
        seatPrice += 100000;

    // 🟢 Khi người dùng chọn thêm ghế
    if (isSelecting) {
        if (selectedCount >= 8) {
            alert("Bạn chỉ được chọn tối đa 8 ghế.");
            return;
        }

        // 🟢 Kiểm tra xem loại ghế có trùng không
        if (selectedType && selectedType !== seatType) {
            alert("Bạn chỉ được chọn ghế cùng loại: " + selectedType);
            return;
        }

        checkbox.checked = true;
        div.classList.add("selected");
        selectedCount++;
        selectedType = seatType; // gán loại ghế khi chọn
        totalPrice += seatPrice;
    }
    // 🔴 Khi người dùng bỏ chọn ghế
    else {
        checkbox.checked = false;
        div.classList.remove("selected");
        selectedCount--;
        totalPrice -= seatPrice;

        // Nếu không còn ghế nào được chọn → reset loại ghế
        if (selectedCount === 0) {
            selectedType = null;
        }
    }

    updateUI();
}

// 🟢 Hàm cập nhật hiển thị tổng tiền + loại ghế + danh sách ghế
function updateUI() {
    const totalDisplay = document.getElementById("totalPrice");
    const totalInput = document.getElementById("totalPriceInput");
    const seatTypeDisplay = document.getElementById("selectedSeatType");

    totalDisplay.innerText = totalPrice.toLocaleString() + " VND";
    totalInput.value = totalPrice;

    // Cập nhật loại ghế hiển thị
    seatTypeDisplay.innerText = selectedType ? selectedType : "Chưa chọn";

    updateSelectedSeatsText();
}

// 🟢 Kiểm tra trước khi submit
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
