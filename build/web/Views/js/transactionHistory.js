document.addEventListener("DOMContentLoaded", () => {
  const table = document.getElementById("transactionTable");
  if (!table) return;

  const tbody = table.querySelector("tbody");
  const headers = table.querySelectorAll("th");
  const searchInput = document.getElementById("searchInput");
  const sortColumn = document.getElementById("sortColumn");
  const sortOrder = document.getElementById("sortOrder");

  const rows = Array.from(tbody.querySelectorAll("tr"));
  let filteredRows = [...rows];
  const rowsPerPage = 15;
  let currentPage = 1;

  // 🧾 Render bảng theo trang
  function renderTable() {
    tbody.innerHTML = "";
    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    filteredRows.slice(start, end).forEach(r => tbody.appendChild(r));
    renderPagination();
  }

  // 🧮 Render phân trang
  function renderPagination() {
    const pagination = document.querySelector(".pagination");
    pagination.innerHTML = "";
    const totalPages = Math.ceil(filteredRows.length / rowsPerPage);
    if (totalPages <= 1) return;

    const prev = document.createElement("span");
    prev.className = "page";
    prev.textContent = "« Trước";
    prev.addEventListener("click", () => {
      if (currentPage > 1) {
        currentPage--;
        renderTable();
      }
    });
    pagination.appendChild(prev);

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

    const next = document.createElement("span");
    next.className = "page";
    next.textContent = "Sau »";
    next.addEventListener("click", () => {
      if (currentPage < totalPages) {
        currentPage++;
        renderTable();
      }
    });
    pagination.appendChild(next);
  }

  // 🔢 Hàm xử lý giá trị
  function parseValue(val) {
    if (!val) return "";
    if (!isNaN(val)) return parseFloat(val);
    if (/^\d{1,2}:\d{2}\s\d{2}\/\d{2}\/\d{4}$/.test(val)) {
      const [time, date] = val.split(" ");
      return new Date(`${date.split("/").reverse().join("-")}T${time}`).getTime();
    }
    return val.toLowerCase();
  }

  // ⚙️ Sắp xếp
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
    currentPage = 1;
    renderTable();
  }

  // 🔍 Tìm kiếm realtime
  searchInput?.addEventListener("input", () => {
    const keyword = searchInput.value.toLowerCase();
    filteredRows = rows.filter(r =>
      r.innerText.toLowerCase().includes(keyword)
    );
    currentPage = 1;
    renderTable();
  });

  // ⬆️ Click cột để sắp xếp
  headers.forEach(th => {
    th.addEventListener("click", () => {
      const index = parseInt(th.dataset.index);
      if (isNaN(index)) return;
      const currentOrder = th.classList.contains("sorted-asc") ? -1 : 1;
      sortTable(index, currentOrder);
      headers.forEach(h => h.classList.remove("sorted-asc", "sorted-desc"));
      th.classList.add(currentOrder === 1 ? "sorted-asc" : "sorted-desc");
      sortColumn.value = index;
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

  renderTable();
});
