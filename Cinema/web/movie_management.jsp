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
        <h2 style="text-align:center;">🎬 Movie Management</h2>

        <div class="toolbar">
            <form action="MovieManagement" method="get" class="search-form">
                <input type="text" name="keyword" placeholder="Search by title..." value="${param.keyword}">
                <button type="submit">Search</button>
            </form>
                
            <form action="add_movie" method="get" style="display:inline;">
                <button type="submit" class="add-btn">+ Add Movie</button>
            </form>
        </div>

        <table>
            <tr>
                <th>ID</th>
                <th>Poster</th>
                <th>Title</th>
                <th>Language</th>
                <th>Duration</th>
                <th>Release Date</th>
                <th>Status</th>
                <th>Director</th>
                <th>Action</th>
            </tr>

            <c:forEach var="movie" items="${movieList}">
                <tr>
                    <td>${movie.movieId}</td>
                    <td>
                        <c:if test="${not empty movie.posterUrl}">
                            <img src="${movie.posterUrl}" alt="poster">
                        </c:if>
                    </td>
                    <td>${movie.title}</td>
                    <td>${movie.language}</td>
                    <td>${movie.durationMinutes} min</td>
                    <td>${movie.releaseDate}</td>
                    <td>${movie.status}</td>
                    <td>${movie.directorName}</td>
                    <td>
                        <a href="edit_movie?movieId=${movie.movieId}" class="btn btn-edit">Edit</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </body>
</html>