document.addEventListener("DOMContentLoaded", function () {
    const voucherForm = document.getElementById("voucherForm");
    const voucherCodeInput = document.getElementById("voucherCode");

    // ️ Kiểm tra nhập voucher
    if (voucherForm) {
        voucherForm.addEventListener("submit", function (e) {
            if (voucherCodeInput.value.trim() === "") {
                e.preventDefault();
                alert("️ Vui lòng nhập mã voucher trước khi áp dụng!");
            }
        });
    }

    // ️ Hiển thị thông báo lỗi nếu có ?page=fail
    const params = new URLSearchParams(window.location.search);
    if (params.get("page") === "fail" && params.get("msg")) {
        alert( + decodeURIComponent(params.get("msg")));
    }

    // Có thể mở rộng: thêm hiệu ứng loading khi thanh toán
});
