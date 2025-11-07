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
    document.getElementById("posterModal").style.display = "flex";
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
    document.getElementById(id).style.display = "flex"; // không dùng block
}

function closeModal(id) {
    document.getElementById(id).style.display = "none";
}


// ====== Add Genre / Actor ======
function addNewOption(selectId, inputId) {
    let value = document.getElementById(inputId).value.trim();
    if (!value)
        return;

    // Gửi AJAX lên servlet (thêm action = 'add')
    $.ajax({
        url: selectId === "genres" ? "manageGenre" : "manageActor",
        type: "POST",
        data: {action: "add", name: value}, // <-- thêm action ở đây
        success: function (data) {
            if (typeof data === "string")
                data = JSON.parse(data);

            // Thêm vào dropdown select2
            let newOption = new Option(data.name, data.id, true, true);
            $('#' + selectId).append(newOption).trigger('change');

            // Thêm dòng mới vào bảng
            let tableId = selectId === "genres" ? "#genreTableBody" : "#actorList";
            $(tableId).append(`
                <tr>
                    <td>${data.name}</td>
                    <td>
                        <button type="button" class="delete-btn"
                            onclick="removeItem(this, '${selectId}', '${data.id}')">×</button>
                    </td>
                </tr>
            `);

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
function removeItem(btn, type, id) {
    $.ajax({
        url: type === "genres" ? "manageGenre" : "manageActor",
        type: "POST",
        data: {action: "delete", id: id},
        success: function () {
            // Xóa dòng trong bảng
            $(btn).closest('tr').remove();

            // Xóa option khỏi dropdown Select2
            $('#' + type + ' option[value="' + id + '"]').remove();
            $('#' + type).trigger('change'); // Cập nhật lại select2 hiển thị
        },
        error: function () {
            alert("Error deleting " + (type === "genres" ? "genre" : "actor"));
        }
    });
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


