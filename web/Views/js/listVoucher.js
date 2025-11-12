document.addEventListener("DOMContentLoaded", () => {
  console.log("Voucher list (backend pagination) loaded");

  // ✅ Xác nhận khi bấm vô hiệu hóa voucher
  document.querySelectorAll(".btn-disable").forEach(btn => {
    btn.addEventListener("click", e => {
      if (!confirm("️Bạn có chắc muốn vô hiệu hóa voucher này?")) {
        e.preventDefault();
      }
    });
  });

  // ✅ Xác nhận khi bấm kích hoạt lại voucher
  document.querySelectorAll(".btn-activate").forEach(btn => {
    btn.addEventListener("click", e => {
      if (!confirm("Bạn có muốn kích hoạt lại voucher này?")) {
        e.preventDefault();
      }
    });
  });

  // ✅ Xác nhận khi bấm xóa (nếu có chức năng xóa hoàn toàn)
  document.querySelectorAll(".btn-delete").forEach(btn => {
    btn.addEventListener("click", e => {
      if (!confirm("Bạn có chắc muốn xóa voucher này vĩnh viễn?")) {
        e.preventDefault();
      }
    });
  });

  // ✅ In ra log khi trang tải thành công
  console.log("Voucher page ready — backend handles pagination & sorting");
});
