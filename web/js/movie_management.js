/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {

    function initSearchableDropdown(selector, placeholderText, width = '200px') {
        const $el = $(selector);
        if ($el.length) {
            $el.select2({
                placeholder: placeholderText || "Select or search...",
                allowClear: true,
                width: width
            });
    }
    }

    // Áp dụng cho dropdown Actor
    initSearchableDropdown('#actorFilter', 'All');

    // Áp dụng cho Genre (thêm id trong JSP là genreFilter)
    initSearchableDropdown('#genreFilter', 'All');
});
