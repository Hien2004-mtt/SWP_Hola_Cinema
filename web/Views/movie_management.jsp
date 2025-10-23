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
    </head>
    <body>
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
                        <select name="genreId">
                            <option value="">All</option>
                            <c:forEach var="g" items="${genres}">
                                <option value="${g[0]}" ${param.genreId == g[0] ? 'selected' : ''}>${g[1]}</option>
                            </c:forEach>
                        </select>

                        <label>Actor:</label>
                        <select name="actorId">
                            <option value="">All</option>
                            <c:forEach var="a" items="${actors}">
                                <option value="${a[0]}" ${param.actorId == a[0] ? 'selected' : ''}>${a[1]}</option>
                            </c:forEach>
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
    </body>
</html>