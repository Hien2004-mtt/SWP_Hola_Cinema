document.addEventListener("DOMContentLoaded", () => {
  console.log("Voucher list loaded ✅");

  // ️ Xác nhận vô hiệu hóa ===
  document.querySelectorAll(".btn-disable").forEach(btn => {
    btn.addEventListener("click", e => {
      if (!confirm("️Bạn có chắc muốn vô hiệu hóa voucher này?")) e.preventDefault();
    });
  });

  //  TÌM KIẾM ===
  const searchInput = document.getElementById("searchInput");
  searchInput?.addEventListener("input", () => {
    const keyword = searchInput.value.toLowerCase();
    document.querySelectorAll("tbody tr").forEach(row => {
      row.style.display = row.innerText.toLowerCase().includes(keyword) ? "" : "none";
    });
  });

  // ️ SẮP XẾP (Header + Dropdown) ===
  const table = document.getElementById("voucherTable");
  if (!table) return;
  const tbody = table.querySelector("tbody");
  const headers = table.querySelectorAll("th");
  const sortColumn = document.getElementById("sortColumn");
  const sortOrder = document.getElementById("sortOrder");

  // 🧩 Hàm parse giá trị (tự nhận dạng kiểu dữ liệu)
  function parseValue(val) {
    if (!val) return "";
    // Nếu là số
    if (!isNaN(val)) return parseFloat(val);
    // Nếu là ngày định dạng YYYY-MM-DD
    if (/^\d{4}-\d{2}-\d{2}$/.test(val)) return new Date(val).getTime();
    // Còn lại coi là chuỗi
    return val.toLowerCase();
  }

  //  Hàm sắp xếp chính
  function sortTable(index, direction = 1) {
    const rows = Array.from(tbody.querySelectorAll("tr"));

    rows.sort((a, b) => {
      const A = a.children[index]?.innerText.trim() || "";
      const B = b.children[index]?.innerText.trim() || "";

      const valA = parseValue(A);
      const valB = parseValue(B);

      if (typeof valA === "number" && typeof valB === "number") {
        return (valA - valB) * direction;
      } else {
        return valA.localeCompare(valB, "vi", { numeric: true }) * direction;
      }
    });

    // Cập nhật lại bảng
    rows.forEach(r => tbody.appendChild(r));

    // Hiển thị icon 
    headers.forEach(h => h.classList.remove("sorted-asc", "sorted-desc"));
    headers[index]?.classList.add(direction === 1 ? "sorted-asc" : "sorted-desc");
  }

  // ️ Click tiêu đề cột để sắp xếp
  headers.forEach(th => {
    th.addEventListener("click", () => {
      const index = parseInt(th.dataset.index);
      if (isNaN(index)) return;

      // Nếu click lại cùng cột thì đảo chiều
      const currentOrder = th.classList.contains("sorted-asc") ? -1 : 1;
      sortTable(index, currentOrder);

      // Cập nhật dropdown theo cột đang chọn
      sortColumn.value = index.toString();
      sortOrder.value = currentOrder === 1 ? "asc" : "desc";
    });
  });

  //  Khi đổi dropdown, tự sắp xếp
  function handleDropdownSort() {
    const index = parseInt(sortColumn.value);
    const direction = sortOrder.value === "asc" ? 1 : -1;
    if (!isNaN(index)) sortTable(index, direction);
  }

  // Gắn sự kiện
  sortColumn?.addEventListener("change", handleDropdownSort);
  sortOrder?.addEventListener("change", handleDropdownSort);

  //  Khởi tạo mặc định (tự sắp ID tăng dần lúc load)
  if (sortColumn && sortOrder) {
    sortTable(parseInt(sortColumn.value), sortOrder.value === "asc" ? 1 : -1);
  }
});
