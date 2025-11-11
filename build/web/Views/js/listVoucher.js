document.addEventListener("DOMContentLoaded", () => {
  console.log("Voucher list loaded ");

  // ️ Xác nhận vô hiệu hóa
  document.querySelectorAll(".btn-disable").forEach(btn => {
    btn.addEventListener("click", e => {
      if (!confirm("️Bạn có chắc muốn vô hiệu hóa voucher này?")) e.preventDefault();
    });
  });

  const table = document.getElementById("voucherTable");
  if (!table) return;
  const tbody = table.querySelector("tbody");
  const headers = table.querySelectorAll("th");
  const searchInput = document.getElementById("searchInput");
  const sortColumn = document.getElementById("sortColumn");
  const sortOrder = document.getElementById("sortOrder");

  const rows = Array.from(tbody.querySelectorAll("tr"));
  const rowsPerPage = 15;
  let currentPage = 1;
  let filteredRows = [...rows];

  // 🧮 Cập nhật hiển thị bảng theo trang
  function renderTable() {
    tbody.innerHTML = "";
    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    filteredRows.slice(start, end).forEach(r => tbody.appendChild(r));
    renderPagination();
  }

  // 🧾 Phân trang động
  function renderPagination() {
    let pagination = document.querySelector(".pagination");
    if (!pagination) {
      pagination = document.createElement("div");
      pagination.classList.add("pagination");
      table.insertAdjacentElement("afterend", pagination);
    }
    pagination.innerHTML = "";

    const totalPages = Math.ceil(filteredRows.length / rowsPerPage);

    for (let i = 1; i <= totalPages; i++) {
      const btn = document.createElement("span");
      btn.className = "page " + (i === currentPage ? "active" : "");
      btn.textContent = i;
      btn.addEventListener("click", () => {
        currentPage = i;
        renderTable();
      });
      pagination.appendChild(btn);
    }
  }

  // 🧩 Hàm parse giá trị (để sắp xếp thông minh)
  function parseValue(val) {
    if (!val) return "";
    if (!isNaN(val)) return parseFloat(val);
    if (/^\d{4}-\d{2}-\d{2}$/.test(val)) return new Date(val).getTime();
    return val.toLowerCase();
  }

  // ⚙️ Hàm sắp xếp
  function sortTable(index, direction = 1) {
    filteredRows.sort((a, b) => {
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

    headers.forEach(h => h.classList.remove("sorted-asc", "sorted-desc"));
    headers[index]?.classList.add(direction === 1 ? "sorted-asc" : "sorted-desc");
    currentPage = 1;
    renderTable();
  }

  // 🔍 Tìm kiếm
  searchInput?.addEventListener("input", () => {
    const keyword = searchInput.value.toLowerCase();
    filteredRows = rows.filter(r =>
      r.innerText.toLowerCase().includes(keyword)
    );
    currentPage = 1;
    renderTable();
  });

  // 🔼 Sắp xếp khi click tiêu đề
  headers.forEach(th => {
    th.addEventListener("click", () => {
      const index = parseInt(th.dataset.index);
      if (isNaN(index)) return;
      const currentOrder = th.classList.contains("sorted-asc") ? -1 : 1;
      sortTable(index, currentOrder);
      sortColumn.value = index.toString();
      sortOrder.value = currentOrder === 1 ? "asc" : "desc";
    });
  });

  // Khi đổi dropdown
  function handleDropdownSort() {
    const index = parseInt(sortColumn.value);
    const direction = sortOrder.value === "asc" ? 1 : -1;
    if (!isNaN(index)) sortTable(index, direction);
  }

  sortColumn?.addEventListener("change", handleDropdownSort);
  sortOrder?.addEventListener("change", handleDropdownSort);

  // 🏁 Khởi tạo
  renderTable();
});
