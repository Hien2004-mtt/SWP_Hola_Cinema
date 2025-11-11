<%-- 
    Document   : movie_management
    Created on : Oct 20, 2025, 2:38:44 PM
    Author     : dinhh
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Movie Management</title>
        <link rel="stylesheet" href="css/movie_management.css">
        <link rel="stylesheet" href="css/Layout.css">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />


        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="js/movie_management.js"></script>

    </head>
    <body>
        <%@include file="../manager/sidebar.jsp" %>
        <jsp:include page="/Inculude/Header.jsp" />
        
        <div class="main-content">
        <h2 style="text-align:center;">Movie Management</h2>

        <div class="toolbar">
            <form action="movie_management" method="get" class="main-filter-form">

                <div class="toolbar-top">

                    <div class="search-form">
                        <input type="text" name="keyword" placeholder="Search by title..." value="${param.keyword}">
                        <button type="submit">Search</button> </div>

                    <a href="add_movie" class="add-btn">+ Add Movie</a>

                </div>

                <div class="toolbar-bottom">

                    <div class="filter-row filter-form">

                        <label>Genre:</label>
                        <select id="genreFilter" name="genreId">
                            <option value="">All</option>
                            <c:forEach var="g" items="${genres}">
                                <option value="${g[0]}" ${param.genreId == g[0] ? 'selected' : ''}>${g[1]}</option>
                            </c:forEach>
                        </select>

                        <label>Actor:</label>
                        <select id="actorFilter" name="actorId">
                            <option value="">All</option>
                            <c:forEach var="a" items="${actors}">
                                <option value="${a[0]}" ${param.actorId == a[0] ? 'selected' : ''}>${a[1]}</option>
                            </c:forEach>
                        </select>

                        <label>Rating:</label>
                        <select name="rating">
                            <option value="">All</option>
                            <option value="G" ${param.rating == 'G' ? 'selected' : ''}>G</option>
                            <option value="PG" ${param.rating == 'PG' ? 'selected' : ''}>PG</option>
                            <option value="PG-13" ${param.rating == 'PG-13' ? 'selected' : ''}>PG-13</option>
                            <option value="R" ${param.rating == 'R' ? 'selected' : ''}>R</option>
                        </select>

                        <label>Status:</label>
                        <select name="status">
                            <option value="">All</option>
                            <option value="coming soon" ${param.status == 'coming soon' ? 'selected' : ''}>Coming Soon</option>
                            <option value="now showing" ${param.status == 'now showing' ? 'selected' : ''}>Now Showing</option>
                            <option value="archived" ${param.status == 'archived' ? 'selected' : ''}>Archived</option>
                        </select>

                        <label>Director:</label>
                        <input type="text" name="director" placeholder="Director name..." value="${param.director}">

                        <button type="submit" class="filter-btn">Apply Filter</button> <a href="movie_management" class="reset-btn">Reset</a>
                    </div>

                </div>

            </form> </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Poster</th>
                    <th>Title</th>
                    <th>Rating</th>
                    <th>Language</th>
                    <th>Duration</th>
                    <th>Genres</th>
                    <th>Actors</th>
                    <th>Release Date</th>
                    <th>Status</th>
                    <th>Director</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="movie" items="${movieList}">
                    <tr>
                        <td>${movie.movieId}</td>
                        <td>
                            <c:if test="${not empty movie.posterUrl}">
                                <img src="${movie.posterUrl}" alt="poster" style="width:60px; height:auto;">
                            </c:if>
                        </td>
                        <td>${movie.title}</td>
                        <td>${movie.rating}</td>
                        <td>${movie.language}</td>
                        <td>${movie.durationMinutes} min</td>
                        <td>
                            <c:forEach var="g" items="${movieGenres[movie.movieId]}" varStatus="loop">
                                ${g}<c:if test="${!loop.last}">, </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <c:forEach var="a" items="${movieActors[movie.movieId]}" varStatus="loop">
                                ${a}<c:if test="${!loop.last}">, </c:if>
                            </c:forEach>
                        </td>
                        <td>${movie.releaseDate}</td>
                        <td>${movie.status}</td>
                        <td>${movie.directorName}</td>
                        <td>
                            <a href="edit_movie?movieId=${movie.movieId}" class="btn btn-edit">Edit</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- Nếu không có kết quả -->
        <c:if test="${empty movieList}">
            <p style="text-align:center; color:gray;">No movies found.</p>
        </c:if>

        <!-- Pagination -->
        <div class="pagination">
            <!-- Previous -->
            <c:url var="prevUrl" value="movie_management">
                <c:param name="page" value="${currentPage - 1}" />
                <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                <c:if test="${not empty genreId}"><c:param name="genreId" value="${genreId}" /></c:if>
                <c:if test="${not empty actorId}"><c:param name="actorId" value="${actorId}" /></c:if>
                <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                <c:if test="${not empty director}"><c:param name="director" value="${director}" /></c:if>
            </c:url>
            <a href="${prevUrl}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">Previous</a>

            <!-- Logic hiển thị trang -->
            <c:set var="startPage" value="${currentPage - 2}" />
            <c:set var="endPage" value="${currentPage + 2}" />

            <c:if test="${startPage < 1}">
                <c:set var="endPage" value="${endPage + (1 - startPage)}" />
                <c:set var="startPage" value="1" />
            </c:if>
            <c:if test="${endPage > totalPages}">
                <c:set var="startPage" value="${startPage - (endPage - totalPages)}" />
                <c:set var="endPage" value="${totalPages}" />
            </c:if>
            <c:if test="${startPage < 1}">
                <c:set var="startPage" value="1" />
            </c:if>

            <!-- Hiển thị trang đầu + dấu ... -->
            <c:if test="${startPage > 1}">
                <c:url var="firstPageUrl" value="movie_management">
                    <c:param name="page" value="1" />
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                    <c:if test="${not empty genreId}"><c:param name="genreId" value="${genreId}" /></c:if>
                    <c:if test="${not empty actorId}"><c:param name="actorId" value="${actorId}" /></c:if>
                    <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                    <c:if test="${not empty director}"><c:param name="director" value="${director}" /></c:if>
                </c:url>
                <a href="${firstPageUrl}" class="page-number">1</a>
                <span class="dots">...</span>
            </c:if>

            <!-- Hiển thị các trang chính -->
            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                <c:url var="pageUrl" value="movie_management">
                    <c:param name="page" value="${i}" />
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                    <c:if test="${not empty genreId}"><c:param name="genreId" value="${genreId}" /></c:if>
                    <c:if test="${not empty actorId}"><c:param name="actorId" value="${actorId}" /></c:if>
                    <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                    <c:if test="${not empty director}"><c:param name="director" value="${director}" /></c:if>
                </c:url>
                <a href="${pageUrl}" class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
            </c:forEach>

            <!-- Hiển thị trang cuối + dấu ... -->
            <c:if test="${endPage < totalPages}">
                <span class="dots">...</span>
                <c:url var="lastPageUrl" value="movie_management">
                    <c:param name="page" value="${totalPages}" />
                    <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                    <c:if test="${not empty genreId}"><c:param name="genreId" value="${genreId}" /></c:if>
                    <c:if test="${not empty actorId}"><c:param name="actorId" value="${actorId}" /></c:if>
                    <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                    <c:if test="${not empty director}"><c:param name="director" value="${director}" /></c:if>
                </c:url>
                <a href="${lastPageUrl}" class="page-number">${totalPages}</a>
            </c:if>

            <!-- Next -->
            <c:url var="nextUrl" value="movie_management">
                <c:param name="page" value="${currentPage + 1}" />
                <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}" /></c:if>
                <c:if test="${not empty genreId}"><c:param name="genreId" value="${genreId}" /></c:if>
                <c:if test="${not empty actorId}"><c:param name="actorId" value="${actorId}" /></c:if>
                <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                <c:if test="${not empty director}"><c:param name="director" value="${director}" /></c:if>
            </c:url>
            <a href="${nextUrl}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">Next</a>
        </div>
        </div>
        <jsp:include page="/Inculude/Footer.jsp" />
    </body>
</html>