document.addEventListener("DOMContentLoaded", function () {
    const voucherForm = document.getElementById("voucherForm");
    const voucherCodeInput = document.getElementById("voucherCode");

    voucherForm.addEventListener("submit", function (e) {
        if (voucherCodeInput.value.trim() === "") {
            e.preventDefault();
            alert("Vui lòng nhập mã voucher!");
        }
    });
});
