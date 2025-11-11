
let selectedCount = 0;
let selectedType = null;
let totalPrice = 0;

// 🟢 Cập nhật danh sách ghế đã chọn
function updateSelectedSeatsText() {
    const selected = document.querySelectorAll('input[name="selectedSeats"]:checked');
    const seatCodes = Array.from(selected).map(cb => cb.value);
    document.getElementById("selectedSeatsText").innerText =
            seatCodes.length > 0 ? seatCodes.join(", ") : "Chưa chọn";
}

// 🟢 Xử lý khi click vào ghế
function toggleSeat(seatCode, checkboxId, divId, seatType) {
    const checkbox = document.getElementById(checkboxId);
    const div = document.getElementById(divId);
    const basePriceInput = document.getElementById("basePriceJS");

    if (!checkbox || !div || !basePriceInput)
        return;

    const basePrice = parseFloat(basePriceInput.value);
    if (isNaN(basePrice))
        return;

    if (checkbox.disabled)
        return; // Không chọn được ghế bị khóa

    const isSelecting = !checkbox.checked;
    let seatPrice = basePrice;

    // Cộng thêm giá theo loại ghế
    if (seatType.toLowerCase() === "vip")
        seatPrice += 70000;
    else if (seatType.toLowerCase() === "sweetbox")
        seatPrice += 100000;

    // 🟢 Khi người dùng CHỌN ghế
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
    // 🔴 Khi người dùng BỎ CHỌN ghế
    else {
        checkbox.checked = false;
        div.classList.remove("selected");
        selectedCount--;
        totalPrice -= seatPrice;

        if (selectedCount === 0) {
            selectedType = null;
        }
    }

    updateUI();
}

// 🟢 Cập nhật giao diện hiển thị tổng tiền + loại ghế + danh sách
function updateUI() {
    const totalDisplay = document.getElementById("totalPrice");
    const totalInput = document.getElementById("totalPriceInput");
    const seatTypeDisplay = document.getElementById("selectedSeatType");

    totalDisplay.innerText = totalPrice.toLocaleString() + " VND";
    totalInput.value = totalPrice;
    seatTypeDisplay.innerText = selectedType ? selectedType : "Chưa chọn";

    updateSelectedSeatsText();
}

// 🟢 Kiểm tra trước khi submit form
function validateSelection() {
    const selected = Array.from(document.querySelectorAll('input[name="selectedSeats"]:checked'));
    if (selected.length === 0) {
        alert("Bạn chưa chọn ghế nào.");
        return false;
    }

    // 👉 Gom theo hàng
    const row = selected[0].value.charAt(0);
    const numbers = selected.map(s => parseInt(s.value.substring(1))).sort((a, b) => a - b);

    // Kiểm tra cùng hàng
    if (!selected.every(s => s.value.charAt(0) === row)) {
        alert("Vui lòng chọn các ghế trong cùng một hàng!");
        return false;
    }

    // Kiểm tra liền kề nhau
    for (let i = 1; i < numbers.length; i++) {
        if (numbers[i] - numbers[i - 1] !== 1) {
            alert("Vui lòng chọn các ghế LIỀN KỀ nhau (ví dụ: " + row + numbers[0] + ", " + row + (numbers[0] + 1) + ")!");
            return false;
        }
    }

    const totalInput = document.getElementById("totalPriceInput");
    if (parseFloat(totalInput.value) <= 0) {
        alert("Tổng tiền không hợp lệ. Vui lòng chọn lại ghế!");
        return false;
    }

    return true;
}
            

           