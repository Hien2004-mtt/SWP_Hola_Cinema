/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
    // Khởi tạo select2
    $('#genres').select2({width: '100%'});
    $('#actors').select2({width: '100%'});

    // Khi thay đổi URL poster
    $("#posterUrlInput").on("input", function () {
        let url = $(this).val().trim();
        if (url)
            $("#posterPreview").attr("src", url).show();
        else
            $("#posterPreview").hide();
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector(".movie-form");
    form.addEventListener("submit", function (e) {
        const posterUrl = document.getElementById("posterUrl").value.trim();
        if (posterUrl === "") {
            e.preventDefault(); // chặn gửi form
            alert("Poster URL cannot be empty!");
        }
    });
});

// ====== Poster ======
function openPosterModal() {
    document.getElementById("posterModal").style.display = "block";
}
function closePosterModal() {
    document.getElementById("posterModal").style.display = "none";
}
function setPoster() {
    let url = document.getElementById("posterUrlInput").value.trim();
    if (url) {
        document.getElementById("posterUrl").value = url;
        document.getElementById("posterPreview").src = url;
        document.getElementById("posterPreview").style.display = "block";
        document.getElementById("posterIcon").style.display = "none";
        document.getElementById("posterText").style.display = "none";
    }
    closePosterModal();
}

// ====== Modal Genre / Actor ======
function openModal(id) {
    document.getElementById(id).style.display = "block";
}
function closeModal(id) {
    document.getElementById(id).style.display = "none";
}

// ====== Add Genre / Actor ======
function addNewOption(selectId, inputId) {
    let value = document.getElementById(inputId).value.trim();
    if (!value)
        return;

    // Gửi AJAX lên servlet
    $.ajax({
        url: selectId === "genres" ? "addGenreAjax" : "addActorAjax",
        type: "POST",
        data: {name: value},
        success: function (data) {
            if (typeof data === "string")
                data = JSON.parse(data);

            // Thêm vào dropdown select2
            let newOption = new Option(data.name, data.id, true, true);
            $('#' + selectId).append(newOption).trigger('change');

            // Thêm dòng mới vào bảng
            let tableId = selectId === "genres" ? "#genreList" : "#actorList";
            $(tableId).append(`
                <tr>
                    <td>${data.name}</td>
                    <td>
                        <button type="button" class="delete-btn"
                            onclick="removeItem(this, '${selectId}', '${data.name}')">×</button>
                    </td>
                </tr>
            `);

            // Xóa nội dung input
            document.getElementById(inputId).value = "";
        },
        error: function (xhr) {
            if (xhr.status === 409) {
                alert("This " + (selectId === "genres" ? "genre" : "actor") + " already exists!");
            } else {
                alert("Error adding " + (selectId === "genres" ? "genre" : "actor"));
            }
        }
    });
}

// ====== Remove Genre / Actor ======
function removeItem(button, selectId, name) {
    // Xóa dòng trong bảng
    const row = button.closest('tr');
    if (row)
        row.remove();

    // Xóa option trong select
    const select = document.getElementById(selectId);
    const option = Array.from(select.options).find(opt => opt.text === name);
    if (option)
        option.remove();
}

// ====== Đóng popup khi click ra ngoài ======
window.addEventListener("click", function (event) {
    const posterModal = document.getElementById("posterModal");
    const genreModal = document.getElementById("genreModal");
    const actorModal = document.getElementById("actorModal");

    // Nếu click bên ngoài nội dung của poster modal
    if (event.target === posterModal) {
        closePosterModal();
    }

    // Nếu click bên ngoài nội dung của modal genre
    if (event.target === genreModal) {
        closeModal('genreModal');
    }

    // Nếu click bên ngoài nội dung của modal actor
    if (event.target === actorModal) {
        closeModal('actorModal');
    }
});


