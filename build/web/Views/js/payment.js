// ✅ payment.js - FIXED: form apply voucher không gửi, mất session
document.addEventListener("DOMContentLoaded", function () {

    const voucherForm = document.getElementById("voucherForm");
    const voucherCodeInput = document.getElementById("voucherCode");

    // 🧾 Kiểm tra nhập voucher trước khi gửi form
    if (voucherForm && voucherCodeInput) {
        voucherForm.addEventListener("submit", function (e) {
            const code = voucherCodeInput.value.trim();

            if (code === "") {
                e.preventDefault(); 
                alert("️ Vui lòng nhập mã voucher trước khi áp dụng!");
                return false;
            }

            console.log("[VoucherForm] Submitting voucher:", code);
        });
    }

    // ⚠️ Hiển thị thông báo nếu có lỗi trên URL (?page=fail&msg=...)
    const params = new URLSearchParams(window.location.search);
    if (params.get("page") === "fail" && params.get("msg")) {
        const msg = decodeURIComponent(params.get("msg"));
        alert("❌ " + msg);
    }

//    // ======================
//    // ⏳ COUNTDOWN HIỂN THỊ
//    // ======================
//    const countdownEl = document.getElementById("countdown");
//    let timeLeft = 60;
//
//    if (countdownEl) {
//        console.log("[Countdown] Started 60s timer.");
//
//        const timer = setInterval(() => {
//            timeLeft--;
//            countdownEl.textContent = timeLeft;
//            console.log(`[Countdown] ${timeLeft}s left`);
//
//            if (timeLeft <= 0) {
//                clearInterval(timer);
//                alert("⏳ Phiên thanh toán đã hết hạn! Bạn sẽ được chuyển về trang chủ.");
//                window.location.href = "home";
//            }
//        }, 1000);
//    }
    // ======================
// ⏳ COUNTDOWN HH:MM:SS:MS
// ======================
const countdownEl = document.getElementById("countdown");
let timeLeft = 60000; // 60 giây = 60000ms

if (countdownEl) {
    console.log("[Countdown] Started 60s timer.");

    const timer = setInterval(() => {

        timeLeft -= 10; // giảm 10ms mỗi lần

        if (timeLeft <= 0) {
            clearInterval(timer);
            countdownEl.textContent = "00:00:00:000";

            alert("⏳ Phiên thanh toán đã hết hạn! Bạn sẽ được chuyển về trang chủ.");
            window.location.href = "home";
            return;
        }

        // Tính HH:MM:SS:MS
        let hours = Math.floor(timeLeft / (1000 * 60 * 60));
        let minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
        let seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);
        let milliseconds = timeLeft % 1000;

        // Format 2 chữ số (ms = 3 chữ số)
        hours = String(hours).padStart(2, "0");
        minutes = String(minutes).padStart(2, "0");
        seconds = String(seconds).padStart(2, "0");
        milliseconds = String(milliseconds).padStart(3, "0");

        countdownEl.textContent = `${hours}:${minutes}:${seconds}:${milliseconds}`;

    }, 10); // cập nhật mỗi 10ms
}


    // ======================
    // 📝 DEBUG 5 GIÂY/LẦN
    // ======================
    let debugTime = 60;
    const debugInterval = setInterval(() => {
        debugTime -= 5;
        console.log(`[Payment] ${debugTime} seconds remaining...`);
    }, 5000);

    // Tự động rollback sau 1 phút
    setTimeout(function () {
        clearInterval(debugInterval);
        console.log("[Payment] TIMEOUT reached. Redirecting to home...");
        // Alert chỉ hiện nếu người dùng xem countdown
        alert("⏳ Phiên thanh toán đã hết hạn! Bạn sẽ được chuyển về trang chủ.");
        window.location.href = "home";
    }, 60 * 1000);

});
