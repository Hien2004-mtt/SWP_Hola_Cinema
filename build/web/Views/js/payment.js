// ✅ payment.js - FIXED: form apply voucher không gửi, mất session
document.addEventListener("DOMContentLoaded", function () {
    const voucherForm = document.getElementById("voucherForm");
    const voucherCodeInput = document.getElementById("voucherCode");

    // 🧾 Kiểm tra nhập voucher trước khi gửi form
    if (voucherForm && voucherCodeInput) {
        voucherForm.addEventListener("submit", function (e) {
            const code = voucherCodeInput.value.trim();

            if (code === "") {
                e.preventDefault(); // ❌ chặn gửi nếu trống
                alert("️ Vui lòng nhập mã voucher trước khi áp dụng!");
                return false;
            }

            // ✅ Nếu có mã, cho phép gửi bình thường
            console.log("[VoucherForm] Submitting voucher:", code);
            // KHÔNG ĐƯỢC gọi preventDefault ở đây
        });
    }

    // ⚠️ Hiển thị thông báo nếu có lỗi trên URL (?page=fail&msg=...)
    const params = new URLSearchParams(window.location.search);
    if (params.get("page") === "fail" && params.get("msg")) {
        const msg = decodeURIComponent(params.get("msg"));
        alert("❌ " + msg);
    }

    
    
});
