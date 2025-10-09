/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
    // Khởi tạo select2 cho genres và actors
    $('#genres').select2({ width: '100%' });
    $('#actors').select2({ width: '100%' });

    // Khi thay đổi URL poster trong modal
    $("#posterUrlInput").on("input", function () {
        let url = $(this).val().trim();
        if (url) {
            $("#posterPreview").attr("src", url).show();
        } else {
            $("#posterPreview").hide();
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

// ====== Add + Manage Genre / Actor ======
function addNewOption(selectId, inputId, listId) {
    let value = document.getElementById(inputId).value.trim();
    if (value) {
        // Kiểm tra trùng lặp
        let exists = $('#' + selectId + ' option').filter(function () {
            return $(this).text().toLowerCase() === value.toLowerCase();
        }).length > 0;

        if (exists) {
            alert("This name already exists!");
            return;
        }

        // Thêm vào select
        let newOption = new Option(value, value, true, true);
        $('#' + selectId).append(newOption).trigger('change');

        // Thêm vào danh sách hiển thị
        const list = document.getElementById(listId);
        const item = document.createElement("div");
        item.className = "item-tag";
        item.innerHTML = `${value} <button type="button" class="remove-btn" onclick="removeItem(this, '${selectId}', '${value}')">&times;</button>`;
        list.appendChild(item);

        // Reset input và đóng modal
        document.getElementById(inputId).value = "";
        closeModal(selectId === "genres" ? "genreModal" : "actorModal");
    }
}

// ====== Remove Genre / Actor ======
function removeItem(button, selectId, name) {
    // Xóa phần tử hiển thị
    button.parentElement.remove();

    // Xóa trong select2
    const select = document.getElementById(selectId);
    for (let i = 0; i < select.options.length; i++) {
        if (select.options[i].text === name) {
            select.remove(i);
            break;
        }
    }
    $('#' + selectId).trigger('change');
}


