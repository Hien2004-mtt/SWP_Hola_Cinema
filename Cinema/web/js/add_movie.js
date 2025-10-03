/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
    // Khởi tạo select2 cho genres và actors
    $('#genres').select2({ width: '100%' });
    $('#actors').select2({ width: '100%' });

    // Preview poster khi nhập URL
    $("#posterUrl").on("input", function () {
        let url = $(this).val();
        if (url) {
            $("#posterPreview").attr("src", url).show();
        } else {
            $("#posterPreview").hide();
        }
    });
});

// Mở modal
function openModal(id) {
    document.getElementById(id).style.display = "block";
}

// Đóng modal
function closeModal(id) {
    document.getElementById(id).style.display = "none";
}

// Thêm option mới vào select (genre hoặc actor)
function addNewOption(selectId, inputId) {
    let value = document.getElementById(inputId).value.trim();
    if (value) {
        // Kiểm tra trùng lặp
        let exists = $('#' + selectId + ' option').filter(function () {
            return $(this).text().toLowerCase() === value.toLowerCase();
        }).length > 0;

        if (!exists) {
            let newOption = new Option(value, value, true, true);
            $('#' + selectId).append(newOption).trigger('change');
        }

        // Reset input và đóng modal
        document.getElementById(inputId).value = "";
        closeModal(selectId === "genres" ? "genreModal" : "actorModal");
    }
}

function openPosterModal() {
    document.getElementById("posterModal").style.display = "block";
}

function closePosterModal() {
    document.getElementById("posterModal").style.display = "none";
}

function setPoster() {
    let url = document.getElementById("posterUrlInput").value.trim();
    if (url) {
        // Gán URL vào trường input ẩn
        document.getElementById("posterUrl").value = url;
        
        // Hiển thị poster preview
        document.getElementById("posterPreview").src = url;
        document.getElementById("posterPreview").style.display = "block";
        document.getElementById("posterIcon").style.display = "none";
        document.getElementById("posterText").style.display = "none";
    }
    closePosterModal();
}   
            
