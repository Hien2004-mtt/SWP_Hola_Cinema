// ==========================
//  payment.js – FINAL VERSION
// ==========================

document.addEventListener("DOMContentLoaded", function () {

    // ==========================
    // 1) XỬ LÝ ÁP DỤNG VOUCHER
    // ==========================
    const voucherForm = document.getElementById("voucherForm");
    const voucherCodeInput = document.getElementById("voucherCode");

    if (voucherForm && voucherCodeInput) {
        voucherForm.addEventListener("submit", function (e) {
            const code = voucherCodeInput.value.trim();

            if (code === "") {
                e.preventDefault();
                alert("️❗ Vui lòng nhập mã voucher trước khi áp dụng!");
                return false;
            }

            console.log("[VoucherForm] Submitting voucher:", code);
            // không preventDefault nữa
        });
    }

    // =========================================
    // 2) HIỆN THÔNG BÁO KHI THANH TOÁN BỊ FAIL
    // =========================================
    const params = new URLSearchParams(window.location.search);
    if (params.get("page") === "fail" && params.get("msg")) {
        const msg = decodeURIComponent(params.get("msg"));
        alert("❌ " + msg);
    }


    // ==========================
    // 3) COUNTDOWN 60 GIÂY
    // ==========================
    let seconds = 60;

    const timer = setInterval(() => {
        seconds--;

        const label = document.getElementById("countdown_label");
        if (label) label.textContent = seconds;

        if (seconds <= 0) {
            clearInterval(timer);

            console.log("⛔ Timeout reached. Calling cancelBooking API...");

            // Gọi server hủy booking
            fetch(window.contextPath + "/cancelBooking", {
                method: "POST"
            })
                .then(() => {
                    alert("⛔ Hệ thống không ghi nhận thanh toán. Booking đã bị hủy!");
                    window.location.href = window.contextPath + "/home";
                })
                .catch(err => console.error("CancelBooking error:", err));
        }
    }, 1000);

});
