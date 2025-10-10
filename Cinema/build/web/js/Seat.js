
            let selectedCount = 0;
            let selectedType = null;
            let totalPrice = 0;

            function updateSelectedSeatsText() {
                const selected = document.querySelectorAll('input[name="selectedSeats"]:checked');
                const seatCodes = Array.from(selected).map(cb => cb.value);
                document.getElementById("selectedSeatsText").innerText = seatCodes.length > 0 ? seatCodes.join(", ") : "Chưa chọn";
            }

            function toggleSeat(seatCode, checkboxId, divId, seatType) {
                const checkbox = document.getElementById(checkboxId);
                const div = document.getElementById(divId);
                const basePrice = parseFloat(document.getElementById("basePrice").value);

                if (checkbox.disabled)
                    return;

                const isSelecting = !checkbox.checked;
                let seatPrice = basePrice;

                if (seatType.toLowerCase() === "vip")
                    seatPrice += 70000;
                else if (seatType.toLowerCase() === "sweetbox")
                    seatPrice += 100000;

                if (isSelecting) {
                    if (selectedCount >= 8) {
                        alert("Bạn chỉ được chọn tối đa 8 ghế.");
                        return;
                    }
                    if (selectedType && selectedType !== seatType) {
                        alert("Bạn chỉ được chọn ghế cùng một loại: " + selectedType);
                        return;
                    }
                    checkbox.checked = true;
                    div.classList.add("selected");
                    selectedCount++;
                    selectedType = seatType;
                    totalPrice += seatPrice;
                } else {
                    checkbox.checked = false;
                    div.classList.remove("selected");
                    selectedCount--;
                    totalPrice -= seatPrice;
                    if (selectedCount === 0)
                        selectedType = null;
                }

                document.getElementById("totalPrice").innerText = totalPrice.toLocaleString() + " VND";
                updateSelectedSeatsText();
            }

            function validateSelection() {
                if (selectedCount === 0) {
                    alert("Bạn chưa chọn ghế nào.");
                    return false;
                }
                return true;
            }
        