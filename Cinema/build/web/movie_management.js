/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

console.log("movie_management.js loaded");

function toggleFilter() {
    const panel = document.getElementById("filter-panel");
    if (panel) {
        panel.classList.toggle("active");
        console.log("Filter toggled:", panel.classList.contains("active"));
    } else {
        console.error("Không tìm thấy phần tử #filter-panel");
    }
}

// Optional: Close filter panel when clicking outside
document.addEventListener("click", function (event) {
    const panel = document.getElementById("filter-panel");
    const toggle = document.querySelector(".filter-toggle");

    if (panel && !panel.contains(event.target) && !toggle.contains(event.target)) {
        panel.classList.remove("active");
    }
});