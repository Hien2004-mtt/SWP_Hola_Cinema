/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", function () {

    // Mở popup
    window.openModal = function (id) {
        const modal = document.getElementById("movieModal-" + id);
        if (modal)
            modal.style.display = "flex";
    };

    // Đóng popup
    window.closeModal = function (id) {
        const modal = document.getElementById("movieModal-" + id);
        if (modal)
            modal.style.display = "none";

        // Dừng trailer khi đóng popup
        const iframe = modal.querySelector("iframe");
        if (iframe)
            iframe.src = iframe.src;
    };

    // Đóng khi click ra ngoài
    window.onclick = function (event) {
        const modals = document.getElementsByClassName("modal");
        for (let m of modals) {
            if (event.target === m) {
                m.style.display = "none";
                const iframe = m.querySelector("iframe");
                if (iframe)
                    iframe.src = iframe.src;
            }
        }
    };

    window.bookTicket = function (id, title) {
        alert(`You selected "${title}"!\n(You can link this to booking.jsp later.)`);
    };
});
