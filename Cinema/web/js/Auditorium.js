/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
        function filterAuditoriums() {
            var input = document.getElementById('auditoriumSearch');
            var filter = input.value.toLowerCase();
            var table = document.getElementsByTagName('table')[0];
            var trs = table.getElementsByTagName('tr');

            for (var i = 1; i < trs.length; i++) { // bỏ qua hàng tiêu đề
                var tds = trs[i].getElementsByTagName('td');
                if (tds.length >= 2) {
                    var idText = (tds[0].textContent || tds[0].innerText).toLowerCase();
                    var nameText = (tds[1].textContent || tds[1].innerText).toLowerCase();
                    if (idText.indexOf(filter) > -1 || nameText.indexOf(filter) > -1) {
                        trs[i].style.display = '';
                    } else {
                        trs[i].style.display = 'none';
                    }
                }
            }
        }

