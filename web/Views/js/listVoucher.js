document.addEventListener("DOMContentLoaded", () => {
    console.log("Voucher list loaded ");

    // ⚙️ Vô hiệu hóa / kích hoạt xác nhận
    document.querySelectorAll(".btn-disable").forEach(btn => {
        btn.addEventListener("click", e => {
            if (!confirm("️ Bạn có chắc muốn vô hiệu hóa voucher này?")) e.preventDefault();
        });
    });
    document.querySelectorAll(".btn-activate").forEach(btn => {
        btn.addEventListener("click", e => {
            if (!confirm(" Kích hoạt lại voucher này?")) e.preventDefault();
        });
    });

    // 🔍 SEARCH — lọc theo từ khóa trong bất kỳ cột nào
    const searchInput = document.getElementById("searchInput");
    searchInput?.addEventListener("input", () => {
        const keyword = searchInput.value.toLowerCase();
        const rows = document.querySelectorAll("tbody tr");

        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(keyword) ? "" : "none";
        });
    });

    // ↕️ CLICK SORT — sắp xếp khi click tiêu đề cột
    const table = document.getElementById("voucherTable");
    if (!table) return;

    const headers = table.querySelectorAll("th");
    let sortDirection = 1; // 1 = ASC, -1 = DESC
    let activeIndex = null;

    headers.forEach(th => {
        th.addEventListener("click", () => {
            const index = parseInt(th.dataset.index);
            const tbody = table.querySelector("tbody");
            const rows = Array.from(tbody.querySelectorAll("tr"));

            // Nếu click cùng cột => đảo chiều sắp xếp
            if (activeIndex === index) sortDirection *= -1;
            else {
                sortDirection = 1;
                activeIndex = index;
            }

            // Sắp xếp dữ liệu
            rows.sort((a, b) => {
                const A = a.children[index].innerText.trim().toLowerCase();
                const B = b.children[index].innerText.trim().toLowerCase();

                const numA = parseFloat(A.replace(/[^\d.]/g, ""));
                const numB = parseFloat(B.replace(/[^\d.]/g, ""));
                const compare = isNaN(numA) || isNaN(numB)
                    ? A.localeCompare(B)
                    : numA - numB;

                return compare * sortDirection;
            });

            // Cập nhật lại bảng
            rows.forEach(r => tbody.appendChild(r));

            // Reset icon hiển thị
            headers.forEach(h => h.classList.remove("sorted-asc", "sorted-desc"));
            th.classList.add(sortDirection === 1 ? "sorted-asc" : "sorted-desc");
        });
    });
});
