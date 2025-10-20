document.addEventListener("DOMContentLoaded", () => {
    console.log(" Voucher JS loaded successfully");

    /* ===============  1. Xác nhận khi vô hiệu hóa / kích hoạt =============== */
    document.querySelectorAll(".btn-disable").forEach(btn => {
        btn.addEventListener("click", e => {
            if (!confirm("️ Bạn có chắc muốn vô hiệu hóa voucher này?")) {
                e.preventDefault();
            }
        });
    });

    document.querySelectorAll(".btn-activate").forEach(btn => {
        btn.addEventListener("click", e => {
            if (!confirm(" Kích hoạt lại voucher này?")) {
                e.preventDefault();
            }
        });
    });

    /* ===============  2. Validate Form (áp dụng cho Add & Edit) =============== */
    const form = document.querySelector("form[action$='voucher']");
    if (form) {
        form.addEventListener("submit", e => {
            const type = form.querySelector("select[name='type']").value;
            const value = parseFloat(form.querySelector("input[name='value']").value);
            const validFrom = new Date(form.querySelector("input[name='valid_from']").value);
            const validTo = new Date(form.querySelector("input[name='valid_to']").value);
            const usageLimit = parseInt(form.querySelector("input[name='usage_limit']").value);
            const perUserLimit = parseInt(form.querySelector("input[name='per_user_limit']").value);

            let error = null;

            //  Kiểm tra điều kiện hợp lệ
            if (validFrom >= validTo) {
                error = " 'Ngày bắt đầu' phải nhỏ hơn 'Ngày kết thúc'.";
            } else if (type.toLowerCase() === "percent" && (value < 1 || value > 100)) {
                error = " Giá trị phần trăm phải nằm trong khoảng 1–100.";
            } else if (type.toLowerCase() === "fixed" && (value <= 0 || value > 100000)) {
                error = " Giá trị giảm cố định phải từ 1 đến 100000 VND.";
            } else if (usageLimit <= 0 || perUserLimit <= 0) {
                error = " Usage limit và per-user limit phải > 0.";
            } else if (usageLimit < perUserLimit) {
                error = " Usage limit phải >= Per-user limit.";
            }

            //  Nếu có lỗi → hiển thị alert, chặn submit
            if (error) {
                alert(error);
                e.preventDefault();
            }
        });
    }

    /* ===============  3. Thông báo hệ thống (thành công / lỗi) =============== */
    const msgContainer = document.getElementById("msg");
    if (msgContainer) {
        const message = msgContainer.dataset.message;
        const error = msgContainer.dataset.error;

        if (message) alert(message);
        if (error) alert(error);
    }
});
